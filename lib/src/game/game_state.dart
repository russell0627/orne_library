import 'dart:math';

import 'package:collection/collection.dart';
import 'package:orne_library/src/game/card_identifier.dart';
import 'package:orne_library/src/game/character_identifier.dart';
import 'package:orne_library/src/game/game_status.dart';
import 'package:orne_library/src/game/player.dart';
import 'package:orne_library/src/game/tile_type.dart';

/// An immutable data class representing the entire state of the game.
class GameState {
  final List<List<TileType>> grid;
  final List<Player> players;
  final int currentPlayerIndex;
  final List<List<bool>> seen;
  final List<CardIdentifier> archiveMarket;
  final List<CardIdentifier> archiveSupply;
  final Point<int> tomeLocation;
  final GameStatus gameStatus;
  final CharacterIdentifier? winner;

  /// A list of messages to be displayed to the user (e.g., in a SnackBar).
  final List<String> userMessages;

  int get gridWidth => grid.isNotEmpty ? grid.first.length : 0;
  int get gridHeight => grid.length;

  const GameState({
    this.grid = const [],
    this.players = const [],
    this.currentPlayerIndex = 0,
    this.seen = const [],
    this.archiveMarket = const [],
    this.archiveSupply = const [],
    this.tomeLocation = const Point(0, 0),
    this.gameStatus = GameStatus.inProgress,
    this.userMessages = const [],
    this.winner,
  });

  GameState copyWith({
    List<List<TileType>>? grid,
    List<Player>? players,
    int? currentPlayerIndex,
    List<List<bool>>? seen,
    List<CardIdentifier>? archiveMarket,
    List<CardIdentifier>? archiveSupply,
    Point<int>? tomeLocation,
    GameStatus? gameStatus,
    CharacterIdentifier? winner,
    List<String>? userMessages,
  }) {
    return GameState(
      grid: grid ?? this.grid,
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      seen: seen ?? this.seen,
      archiveMarket: archiveMarket ?? this.archiveMarket,
      archiveSupply: archiveSupply ?? this.archiveSupply,
      tomeLocation: tomeLocation ?? this.tomeLocation,
      gameStatus: gameStatus ?? this.gameStatus,
      userMessages: userMessages ?? this.userMessages,
      winner: winner ?? this.winner,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    const listEquals = ListEquality();

    return other is GameState &&
        listEquals.equals(other.grid, grid) &&
        listEquals.equals(other.players, players) &&
        other.currentPlayerIndex == currentPlayerIndex &&
        listEquals.equals(other.seen, seen) &&
        listEquals.equals(other.archiveMarket, archiveMarket) &&
        listEquals.equals(other.archiveSupply, archiveSupply) &&
        other.tomeLocation == tomeLocation &&
        other.gameStatus == gameStatus &&
        other.winner == winner &&
        listEquals.equals(other.userMessages, userMessages);
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(grid),
        Object.hashAll(players),
        currentPlayerIndex,
        Object.hashAll(seen),
        Object.hashAll(archiveMarket),
        Object.hashAll(archiveSupply),
        tomeLocation,
        gameStatus,
        winner,
        Object.hashAll(userMessages),
      );
}