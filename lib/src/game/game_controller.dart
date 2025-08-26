import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:orne_library/src/game/game_setup.dart';
import 'package:orne_library/src/game/game_state.dart';
import 'package:orne_library/src/game/character_library.dart';
import 'package:orne_library/src/game/player.dart';
import 'package:orne_library/src/game/character_identifier.dart';
import 'package:orne_library/src/game/tile_library.dart';
import 'package:orne_library/src/game/card_identifier.dart';
import 'package:orne_library/src/game/card_library.dart';
import 'package:orne_library/src/game/card_type.dart';
import 'package:orne_library/src/game/map_generator.dart';
import 'package:orne_library/src/game/game_status.dart';
import 'package:orne_library/src/game/tile_type.dart';

part 'game_controller.g.dart';

@riverpod
class GameController extends _$GameController {
  Player get _currentPlayer => state.players[state.currentPlayerIndex];

  @override
  GameState build(GameSetup setup) {
    // Generate the map layout
    final mapLayout = MapGenerator().generate();
    final initialGrid = mapLayout.grid;
    final startPosition = mapLayout.playerStartPosition;

    final List<Player> players = [];
    for (int i = 0; i < setup.characterIds.length; i++) {
      final characterId = setup.characterIds[i];
      final characterData = CharacterLibrary.characters[characterId]!;

      // Set up the player's starting deck
      final playerDeck = List<CardIdentifier>.from(characterData.startingDeck);
      playerDeck.shuffle();

      // Draw the starting hand
      final playerHand =
          playerDeck.take(characterData.startingHandSize).toList();
      final playerDrawPile =
          playerDeck.skip(characterData.startingHandSize).toList();

      players.add(Player(
          playerIndex: i,
          characterId: characterId,
          x: startPosition.x,
          y: startPosition.y,
          handSize: characterData.startingHandSize,
          hand: playerHand,
          drawPile: playerDrawPile));
    }

    // Create an initial seen grid, all false
    final initialSeen = List.generate(
      initialGrid.length,
      (_) => List.generate(initialGrid.first.length, (_) => false),
    );

    // Reveal special rooms from the start.
    for (var y = 0; y < initialGrid.length; y++) {
      for (var x = 0; x < initialGrid[y].length; x++) {
        final tileType = initialGrid[y][x];
        if (tileType == TileType.EntranceHall ||
            tileType == TileType.MainReadingRoom) {
          initialSeen[y][x] = true;
        }
      }
    }

    // Reveal the area around all starting players
    var seenWithPlayers = initialSeen;
    for (final player in players) {
      seenWithPlayers = _updateSeenGrid(
          seenWithPlayers, player, initialGrid.first.length, initialGrid.length);
    }

    // Create and shuffle the main deck of Archive cards.
    final baseArchiveCards = CardLibrary.cards.entries
        .where((entry) => entry.value.type == CardType.Archive)
        .map((entry) => entry.key)
        .toList();

    final allArchiveCards = <CardIdentifier>[];
    for (int i = 0; i < setup.deckMultiplier; i++) {
      allArchiveCards.addAll(baseArchiveCards);
    }
    allArchiveCards.shuffle();

    // Find all possible locations for the manuscript
    final hiddenChamberLocations = <Point<int>>[];
    for (var y = 0; y < initialGrid.length; y++) {
      for (var x = 0; x < initialGrid[y].length; x++) {
        if (initialGrid[y][x] == TileType.HiddenChamber) {
          hiddenChamberLocations.add(Point(x, y));
        }
      }
    }

    // Randomly select one to be the manuscript location
    final manuscriptLocation = hiddenChamberLocations.isNotEmpty
        ? hiddenChamberLocations[Random().nextInt(hiddenChamberLocations.length)]
        : const Point(0, 0); // Fallback if no hidden chambers

    // Set up the Archive market and supply
    final initialMarket = allArchiveCards.take(6).toList();
    final initialSupply = allArchiveCards.skip(6).toList();

    return GameState(
      grid: initialGrid,
      players: players,
      seen: seenWithPlayers,
      archiveMarket: initialMarket,
      archiveSupply: initialSupply,
      tomeLocation: manuscriptLocation,
    );
  }

  /// Resets the score to 0.
  void reset() {
    state = build(
        GameSetup(characterIds: state.players.map((p) => p.characterId).toList()));
  }

  void playCard(CardIdentifier cardId, int indexInHand) {
    if (state.gameStatus == GameStatus.won) return;

    var player = _currentPlayer;
    if (player.actions < 1) {
      state =
          state.copyWith(userMessages: ["You have no actions left to play a card."]);
      return;
    }

    final cardData = CardLibrary.cards[cardId]!;
    final hand = List<CardIdentifier>.from(player.hand);
    final playedCard = hand.removeAt(indexInHand);

    // Apply card effects
    player = player.copyWith(
      actions: player.actions - 1 + cardData.actions,
      insight: player.insight + cardData.insight,
      footwork: player.footwork + cardData.footwork,
      hand: hand,
      discardPile: [...player.discardPile, playedCard],
    );

    // Handle card draw effect
    if (cardData.cards > 0) {
      player = _drawCards(player, cardData.cards);
    }

    final newPlayers = List<Player>.from(state.players);
    newPlayers[state.currentPlayerIndex] = player;
    state = state.copyWith(players: newPlayers);

    // Check for win condition after playing a card.
    _checkForWin();
  }

  void endTurn() {
    if (state.gameStatus == GameStatus.won) return;

    // 1. Check for win condition before cleaning up.
    _checkForWin();
    // If the game was just won, stop here. The UI listener will handle the dialog.
    if (state.gameStatus == GameStatus.won) return;

    var player = _currentPlayer;

    // 2. End of Turn Effects Phase (before clearing resources)
    final tileType = state.grid[player.y][player.x];
    switch (tileType) {
      case TileType.PeriodicalsArchive:
        // Rule: "When you end your move here, you may pay 1 Insight to draw 1 card."
        // For now, this triggers automatically if the player can afford it.
        if (player.insight >= 1) {
          state = state.copyWith(userMessages: ["Paid 1 Insight, drew 1 card."]);
          player = _drawCards(player.copyWith(insight: player.insight - 1), 1);
        }
        break;
      case TileType.CartographyDepartment:
        // Rule: "When you end your move here, you gain +1 Footwork on your next turn."
        state = state.copyWith(userMessages: ["Gained +1 Footwork for next turn."]);
        player = player.copyWith(nextTurnFootworkBonus: 1);
        break;
      case TileType.RestrictedSection:
        // Rule: "If you end your move here, gain 1 Tome and 1 Whispers of Madness card."

        // Find all available Tomes and Madness cards from the library
        final allTomes = CardLibrary.cards.entries
            .where((entry) => entry.value.type == CardType.Tome)
            .map((entry) => entry.key)
            .toList();
        final allMadness = CardLibrary.cards.entries
            .where((entry) => entry.value.type == CardType.Madness)
            .map((entry) => entry.key)
            .toList();

        if (allTomes.isNotEmpty && allMadness.isNotEmpty) {
          final tomeGained = allTomes[Random().nextInt(allTomes.length)];
          final madnessGained = allMadness[Random().nextInt(allMadness.length)];
          state = state
              .copyWith(userMessages: ["Gained a Tome and a Madness card."]);
          player = player.copyWith(
              discardPile: [...player.discardPile, tomeGained, madnessGained]);
        }
        break;
      default: // No end-of-turn effect on other tiles
        break;
    }

    // 3. Cleanup Phase: move hand to discard, clear resources.
    final newDiscard = [...player.discardPile, ...player.hand];

    // 4. Draw Phase: draw a new hand of cards.
    final playerAfterDraw = _drawCards(
        player.copyWith(
            drawPile: player.drawPile, discardPile: newDiscard, hand: []),
        player.handSize);

    // 5. Reset for next turn
    final newPlayer = playerAfterDraw.copyWith(
      insight: 0,
      footwork: playerAfterDraw.nextTurnFootworkBonus, // Apply bonus
      actions: 1, // Reset to 1 action
      nextTurnFootworkBonus: 0, // Clear bonus for future turns
      hasUsedCharacterAbilityThisTurn: false, // Reset ability usage
    );

    // 6. Advance to the next player
    final nextPlayerIndex = (state.currentPlayerIndex + 1) % state.players.length;

    final newPlayers = List<Player>.from(state.players);
    newPlayers[state.currentPlayerIndex] = newPlayer;
    state = state.copyWith(players: newPlayers, currentPlayerIndex: nextPlayerIndex);
  }

  void buyCard(CardIdentifier cardId, int indexInMarket) {
    final player = _currentPlayer;
    final cardData = CardLibrary.cards[cardId]!;
    final playerTile = state.grid[player.y][player.x];

    // 1. Check if player is in the Main Reading Room
    if (playerTile != TileType.MainReadingRoom) {
      state = state.copyWith(
          userMessages: ["You must be in the Main Reading Room to buy cards."]);
      return;
    }

    // 2. Check if player can afford the card
    if (player.insight < cardData.cost) {
      state = state.copyWith(userMessages: ["Not enough Insight."]);
      return;
    }

    // 3. Perform the transaction
    final newPlayer = player.copyWith(
      insight: player.insight - cardData.cost,
      discardPile: [...player.discardPile, cardId],
    );

    // 4. Refill the market
    final newMarket = List<CardIdentifier>.from(state.archiveMarket);
    final newSupply = List<CardIdentifier>.from(state.archiveSupply);

    if (newSupply.isNotEmpty) {
      // Replace the bought card with the next from the supply
      newMarket[indexInMarket] = newSupply.removeAt(0);
    } else {
      // If supply is empty, just remove the card (or handle as per rules)
      newMarket.removeAt(indexInMarket);
    }

    final newPlayers = List<Player>.from(state.players);
    newPlayers[state.currentPlayerIndex] = newPlayer;

    state = state.copyWith(
        players: newPlayers, archiveMarket: newMarket, archiveSupply: newSupply);

  }

  void useTileAction() {
    if (state.gameStatus == GameStatus.won) return;

    var player = _currentPlayer;
    if (player.actions < 1) {
      state = state.copyWith(userMessages: ["You have no actions left."]);
      return;
    }

    final tileType = state.grid[player.y][player.x];
    var newSeen = state.seen;

    // Use a switch to handle different tile abilities
    switch (tileType) {
      case TileType.FoundersPortraitGallery:
        state = state.copyWith(userMessages: ["Gained 2 Insight."]);
        player = player.copyWith(insight: player.insight + 2);
        break;
      case TileType.RareBookRoom:
        state = state.copyWith(userMessages: ["Drew 1 card."]);
        player = _drawCards(player, 1);
        break;
      case TileType.JanitorialCloset:
        // Rule: "You may spend 3 Footwork to move from this tile to any other "Janitorial Closet" tile in play."
        const footworkCost = 3;
        if (player.footwork < footworkCost) {
          state = state.copyWith(userMessages: ["Requires 3 Footwork."]);
          return; // Don't consume action if you can't pay the cost
        }

        // Find all other closets
        final otherClosets = <Point<int>>[];
        for (var y = 0; y < state.gridHeight; y++) {
          for (var x = 0; x < state.gridWidth; x++) {
            if (state.grid[y][x] == TileType.JanitorialCloset &&
                (x != player.x || y != player.y)) {
              otherClosets.add(Point(x, y));
            }
          }
        }

        if (otherClosets.isEmpty) {
          state = state.copyWith(
              userMessages: ["No other Janitorial Closets to travel to."]);
          return; // Don't consume action if there's nowhere to go
        }

        // For now, travel to the first one found. A real implementation might offer a choice.
        final destination = otherClosets.first;
        state = state.copyWith(userMessages: ["Traveled to another closet."]);

        player = player.copyWith(
          x: destination.x,
          y: destination.y,
          footwork: player.footwork - footworkCost,
        );

        // Update seen grid at new location
        newSeen = _updateSeenGrid(state.seen, player, state.gridWidth, state.gridHeight);
        break;
      default:
        return; // Don't consume an action if there's no ability
    }

    final newPlayers = List<Player>.from(state.players);
    newPlayers[state.currentPlayerIndex] = player.copyWith(actions: player.actions - 1);
    state = state.copyWith(players: newPlayers, seen: newSeen);
  }

  void clearUserMessages() {
    state = state.copyWith(userMessages: []);
  }

  void useCharacterAbility() {
    if (state.gameStatus == GameStatus.won) return;

    var player = _currentPlayer;

    if (player.hasUsedCharacterAbilityThisTurn) {
      state = state.copyWith(userMessages: ["Ability already used this turn."]);
      return;
    }

    // Use a switch to handle different character abilities
    switch (player.characterId) {
      case CharacterIdentifier.drAlistairFinch:
        // Ability: Once per turn, spend 2 Insight to gain 1 Action.
        const insightCost = 2;
        if (player.insight < insightCost) {
          state = state.copyWith(userMessages: ["Requires 2 Insight."]);
          return;
        }

        state = state.copyWith(userMessages: ["Used Ability: Gained 1 Action."]);
        player = player.copyWith(
          insight: player.insight - insightCost,
          actions: player.actions + 1,
          hasUsedCharacterAbilityThisTurn: true,
        );
        break;
      case CharacterIdentifier.eleanorVance:
        // Ability: Once per turn, discard a card to draw a card.
        if (player.hand.isEmpty) {
          state = state.copyWith(userMessages: ["No cards in hand to discard."]);
          return;
        }
        state = state.copyWith(userMessages: ["Used Ability: Discarded 1, drew 1."]);
        // For now, discard the first card. A real implementation might let the user choose.
        final hand = List<CardIdentifier>.from(player.hand);
        final discardedCard = hand.removeAt(0);
        player = _drawCards(player, 1).copyWith(
            hand: hand, discardPile: [...player.discardPile, discardedCard], hasUsedCharacterAbilityThisTurn: true);
        break;
      case CharacterIdentifier.julianBlackwood:
        // Ability: Once per turn, trash a Madness card from your hand to gain 2 Insight.

        final hand = List<CardIdentifier>.from(player.hand);
        final madnessCardIndex = hand.indexWhere(
            (cardId) => CardLibrary.cards[cardId]!.type == CardType.Madness);

        if (madnessCardIndex == -1) {
          state = state.copyWith(userMessages: ["No Madness card in hand."]);
          return;
        }

        state = state.copyWith(userMessages: ["Used Ability: Trashed Madness for 2 Insight."]);
        hand.removeAt(madnessCardIndex); // Trashing the card

        player = player.copyWith(
          hand: hand,
          insight: player.insight + 2,
          hasUsedCharacterAbilityThisTurn: true,
        );
        break;
      case CharacterIdentifier.mrSilasCroft:
        // Ability: Once per turn, gain 1 Insight and 1 Footwork.

        state = state.copyWith(userMessages: ["Used Ability: Gained 1 Insight and 1 Footwork."]);
        player = player.copyWith(
          insight: player.insight + 1,
          footwork: player.footwork + 1,
          hasUsedCharacterAbilityThisTurn: true,
        );
        break;
      case CharacterIdentifier.adelaideHayes:
        // Ability: Once per turn, spend 2 Insight to draw 2 cards.
        const insightCost = 2;
        if (player.insight < insightCost) {
          state = state.copyWith(userMessages: ["Requires 2 Insight."]);
          return;
        }

        state = state.copyWith(userMessages: ["Used Ability: Paid 2 Insight, drew 2 cards."]);
        player = _drawCards(player, 2).copyWith(
          insight: player.insight - insightCost,
          hasUsedCharacterAbilityThisTurn: true,
        );
        break;
      default:
        return;
    }
    final newPlayers = List<Player>.from(state.players);
    newPlayers[state.currentPlayerIndex] = player;
    state = state.copyWith(players: newPlayers);
  }

  void moveUp() => _movePlayer(0, -1);
  void moveDown() => _movePlayer(0, 1);
  void moveLeft() => _movePlayer(-1, 0);
  void moveRight() => _movePlayer(1, 0);

  void _movePlayer(int dx, int dy) {
    // Don't allow movement if the game is already won.
    if (state.gameStatus == GameStatus.won) {
      return;
    }

    final currentPlayer = _currentPlayer;

    final currentTileType = state.grid[currentPlayer.y][currentPlayer.x];

    // Determine movement cost based on the current tile.
    int moveCost = 1;
    if (currentTileType == TileType.StudyCarrels) {
      moveCost = 2;
    }

    // Check if the player has enough footwork to move.
    if (currentPlayer.footwork < moveCost) {
      state = state.copyWith(
          userMessages: ["Requires $moveCost Footwork to move."]);
      return;
    }

    final newX = currentPlayer.x + dx;
    final newY = currentPlayer.y + dy;

    // Check grid boundaries
    if (newX < 0 ||
        newX >= state.gridWidth ||
        newY < 0 ||
        newY >= state.gridHeight) {
      return; // Out of bounds
    }

    // Check for obstacles by looking up the tile data in the library
    final targetTileType = state.grid[newY][newX];
    if (!TileLibrary.tiles[targetTileType]!.isWalkable) {
      return; // Collided with a non-walkable tile
    }

    // If the move is valid, update the player position
    var newPlayer = currentPlayer.copyWith(
        x: newX, y: newY, footwork: currentPlayer.footwork - moveCost);

    // --- Check for On-Enter Tile Effects ---
    if (targetTileType == TileType.MicroficheAnnex) {
      state = state.copyWith(
          userMessages: ["Entered Microfiche Annex: Discarded a random card."]);
      if (newPlayer.hand.isNotEmpty) {
        final hand = List<CardIdentifier>.from(newPlayer.hand);
        final cardToDiscard = (hand..shuffle()).first;
        hand.remove(cardToDiscard);
        newPlayer = newPlayer.copyWith(
          hand: hand,
          discardPile: [...newPlayer.discardPile, cardToDiscard],
        );
      }
    }

    // Update the seen grid based on the new position
    final newSeen =
        _updateSeenGrid(state.seen, newPlayer, state.gridWidth, state.gridHeight);

    // Reveal hidden chambers
    var newGrid = state.grid; // Assume grid doesn't change
    if (targetTileType == TileType.HiddenChamber) {
      final mutableGrid = state.grid.map((row) => List<TileType>.from(row)).toList();
      if (state.tomeLocation == Point(newX, newY)) {
        mutableGrid[newY][newX] = TileType.BlackTomeOfAlsophocus;
      } else {
        // It was a regular hidden chamber, now it's just a floor
        mutableGrid[newY][newX] = TileType.Floor;
      }
      newGrid = mutableGrid;
    }

    final newPlayers = List<Player>.from(state.players);
    newPlayers[state.currentPlayerIndex] = newPlayer;

    // Update the state
    state = state.copyWith(players: newPlayers, seen: newSeen, grid: newGrid);

    // Check for win condition after moving
    _checkForWin();
  }

  void _checkForWin() {
    final player = _currentPlayer;
    final tomeLocation = state.tomeLocation;

    if (player.x == tomeLocation.x && player.y == tomeLocation.y && player.insight >= 10) {
      state = state.copyWith(gameStatus: GameStatus.won, winner: player.characterId);
    }
  }

  /// Helper to draw cards and handle reshuffling the discard pile when the
  /// draw pile is empty.
  Player _drawCards(Player player, int count) {
    var drawPile = List<CardIdentifier>.from(player.drawPile);
    var discardPile = List<CardIdentifier>.from(player.discardPile);
    final newHandCards = <CardIdentifier>[];

    for (int i = 0; i < count; i++) {
      if (drawPile.isEmpty) {
        if (discardPile.isEmpty) break; // No cards left anywhere to draw
        drawPile = List<CardIdentifier>.from(discardPile);
        drawPile.shuffle();
        discardPile.clear();
      }
      newHandCards.add(drawPile.removeAt(0));
    }

    return player.copyWith(
      hand: [...player.hand, ...newHandCards],
      drawPile: drawPile,
      discardPile: discardPile,
    );
  }

  List<List<bool>> _updateSeenGrid(
    List<List<bool>> currentSeen,
    Player player,
    int gridWidth,
    int gridHeight,
  ) {
    // Create a mutable copy to update
    final newSeen = currentSeen.map((row) => List<bool>.from(row)).toList();
    const sightRadius = 3;

    for (int y = -sightRadius; y <= sightRadius; y++) {
      for (int x = -sightRadius; x <= sightRadius; x++) {
        // Check if it's within a circular radius
        if (x * x + y * y <= sightRadius * sightRadius) {
          final checkX = player.x + x;
          final checkY = player.y + y;

          // Check grid boundaries
          if (checkX >= 0 && checkX < gridWidth && checkY >= 0 && checkY < gridHeight) {
            newSeen[checkY][checkX] = true;
          }
        }
      }
    }
    return newSeen;
  }
}