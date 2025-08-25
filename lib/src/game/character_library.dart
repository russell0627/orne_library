import 'package:orne_library/src/game/card_identifier.dart';
import 'package:orne_library/src/game/character_data.dart';
import 'package:orne_library/src/game/character_identifier.dart';

/// A central repository for all character definitions in the game.
class CharacterLibrary {
  static final Map<CharacterIdentifier, CharacterData> characters = {
    CharacterIdentifier.drAlistairFinch: CharacterData(
      id: CharacterIdentifier.drAlistairFinch,
      name: 'Dr. Alistair Finch',
      title: 'The Antiquarian',
      description:
          "An emeritus professor of history, Dr. Finch has walked these halls for fifty years. He knows the library's secrets better than the librarians themselves, from its hidden passages to the way the floorboards creak over the forgotten vaults.",
      startingDeck: [
        ...List.filled(6, CardIdentifier.basicResearch),
        ...List.filled(2, CardIdentifier.cautiousSteps),
        ...List.filled(2, CardIdentifier.iKnowAShortcut),
      ],
      specialAbilityName: 'Lay of the Land',
      specialAbilityText:
          'When you are the first to enter a Hidden Chamber ("?"), you may secretly look at the top two cards of the Location Deck. You choose one to be the location for that Chamber, place it face down, and return the other to the top of the deck.',
    ),
    CharacterIdentifier.eleanorVance: CharacterData(
      id: CharacterIdentifier.eleanorVance,
      name: 'Eleanor Vance',
      title: 'The Prodigy',
      description:
          'A brilliant graduate student whose mind burns with an unquenchable fire. She absorbs and synthesizes knowledge at a rate that unnerves her professors, building complex theories from the barest scraps of information.',
      startingDeck: [
        ...List.filled(7, CardIdentifier.basicResearch),
        ...List.filled(3, CardIdentifier.cautiousSteps),
      ],
      specialAbilityName: 'Flash of Insight',
      specialAbilityText:
          'Once per turn, when you purchase a card from The Archive, you may pay 1 extra Insight. If you do, place the newly acquired card on top of your draw deck instead of in your discard pile.',
    ),
    CharacterIdentifier.julianBlackwood: CharacterData(
      id: CharacterIdentifier.julianBlackwood,
      name: 'Julian Blackwood',
      title: 'The Occultist',
      description:
          'A controversial scholar who believes that true understanding of the abyss requires one to gaze into it. He willingly courts madness, believing the whispers from the void are not a curse, but a source of profound, albeit dangerous, insight.',
      startingDeck: [
        ...List.filled(6, CardIdentifier.basicResearch),
        ...List.filled(4, CardIdentifier.cautiousSteps),
        CardIdentifier.dread, // Starts with a madness card
      ],
      specialAbilityName: 'Whispers in the Dark',
      specialAbilityText:
          'You are immune to the negative effects of "Amnesia" and "Paranoia" cards. Furthermore, when you play any "Whispers of Madness" card from your hand, you may use it to generate either 1 Insight or 1 Footwork.',
    ),
    CharacterIdentifier.mrSilasCroft: CharacterData(
      id: CharacterIdentifier.mrSilasCroft,
      name: 'Mr. Silas Croft',
      title: 'The Head Archivist',
      description:
          "Silent and severe, Mr. Croft is the guardian of the Orne Library's collection. The card catalog is an extension of his own mind, and he can locate, acquire, or \"misplace\" any text with terrifying efficiency.",
      startingDeck: [
        ...List.filled(6, CardIdentifier.basicResearch),
        ...List.filled(2, CardIdentifier.cautiousSteps),
        ...List.filled(2, CardIdentifier.reshelve),
      ],
      specialAbilityName: "Librarian's Prerogative",
      specialAbilityText:
          'Once per turn, while in the Main Reading Room, you may spend 1 Insight to discard the entire row of 6 cards in The Archive and deal 6 new ones.',
    ),
    CharacterIdentifier.adelaideHayes: CharacterData(
      id: CharacterIdentifier.adelaideHayes,
      name: 'Adelaide "Addy" Hayes',
      title: 'The Field Explorer',
      description:
          "Fresh from a harrowing expedition to the Peruvian highlands, Addy is more comfortable with a bullwhip than a book. She is tough, resourceful, and unfazed by the library's unsettling atmosphere, relying on grit and a bit of luck to see her through.",
      startingDeck: [
        ...List.filled(5, CardIdentifier.basicResearch),
        ...List.filled(5, CardIdentifier.cautiousSteps),
      ],
      specialAbilityName: 'Undaunted',
      specialAbilityText: 'Your maximum and starting hand size is 6 cards instead of 5.',
      startingHandSize: 6,
    ),
  };
}