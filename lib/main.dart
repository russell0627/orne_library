import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orne_library/src/game/card_library.dart';
import 'package:orne_library/src/game/card_type.dart';
import 'package:orne_library/src/game/game_controller.dart';
import 'package:orne_library/src/game/character_identifier.dart';
import 'package:orne_library/src/game/game_setup.dart';
import 'package:orne_library/src/screens/player_count_screen.dart';
import 'package:orne_library/src/game/character_library.dart';
import 'package:orne_library/src/game/game_status.dart';
import 'package:orne_library/src/tile_grid/tile_grid.dart';
import 'package:orne_library/src/game/game_state.dart';
import 'package:orne_library/src/game/tile_type.dart';
import 'package:orne_library/src/game/tile_library.dart';
import 'package:orne_library/src/widgets/archive_widget.dart';
import 'package:orne_library/src/widgets/player_hand_widget.dart';

void main() {
  // Wrap the app in a ProviderScope to enable Riverpod state management.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tile Grid Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const PlayerCountScreen(),
    );
  }
}

/// A screen that demonstrates the use of the [TileGrid] widget.
class TileGridDemoScreen extends ConsumerWidget {
  final List<CharacterIdentifier> characterIds;

  const TileGridDemoScreen({
    super.key,
    required this.characterIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the game state and get the controller.
    final gameSetup = GameSetup(characterIds: characterIds);
    final gameState = ref.watch(gameControllerProvider(gameSetup));
    final gameController = ref.read(gameControllerProvider(gameSetup).notifier);
    final currentPlayer = gameState.players[gameState.currentPlayerIndex];

    // Show a victory dialog when the game is won
    ref.listen<GameState>(gameControllerProvider(gameSetup), (previous, next) {
      if (next.gameStatus == GameStatus.won && previous?.gameStatus != GameStatus.won) {
        final winnerData = CharacterLibrary.characters[next.winner]!;
        // Schedule the dialog to be shown after the build is complete.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false, // User must interact with the dialog
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Victory!'),
                content: Text('${winnerData.name} has found The Black Tome of Alsophocus and deciphered its secrets!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Play Again'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      gameController.reset();
                    },
                  ),
                ],
              );
            },
          );
        });
      }

      // Handle user messages by showing SnackBars
      if (next.userMessages.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Clear previous snackbars if any are still showing
          ScaffoldMessenger.of(context).clearSnackBars();
          for (final message in next.userMessages) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                duration: const Duration(seconds: 3),
              ),
            );
          }
          gameController.clearUserMessages();
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Player ${currentPlayer.playerIndex + 1}: '
            'Actions: ${currentPlayer.actions} | Insight: ${currentPlayer.insight} | Footwork: ${currentPlayer.footwork}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: gameController.reset,
        tooltip: 'Reset Score',
        child: const Icon(Icons.refresh),
      ),
      body: Column(
        children: [
          // The Archive at the top
          Builder(builder: (context) {
            final playerTile = gameState.grid[currentPlayer.y][currentPlayer.x];
            return ArchiveWidget(
              marketCards: gameState.archiveMarket,
              controller: gameController,
              canBuy: playerTile == TileType.MainReadingRoom,
            );
          }),
          // The main game board in the middle
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: TileGrid(
                    // Each tile is 8x8 pixels, as requested.
                    gridWidth: gameState.gridWidth,
                    gridHeight: gameState.gridHeight,
                    tileWidth: 16.0,
                    tileHeight: 16.0,
                    showGridLines: true,
                    children: _buildGridItems(gameState, gameController),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: _buildMovementControls(gameState, gameController),
                ),
              ],
            ),
          ),
          // Player's hand at the bottom
          Column(
            children: [
              PlayerHandWidget(
                hand: currentPlayer.hand,
                controller: gameController,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    ),
                    onPressed: gameController.endTurn,
                    child: const Text('End Turn')),
              ),
              Builder(builder: (context) {
                final tileType = gameState.grid[currentPlayer.y][currentPlayer.x];
                final hasAction = currentPlayer.actions > 0;
                // Define which tiles have special actions
                const actionableTiles = {
                  TileType.FoundersPortraitGallery,
                  TileType.RareBookRoom,
                  TileType.JanitorialCloset,
                };

                if (actionableTiles.contains(tileType)) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: ElevatedButton(
                        onPressed: hasAction ? gameController.useTileAction : null,
                        child: const Text('Use Location Ability')),
                  );
                }

                return const SizedBox.shrink(); // Return empty space if no action
              }),
              Builder(builder: (context) {
                // Note: This could be refactored into a single widget to avoid repetition.
                // Only show for Dr. Alistair Finch for now
                if (currentPlayer.characterId == CharacterIdentifier.drAlistairFinch) {
                  final canUseAbility = !currentPlayer.hasUsedCharacterAbilityThisTurn &&
                      currentPlayer.insight >= 2;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade200,
                      ),
                      onPressed:
                          canUseAbility ? gameController.useCharacterAbility : null,
                      child: const Text('Use Character Ability'),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              Builder(builder: (context) {
                // Only show for Eleanor Vance for now
                if (currentPlayer.characterId == CharacterIdentifier.eleanorVance) {
                  final canUseAbility = !currentPlayer.hasUsedCharacterAbilityThisTurn &&
                      currentPlayer.hand.isNotEmpty;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade200,
                      ),
                      onPressed:
                          canUseAbility ? gameController.useCharacterAbility : null,
                      child: const Text('Use Character Ability'),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              Builder(builder: (context) {
                // Only show for Julian Blackwood
                if (currentPlayer.characterId == CharacterIdentifier.julianBlackwood) {
                  final hasMadnessCard = currentPlayer.hand.any(
                      (cardId) => CardLibrary.cards[cardId]!.type == CardType.Madness);
                  final canUseAbility =
                      !currentPlayer.hasUsedCharacterAbilityThisTurn && hasMadnessCard;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade200,
                      ),
                      onPressed:
                          canUseAbility ? gameController.useCharacterAbility : null,
                      child: const Text('Use Character Ability'),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              Builder(builder: (context) {
                // Only show for Mr. Silas Croft
                if (currentPlayer.characterId == CharacterIdentifier.mrSilasCroft) {
                  final canUseAbility = !currentPlayer.hasUsedCharacterAbilityThisTurn;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade200,
                      ),
                      onPressed:
                          canUseAbility ? gameController.useCharacterAbility : null,
                      child: const Text('Use Character Ability'),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              Builder(builder: (context) {
                // Only show for Adelaide Hayes
                if (currentPlayer.characterId == CharacterIdentifier.adelaideHayes) {
                  final canUseAbility = !currentPlayer.hasUsedCharacterAbilityThisTurn &&
                      currentPlayer.insight >= 2;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade200,
                      ),
                      onPressed:
                          canUseAbility ? gameController.useCharacterAbility : null,
                      child: const Text('Use Character Ability'),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ],
      ),
    );
  }

  List<TileGridItem> _buildGridItems(
      GameState gameState, GameController gameController) {
    final List<TileGridItem> items = [];
    for (int y = 0; y < gameState.gridHeight; y++) {
      for (int x = 0; x < gameState.gridWidth; x++) {
        // Check if the tile has been seen
        if (!gameState.seen[y][x]) {
          // If not seen, add a fog tile
          items.add(TileGridItem(
              x: x,
              y: y,
              width: 1,
              height: 1,
              child: const FogTile()));
          continue; // Skip the rest of the loop for this tile
        }

        final tileType = gameState.grid[y][x];
        final tileData = TileLibrary.tiles[tileType]!;

        final tile = DemoTile(
          label: tileData.name,
          color: tileData.color,
        );

        Widget child = tile;

        // Find all players on this tile
        final playersOnTile =
            gameState.players.where((p) => p.x == x && p.y == y).toList();

        if (playersOnTile.isNotEmpty) {
          child = Stack(
            children: [
              tile,
              // Stack player pawns on top of the tile
              ...playersOnTile.map((player) => PlayerTile(
                    playerIndex: player.playerIndex,
                  ))
            ],
          );
        }

        items.add(TileGridItem(x: x, y: y, width: 1, height: 1, child: child));
      }
    }

    return items;
  }

  Widget _buildMovementControls(
      GameState gameState, GameController gameController) {
    final currentPlayer = gameState.players[gameState.currentPlayerIndex];
    final currentTile = gameState.grid[currentPlayer.y][currentPlayer.x];

    // Determine the correct movement cost based on the player's current tile.
    int moveCost = 1;
    if (currentTile == TileType.StudyCarrels) {
      moveCost = 2;
    }
    final canMove = currentPlayer.footwork >= moveCost;

    return Card(
      elevation: 6.0,
      color: Colors.white.withAlpha(230),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: canMove ? gameController.moveUp : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: canMove ? gameController.moveLeft : null,
                ),
                const SizedBox(width: 48),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: canMove ? gameController.moveRight : null,
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: canMove ? gameController.moveDown : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple widget to represent the player on the grid.
class PlayerTile extends StatelessWidget {
  final int playerIndex;

  const PlayerTile({super.key, required this.playerIndex});

  static const List<Color> _playerColors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _playerColors[playerIndex % _playerColors.length];
    return Center(
      child: Icon(
        Icons.person,
        color: color,
        size: 16,
        shadows: const [Shadow(color: Colors.black, blurRadius: 2.0)],
      ),
    );
  }
}

/// A simple widget to represent an unseen "fog of war" tile.
class FogTile extends StatelessWidget {
  const FogTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        border: Border.all(color: Colors.black87, width: 0.5),
      ),
    );
  }
}

/// A simple colored container with a label for demo purposes.
class DemoTile extends StatelessWidget {
  final String label;
  final Color color;

  const DemoTile({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black54, width: 1.0),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 8,
          ),
        ),
      ),
    );
  }
}
