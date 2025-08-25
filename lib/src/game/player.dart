import 'package:collection/collection.dart';
import 'package:orne_library/src/game/card_identifier.dart';
import 'package:orne_library/src/game/character_identifier.dart';

/// An immutable data class representing the player.
class Player {
  /// A unique index for the player (0, 1, 2, 3).
  final int playerIndex;

  /// The player's current health.
  final int health;

  /// The identifier for the character being played.
  final CharacterIdentifier characterId;

  /// The player's current insight.
  final int insight;

  /// The player's current footwork.
  final int footwork;

  /// The player's current actions.
  final int actions;

  /// The player's horizontal position on the grid.
  final int x;

  /// The player's vertical position on the grid.
  final int y;

  /// The player's maximum hand size.
  final int handSize;

  /// The player's hand of cards.
  final List<CardIdentifier> hand;

  /// The player's draw pile.
  final List<CardIdentifier> drawPile;

  /// The player's discard pile.
  final List<CardIdentifier> discardPile;

  /// A temporary bonus to footwork for the next turn.
  final int nextTurnFootworkBonus;

  /// A flag to track if the character's once-per-turn ability has been used.
  final bool hasUsedCharacterAbilityThisTurn;

  const Player({
    required this.playerIndex,
    this.health = 100,
    required this.characterId,
    this.insight = 0,
    this.footwork = 0,
    this.actions = 1,
    required this.x,
    required this.y,
    this.handSize = 5,
    this.hand = const [],
    this.drawPile = const [],
    this.discardPile = const [],
    this.nextTurnFootworkBonus = 0,
    this.hasUsedCharacterAbilityThisTurn = false,
  });

  /// Creates a copy of the current Player with the given fields replaced
  /// with the new values.
  Player copyWith({
    int? playerIndex,
    int? health,
    CharacterIdentifier? characterId,
    int? insight,
    int? footwork,
    int? actions,
    int? x,
    int? y,
    int? handSize,
    List<CardIdentifier>? hand,
    List<CardIdentifier>? drawPile,
    List<CardIdentifier>? discardPile,
    int? nextTurnFootworkBonus,
    bool? hasUsedCharacterAbilityThisTurn,
  }) {
    return Player(
      playerIndex: playerIndex ?? this.playerIndex,
      health: health ?? this.health,
      characterId: characterId ?? this.characterId,
      insight: insight ?? this.insight,
      footwork: footwork ?? this.footwork,
      actions: actions ?? this.actions,
      x: x ?? this.x,
      y: y ?? this.y,
      handSize: handSize ?? this.handSize,
      hand: hand ?? this.hand,
      drawPile: drawPile ?? this.drawPile,
      discardPile: discardPile ?? this.discardPile,
      nextTurnFootworkBonus: nextTurnFootworkBonus ?? this.nextTurnFootworkBonus,
      hasUsedCharacterAbilityThisTurn:
          hasUsedCharacterAbilityThisTurn ?? this.hasUsedCharacterAbilityThisTurn,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    const listEquals = ListEquality<CardIdentifier>();

    return other is Player &&
        other.playerIndex == playerIndex &&
        other.health == health &&
        other.characterId == characterId &&
        other.insight == insight &&
        other.footwork == footwork &&
        other.actions == actions &&
        other.x == x &&
        other.y == y &&
        other.handSize == handSize &&
        listEquals.equals(other.hand, hand) &&
        listEquals.equals(other.drawPile, drawPile) &&
        listEquals.equals(other.discardPile, discardPile) &&
        other.nextTurnFootworkBonus == nextTurnFootworkBonus &&
        other.hasUsedCharacterAbilityThisTurn == hasUsedCharacterAbilityThisTurn;
  }

  @override
  int get hashCode => Object.hash(
        health,
        playerIndex,
        characterId,
        insight,
        footwork,
        actions,
        x,
        y,
        handSize,
        Object.hashAll(hand),
        Object.hashAll(drawPile),
        Object.hashAll(discardPile),
        nextTurnFootworkBonus,
        hasUsedCharacterAbilityThisTurn,
      );
}