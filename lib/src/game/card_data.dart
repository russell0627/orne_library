import 'package:orne_library/src/game/card_identifier.dart';
import 'package:orne_library/src/game/card_type.dart';

/// An immutable data class holding all the static information for a card.
class CardData {
  /// The unique ID for this card.
  final CardIdentifier id;

  /// The display name of the card.
  final String name;

  /// The category of the card (Archive, Tome, Madness).
  final CardType type;

  /// The cost in Insight to acquire or play the card.
  final int cost;

  /// The description of the card's gameplay effect.
  final String effectText;

  /// The amount of Insight this card provides when played.
  final int insight;

  /// The amount of Footwork this card provides when played.
  final int footwork;

  /// The number of cards drawn when this card is played.
  final int cards;

  /// The number of additional actions gained when this card is played.
  final int actions;

  const CardData({
    required this.id,
    required this.name,
    required this.type,
    this.cost = 0,
    required this.effectText,
    this.insight = 0,
    this.footwork = 0,
    this.cards = 0,
    this.actions = 0,
  });
}