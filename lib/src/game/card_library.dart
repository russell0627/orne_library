import 'package:orne_library/src/game/card_data.dart';
import 'package:orne_library/src/game/card_identifier.dart';
import 'package:orne_library/src/game/card_type.dart';

/// A central repository for all card definitions in the game.
class CardLibrary {
  static final Map<CardIdentifier, CardData> cards = {
    // --- Starting Cards ---
    CardIdentifier.basicResearch: CardData(
      name: 'Basic Research',
      type: CardType.Archive,
      cost: 0,
      effectText: '+1 Insight.',
      insight: 1,
    ),
    CardIdentifier.cautiousSteps: CardData(
      name: 'Cautious Steps',
      type: CardType.Archive,
      cost: 0,
      effectText: '+1 Footwork.',
      footwork: 1,
    ),
    CardIdentifier.iKnowAShortcut: CardData(
        name: 'I Know a Shortcut',
        type: CardType.Archive,
        cost: 0,
        effectText:
            'Provides 1 Footwork. If you are in a Chamber with a "Locked Door," you may move through it this turn as if it were unlocked.',
        footwork: 1),
    CardIdentifier.reshelve: CardData(
        name: 'Re-shelve',
        type: CardType.Archive,
        cost: 0,
        effectText: 'Provides 1 Insight. You may trash a card from your hand.',
        insight: 1),

    // --- Archive Cards ---
    // Cost 2
    CardIdentifier.hastySearch: CardData(
        name: 'Hasty Search',
        type: CardType.Archive,
        cost: 2,
        effectText: '+2 Footwork.',
        footwork: 2),
    CardIdentifier.skimTheIndex: CardData(
        name: 'Skim the Index',
        type: CardType.Archive,
        cost: 2,
        effectText: '+1 Insight, +1 Footwork.',
        insight: 1,
        footwork: 1),
    CardIdentifier.studentAssistant: CardData(
        name: 'Student Assistant',
        type: CardType.Archive,
        cost: 2,
        effectText: '+1 Insight. You may trash a card from your hand.',
        insight: 1),
    CardIdentifier.organizeNotes: CardData(
        name: 'Organize Notes',
        type: CardType.Archive,
        cost: 2,
        effectText: '+1 Card, +1 Action.',
        cards: 1,
        actions: 1),
    CardIdentifier.borrowedLantern: CardData(
        name: 'Borrowed Lantern',
        type: CardType.Archive,
        cost: 2,
        effectText:
            '+1 Footwork. Look at the top card of your deck. You may discard it.',
        footwork: 1),

    // Cost 3
    CardIdentifier.focusedStudy: CardData(
        name: 'Focused Study',
        type: CardType.Archive,
        cost: 3,
        effectText: '+2 Insight.',
        insight: 2),
    CardIdentifier.forcedMarch: CardData(
        name: 'Forced March',
        type: CardType.Archive,
        cost: 3,
        effectText: '+3 Footwork.',
        footwork: 3),
    CardIdentifier.librariansFavor: CardData(
        name: "Librarian's Favor",
        type: CardType.Archive,
        cost: 3,
        effectText: '+1 Insight. Each other player must discard a card.',
        insight: 1),
    CardIdentifier.cartographySketch: CardData(
        name: 'Cartography Sketch',
        type: CardType.Archive,
        cost: 3,
        effectText: '+2 Footwork, +1 Card.',
        footwork: 2,
        cards: 1),
    CardIdentifier.wellWornBoots: CardData(
        name: 'Well-Worn Boots',
        type: CardType.Archive,
        cost: 3,
        effectText: '+2 Footwork, +1 Action.',
        footwork: 2,
        actions: 1),
    CardIdentifier.crossReference: CardData(
        name: 'Cross-Reference',
        type: CardType.Archive,
        cost: 3,
        effectText: '+1 Insight, +1 Card, +1 Action.',
        insight: 1,
        cards: 1,
        actions: 1),
    CardIdentifier.archivalClerk: CardData(
        name: 'Archival Clerk',
        type: CardType.Archive,
        cost: 3,
        effectText:
            '+2 Insight. You may put a card from your hand on top of your deck.',
        insight: 2),
    CardIdentifier.clandestineMeeting: CardData(
        name: 'Clandestine Meeting',
        type: CardType.Archive,
        cost: 3,
        effectText:
            'Gain 1 Insight for each other player in your current location.'),
    CardIdentifier.dustyMap: CardData(
        name: 'Dusty Map',
        type: CardType.Archive,
        cost: 3,
        effectText:
            'Reveal the top card of the Location Deck. Place it back on the top or bottom.'),
    CardIdentifier.tidyUp: CardData(
        name: 'Tidy Up',
        type: CardType.Archive,
        cost: 3,
        effectText: 'Trash up to two cards from your hand.'),

    // Cost 4
    CardIdentifier.deepResearch: CardData(
        name: 'Deep Research',
        type: CardType.Archive,
        cost: 4,
        effectText: '+3 Insight.',
        insight: 3),
    CardIdentifier.allNighter: CardData(
        name: 'All-Nighter',
        type: CardType.Archive,
        cost: 4,
        effectText: '+2 Cards, +1 Action.',
        cards: 2,
        actions: 1),
    CardIdentifier.masterKey: CardData(
        name: 'Master Key',
        type: CardType.Archive,
        cost: 4,
        effectText: '+2 Footwork. You may move through one "Locked Door" this turn.',
        footwork: 2),
    CardIdentifier.academicScrutiny: CardData(
        name: 'Academic Scrutiny',
        type: CardType.Archive,
        cost: 4,
        effectText: '+2 Insight. Trash a card from your hand.',
        insight: 2),
    CardIdentifier.suddenRealization: CardData(
        name: 'Sudden Realization',
        type: CardType.Archive,
        cost: 4,
        effectText: '+2 Insight, +2 Footwork.',
        insight: 2,
        footwork: 2),
    CardIdentifier.hireAGuide: CardData(
        name: 'Hire a Guide',
        type: CardType.Archive,
        cost: 4,
        effectText: '+4 Footwork.',
        footwork: 4),
    CardIdentifier.espionage: CardData(
        name: 'Espionage',
        type: CardType.Archive,
        cost: 4,
        effectText:
            "Look at another player's hand. Choose one card; they must discard it."),
    CardIdentifier.photographicMemory: CardData(
        name: 'Photographic Memory',
        type: CardType.Archive,
        cost: 4,
        effectText: '+2 Cards.',
        cards: 2),
    CardIdentifier.decipherRunes: CardData(
        name: 'Decipher Runes',
        type: CardType.Archive,
        cost: 4,
        effectText: '+2 Insight. If you are in a Hidden Chamber, +2 more Insight.',
        insight: 2),
    CardIdentifier.secretPassage: CardData(
        name: 'Secret Passage',
        type: CardType.Archive,
        cost: 4,
        effectText:
            '+1 Footwork. You may move to any adjacent Chamber, ignoring connections and Locked Doors.',
        footwork: 1),

    // Cost 5
    CardIdentifier.scholarlyPublication: CardData(
        name: 'Scholarly Publication',
        type: CardType.Archive,
        cost: 5,
        effectText: '+4 Insight.',
        insight: 4),
    CardIdentifier.breakthrough: CardData(
        name: 'Breakthrough',
        type: CardType.Archive,
        cost: 5,
        effectText: '+2 Insight, +2 Cards, +2 Actions.',
        insight: 2,
        cards: 2,
        actions: 2),
    CardIdentifier.expeditionTeam: CardData(
        name: 'Expedition Team',
        type: CardType.Archive,
        cost: 5,
        effectText: '+5 Footwork.',
        footwork: 5),
    CardIdentifier.occultScholar: CardData(
        name: 'Occult Scholar',
        type: CardType.Archive,
        cost: 5,
        effectText:
            ' +3 Insight. You may trash a "Whispers of Madness" card from your hand or discard pile.',
        insight: 3),
    CardIdentifier.encyclopedicKnowledge: CardData(
        name: 'Encyclopedic Knowledge',
        type: CardType.Archive,
        cost: 5,
        effectText: '+3 Insight, +1 Card.',
        insight: 3,
        cards: 1),
    CardIdentifier.headStart: CardData(
        name: 'Head Start',
        type: CardType.Archive,
        cost: 5,
        effectText: '+3 Footwork, +2 Cards.',
        footwork: 3,
        cards: 2),
    CardIdentifier.misdirection: CardData(
        name: 'Misdirection',
        type: CardType.Archive,
        cost: 5,
        effectText: "Move another player's pawn one space."),
    CardIdentifier.burnTheEvidence: CardData(
        name: 'Burn the Evidence',
        type: CardType.Archive,
        cost: 5,
        effectText: 'Trash a card from your hand. Gain Insight equal to its cost.'),
    CardIdentifier.feverishPace: CardData(
        name: 'Feverish Pace',
        type: CardType.Archive,
        cost: 5,
        effectText:
            '+3 Footwork. You may take an extra turn after this one, but you only draw 3 cards.',
        footwork: 3),

    // Cost 6
    CardIdentifier.professorsTenure: CardData(
        name: "Professor's Tenure",
        type: CardType.Archive,
        cost: 6,
        effectText: '+5 Insight.',
        insight: 5),
    CardIdentifier.uncoverConspiracy: CardData(
        name: 'Uncover Conspiracy',
        type: CardType.Archive,
        cost: 6,
        effectText:
            '+3 Insight. Each other player gains a "Whispers of Madness: Dread" card.',
        insight: 3),
    CardIdentifier.theGrandTour: CardData(
        name: 'The Grand Tour',
        type: CardType.Archive,
        cost: 6,
        effectText: '+6 Footwork.',
        footwork: 6),
    CardIdentifier.eureka: CardData(
        name: 'Eureka!',
        type: CardType.Archive,
        cost: 6,
        effectText: '+3 Insight, +3 Cards.',
        insight: 3,
        cards: 3),
    CardIdentifier.patronsFunding: CardData(
        name: "Patron's Funding",
        type: CardType.Archive,
        cost: 6,
        effectText:
            '+4 Insight. You may gain a card from the Archive costing 4 or less.',
        insight: 4),
    CardIdentifier.finalDraft: CardData(
        name: 'Final Draft',
        type: CardType.Archive,
        cost: 6,
        effectText: '+3 Insight. Trash up to 2 cards from your discard pile.',
        insight: 3),

    // --- Tome Cards ---
    CardIdentifier.deVermisMysteriis: CardData(
        name: 'De Vermis Mysteriis',
        type: CardType.Tome,
        effectText:
            '+4 Insight. You may gain a "Whispers of Madness" card to gain an additional +4 Insight.',
        insight: 4),
    CardIdentifier.theBookOfEibon: CardData(
        name: 'The Book of Eibon',
        type: CardType.Tome,
        effectText: '+4 Footwork. You may teleport to any revealed Chamber tile.',
        footwork: 4),
    CardIdentifier.unaussprechlichenKulten: CardData(
        name: 'Unaussprechlichen Kulten',
        type: CardType.Tome,
        effectText:
            '+2 Insight. Look at the top 3 cards of any deck (Archive, Tome, Location, or a player\'s deck) and rearrange them as you wish.',
        insight: 2),
    CardIdentifier.theCelaenoFragments: CardData(
        name: 'The Celaeno Fragments',
        type: CardType.Tome,
        effectText: '+3 Cards, +2 Actions.',
        cards: 3,
        actions: 2),
    CardIdentifier.cultesDesGoules: CardData(
        name: 'Cultes des Goules',
        type: CardType.Tome,
        effectText:
            '+3 Insight. For the rest of the game, when you trash a card, you gain 1 Insight.',
        insight: 3),
    CardIdentifier.liberIvonis: CardData(
        name: 'Liber Ivonis',
        type: CardType.Tome,
        effectText:
            '+3 Footwork. For the rest of the game, your movement cost between tiles is 0.',
        footwork: 3),
    CardIdentifier.theNecronomicon: CardData(
        name: 'The Necronomicon',
        type: CardType.Tome,
        effectText:
            '+6 Insight. You win the game if you have 15 or more Insight this turn (instead of 10).',
        insight: 6),

    // --- Whispers of Madness Cards ---
    CardIdentifier.dread: CardData(
        name: 'Dread',
        type: CardType.Madness,
        effectText: '(Curse) Does nothing.'),
    CardIdentifier.amnesia: CardData(
        name: 'Amnesia',
        type: CardType.Madness,
        effectText:
            '(Curse) When you draw this card, discard another card from your hand at random.'),
    CardIdentifier.paranoia: CardData(
        name: 'Paranoia',
        type: CardType.Madness,
        effectText:
            '(Curse) While this card is in your hand, you must play with your hand revealed.'),
  };
}