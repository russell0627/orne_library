import 'package:flutter/material.dart';

/// An immutable data class holding all the information for a specific tile type.
class TileData {
  /// The display name of the tile.
  final String name;

  /// The flavor text description of the tile.
  final String description;

  /// The description of the tile's gameplay effect.
  final String effect;

  /// The color used to represent the tile on the grid.
  final Color color;

  /// Whether the player can move onto this tile.
  final bool isWalkable;

  const TileData(
      {required this.name,
      required this.description,
      required this.effect,
      required this.color,
      this.isWalkable = true});
}