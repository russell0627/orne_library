import 'package:flutter/material.dart';
import 'package:orne_library/src/game/tile_data.dart';
import 'package:orne_library/src/game/tile_type.dart';

/// A central repository for all tile definitions in the game.
///
/// This acts as a data layer, separating the tile data from the game logic
/// and UI.
class TileLibrary {
  static final Map<TileType, TileData> tiles = {
    // Structural Tiles
    TileType.Floor: TileData(
      name: 'Floor',
      description: 'A plain stone floor.',
      effect: 'None.',
      color: Colors.grey.shade200,
    ),
    TileType.Wall: TileData(
      name: 'Wall',
      description: 'An impassable wall.',
      effect: 'None.',
      color: Colors.grey.shade800,
      isWalkable: false,
    ),
    TileType.Door: TileData(
      name: 'Door',
      description: 'A sturdy wooden door.',
      effect: 'Allows passage.',
      color: Colors.brown.shade400,
    ),

    // Static Tiles
    TileType.EntranceHall: TileData(
      name: 'Entrance Hall',
      description:
          'A cavernous chamber of cold marble and dark, polished wood. Sunlight struggles to pierce the tall, grimy arched windows, and the air is thick with the scent of old paper and dust. Your footsteps echo loudly, a stark intrusion into the oppressive silence.',
      effect: 'All players start the game here. This tile has no other special effect.',
      color: Colors.brown.shade200,
    ),
    TileType.MainReadingRoom: TileData(
      name: 'Main Reading Room',
      description:
          'This vast hall is the library\'s heart, filled with endless rows of oak tables and green-shaded lamps that cast pools of lonely light. The only sounds are the rustle of turning pages and the occasional, hacking cough from a distant corner. The walls are lined with tens of thousands of books, forming a tapestry of mundane knowledge that hides the library\'s darker truths.',
      effect: 'You must be on this tile to purchase cards from The Archive.',
      color: Colors.green.shade200,
    ),
    TileType.RestrictedSection: TileData(
      name: 'Restricted Section',
      description:
          'An immense iron gate, cold to the touch, separates this wing from the rest of the library. Beyond it, the shelves are built of a strange, dark metal, and the books are bound in materials that are disturbingly not leather or paper. The air is frigid, and there is a constant, almost sub-audible hum that makes your teeth ache.',
      effect: 'If you end your move here, gain 1 Tome and 1 Whispers of Madness card.',
      color: Colors.deepPurple.shade400,
    ),

    // Library Tiles
    TileType.PeriodicalsArchive: TileData(
      name: 'Periodicals Archive',
      description:
          'A cramped, dusty basement filled with towering stacks of bound newspapers and magazines. The flickering fluorescent lights cast long, dancing shadows, and the brittle pages flake like autumn leaves at your touch. The stories within chronicle a century of Arkham\'s strange disappearances and unsolved mysteries.',
      effect:
          'When you end your move here, you may pay 1 Insight to draw 1 card.',
      color: Colors.brown.shade300,
    ),
    TileType.MicroficheAnnex: TileData(
      name: 'Microfiche Annex',
      description:
          'The oppressive heat and monotonous hum of microfiche readers fill this small, windowless room. The air is stale with the smell of hot plastic and overworked machinery. Flicking through the magnified pages of old texts is a dizzying, nauseating experience that strains the eyes and the mind.',
      effect: 'When you enter this tile, you must discard a card.',
      color: Colors.lime.shade300,
    ),
    TileType.GreatHall: TileData(
      name: 'The Great Hall',
      description:
          'This chamber is impossibly large, its vaulted ceiling completely lost in darkness far above. Tattered banners bearing unfamiliar crests hang in the stagnant air. Your sense of scale feels wrong here, as if the room itself is a refutation of Euclidean geometry.',
      effect:
          'This is a large, central tile, often with many connections. No special effect.',
      color: Colors.indigo.shade200,
    ),
    TileType.SpecialCollections: TileData(
      name: 'Special Collections',
      description:
          'Items too valuable or fragile for the main shelves are displayed here in glass cases. You see a shrunken head from the Amazon, a series of bizarrely carved ceremonial daggers, and a star-chart depicting constellations unknown to modern astronomy. A faint shimmer in the air suggests not all the protective wards are purely physical.',
      effect: 'Hidden Chamber ("?").',
      color: Colors.purple.shade200,
    ),
    TileType.CartographyDepartment: TileData(
      name: 'Cartography Dept.',
      description:
          'Rolled maps are crammed into hundreds of cubbyholes, while massive atlases lie open on slanted tables. The maps near the entrance are of familiar lands, but as you go deeper, the coastlines become alien and the names are written in jagged, indecipherable scripts.',
      effect: 'When you end your move here, you gain +1 Footwork on your next turn.',
      color: Colors.teal.shade200,
    ),
    TileType.JanitorialCloset: TileData(
      name: 'Janitorial Closet',
      description:
          'The reek of ammonia and damp rot is overpowering. Buckets of black, brackish water line the walls next to cleaning supplies. An old, rope-operated dumbwaiter, clearly not meant for passengers, sits in the corner, its door slightly ajar, revealing a dark, gaping shaft.',
      effect:
          'You may spend 3 Footwork to move from this tile to any other "Janitorial Closet" tile in play.',
      color: Colors.grey.shade500,
    ),
    TileType.TheOrrery: TileData(
      name: 'The Orrery',
      description:
          'A breathtaking, room-sized clockwork model of the solar system dominates this circular chamber. Gears of brass and copper tick and whir softly as strange, unfamiliar planets of polished stone and faceted crystal orbit a central, dimly glowing sphere. Looking at it for too long makes you feel dizzy, as if you\'re falling into the sky.',
      effect: 'Hidden Chamber ("?").',
      color: Colors.amber.shade300,
    ),
    TileType.ManuscriptVault: TileData(
      name: 'Manuscript Vault',
      description:
          'The air in this room is unnaturally cold, dry, and utterly still. Heavy, sound-dampening panels line the walls, and the only feature is a massive, circular steel door, like that of a bank vault, covered in dials and locks that have no visible keyholes.',
      effect: 'Path Feature: All paths leading out of this tile are Locked Doors.',
      color: Colors.blueGrey.shade400,
    ),
    TileType.StudyCarrels: TileData(
      name: 'Study Carrels',
      description:
          'A claustrophobic maze of dark wood and dim lighting. Each carrel is a tiny, three-walled box, filled with graffiti from generations of bored or half-mad students. The sheer monotony of the layout is disorienting, and you keep feeling like you’re passing the same carved initials over and over.',
      effect: 'The cost to move out of this tile is 2 Footwork instead of 1.',
      color: Colors.brown.shade400,
    ),
    TileType.BlackTomeOfAlsophocus: TileData(
      name: 'Black Tome',
      description:
          'The Black Tome of Alsophocus rests on a pedestal, its pages filled with alien script that seems to writhe before your eyes.',
      effect:
          'The objective of the game. Win by ending your turn here with 10 or more Insight.',
      color: Colors.yellow.shade600,
      isWalkable: true,
    ),
    // ... other tiles would be defined here
  };
}