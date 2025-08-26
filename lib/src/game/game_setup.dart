import 'package:collection/collection.dart';
import 'package:orne_library/src/game/character_identifier.dart';

/// An immutable class to hold the setup parameters for a new game.
///
/// This is used as a parameter for the [gameControllerProvider] family
/// to ensure the parameter is equatable, which is a requirement for
/// Riverpod family modifiers.
class GameSetup {
  final List<CharacterIdentifier> characterIds;
  final int deckMultiplier;

  const GameSetup({
    required this.characterIds,
    this.deckMultiplier = 1,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GameSetup &&
        other.deckMultiplier == deckMultiplier &&
        const ListEquality().equals(other.characterIds, characterIds);
  }

  @override
  int get hashCode =>
      Object.hash(const ListEquality().hash(characterIds), deckMultiplier);
}