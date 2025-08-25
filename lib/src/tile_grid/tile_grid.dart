import 'package:flutter/material.dart';

/// A widget that holds the position and size information for an item
/// within a [TileGrid].
///
/// This widget is a data carrier and should be a direct child of [TileGrid].
class TileGridItem extends StatelessWidget {
  /// The horizontal position on the grid, in tile units.
  final int x;

  /// The vertical position on the grid, in tile units.
  final int y;

  /// The width of the item, in tile units. Defaults to 1.
  final int width;

  /// The height of the item, in tile units. Defaults to 1.
  final int height;

  /// The widget to display within the grid item.
  final Widget child;

  const TileGridItem({
    super.key,
    required this.x,
    required this.y,
    this.width = 1,
    this.height = 1,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // This widget is a data carrier for TileGrid.
    // The actual layout is handled by the parent.
    return child;
  }
}

/// A widget that arranges its [TileGridItem] children on a fixed-size grid.
///
/// Each tile in the grid has a defined width and height. Children are positioned
/// using a [Stack] based on their tile coordinates.
class TileGrid extends StatelessWidget {
  /// The list of [TileGridItem] children to display on the grid.
  final List<TileGridItem> children;

  /// The total width of the grid, in tile units.
  final int gridWidth;

  /// The total height of the grid, in tile units.
  final int gridHeight;

  /// The width of a single grid tile. Defaults to 8.0.
  final double tileWidth;

  /// The height of a single grid tile. Defaults to 8.0.
  final double tileHeight;

  /// Whether to paint grid lines for visualization. Defaults to false.
  final bool showGridLines;

  const TileGrid({
    super.key,
    required this.children,
    required this.gridWidth,
    required this.gridHeight,
    this.tileWidth = 8.0,
    this.tileHeight = 8.0,
    this.showGridLines = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget grid = SizedBox(
      width: gridWidth * tileWidth,
      height: gridHeight * tileHeight,
      child: Stack(
        children: children.map((item) {
          return Positioned(
            left: item.x * tileWidth,
            top: item.y * tileHeight,
            width: item.width * tileWidth,
            height: item.height * tileHeight,
            child: item.child,
          );
        }).toList(),
      ),
    );

    if (showGridLines) {
      grid = CustomPaint(
        painter: _GridPainter(
          gridWidth: gridWidth,
          gridHeight: gridHeight,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
        ),
        child: grid,
      );
    }

    return grid;
  }
}

class _GridPainter extends CustomPainter {
  final int gridWidth; // in tiles
  final int gridHeight; // in tiles
  final double tileWidth; // in pixels
  final double tileHeight; // in pixels

  _GridPainter({
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;

    // Draw vertical lines
    for (int i = 0; i <= gridWidth; i++) {
      final dx = i * tileWidth;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

    // Draw horizontal lines
    for (int i = 0; i <= gridHeight; i++) {
      final dy = i * tileHeight;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) {
    return oldDelegate.gridWidth != gridWidth ||
        oldDelegate.gridHeight != gridHeight ||
        oldDelegate.tileWidth != tileWidth ||
        oldDelegate.tileHeight != tileHeight;
  }
}