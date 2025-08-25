import 'package:orne_library/src/game/card_identifier.dart';
import 'package:orne_library/src/game/character_identifier.dart';

/// An immutable data class holding all the static information for a character.
class CharacterData {
  final CharacterIdentifier id;
  final String name;
  final String title;
  final String description;
  final List<CardIdentifier> startingDeck;
  final String specialAbilityName;
  final String specialAbilityText;
  final int startingHandSize;

  const CharacterData({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.startingDeck,
    required this.specialAbilityName,
    required this.specialAbilityText,
    this.startingHandSize = 5,
  });
}