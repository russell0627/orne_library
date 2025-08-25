import 'package:flutter/widgets.dart';
import 'package:orne_library/src/grid_system/breakpoints.dart';

/// A column in the responsive grid.
///
/// This widget is a data carrier for [ResponsiveGridRow]. It specifies how many
/// columns its [child] should span on various screen sizes.
class ResponsiveGridCol extends StatelessWidget {
  /// The number of columns to span on extra small screens (width < 576px).
  /// Defaults to 12.
  final int xs;

  /// The number of columns to span on small screens (width >= 576px).
  final int? sm;

  /// The number of columns to span on medium screens (width >= 768px).
  final int? md;

  /// The number of columns to span on large screens (width >= 992px).
  final int? lg;

  /// The number of columns to span on extra large screens (width >= 1200px).
  final int? xl;

  /// The number of columns to span on extra extra large screens (width >= 1400px).
  final int? xxl;

  /// The widget below this widget in the tree.
  final Widget child;

  const ResponsiveGridCol({
    super.key,
    this.xs = 12,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    required this.child,
  });

  /// Calculates the column span for a given screen width.
  ///
  /// It falls back to the next smaller defined breakpoint if a specific
  /// breakpoint is not provided.
  int getSpan(double screenWidth) {
    if (screenWidth >= Breakpoints.xxl && xxl != null) return xxl!;
    if (screenWidth >= Breakpoints.xl && xl != null) return xl!;
    if (screenWidth >= Breakpoints.lg && lg != null) return lg!;
    if (screenWidth >= Breakpoints.md && md != null) return md!;
    if (screenWidth >= Breakpoints.sm && sm != null) return sm!;

    // Fallback logic
    if (screenWidth >= Breakpoints.xxl) return xl ?? lg ?? md ?? sm ?? xs;
    if (screenWidth >= Breakpoints.xl) return lg ?? md ?? sm ?? xs;
    if (screenWidth >= Breakpoints.lg) return md ?? sm ?? xs;
    if (screenWidth >= Breakpoints.md) return sm ?? xs;
    if (screenWidth >= Breakpoints.sm) return xs;
    return xs;
  }

  @override
  Widget build(BuildContext context) {
    // This widget only carries data. The parent [ResponsiveGridRow] performs
    // the layout. We simply return the child.
    return child;
  }
}

/// A row in the responsive grid system that lays out [ResponsiveGridCol] children.
///
/// It automatically wraps columns to the next line if they exceed the
/// [totalColumns] count. It uses [LayoutBuilder] to react to screen size changes.
class ResponsiveGridRow extends StatelessWidget {
  /// The list of [ResponsiveGridCol] widgets for this row.
  final List<ResponsiveGridCol> children;

  /// The total number of columns available in the grid. Defaults to 12.
  final int totalColumns;

  /// The horizontal spacing between columns. Defaults to 0.
  final double colSpacing;

  /// The vertical spacing between rows. Defaults to 0.
  final double rowSpacing;

  const ResponsiveGridRow({
    super.key,
    required this.children,
    this.totalColumns = 12,
    this.colSpacing = 0,
    this.rowSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double screenWidth = constraints.maxWidth;
        final List<Widget> rows = [];
        final List<ResponsiveGridCol> currentRowItems = [];
        int currentSpan = 0;

        for (final col in children) {
          final span = col.getSpan(screenWidth);
          if (currentSpan + span > totalColumns && currentRowItems.isNotEmpty) {
            // Finish the current row and start a new one
            rows.add(_buildRow(currentRowItems, screenWidth));
            currentRowItems.clear();
            currentSpan = 0;
          }

          currentRowItems.add(col);
          currentSpan += span;
        }

        // Add the last remaining row
        if (currentRowItems.isNotEmpty) {
          rows.add(_buildRow(currentRowItems, screenWidth));
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(rows.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: index < rows.length - 1 ? rowSpacing : 0),
              child: rows[index],
            );
          }),
        );
      },
    );
  }

  Widget _buildRow(List<ResponsiveGridCol> cols, double screenWidth) {
    final List<Widget> rowChildren = [];
    for (int i = 0; i < cols.length; i++) {
      final col = cols[i];
      rowChildren.add(Expanded(flex: col.getSpan(screenWidth), child: col.child));

      if (i < cols.length - 1 && colSpacing > 0) {
        rowChildren.add(SizedBox(width: colSpacing));
      }
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: rowChildren);
  }
}