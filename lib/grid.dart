library grid;

import 'package:flutter/material.dart';
import 'package:grid/src/components.dart';
import 'package:sync_scroll_controller/sync_scroll_controller.dart';

class Grid extends StatefulWidget {
  /// Create a [Grid]
  Grid({
    Key? key,
    required this.columns,
    required this.rows,
    // The height of the columns header.
    this.columnsHeaderHeight = 40,

    /// The initial column to show
    /// Set this to 1 to have the column at index 0 hidden by scroll
    this.initialColumnIndex = 0,
    this.defaultSortedColumnIndex = 0,

    /// Scroll Physics for the [Grid]
    this.physics,

    /// Horizontal separator for the grid header
    /// e.g (context, index) => const Divider()
    Widget Function(BuildContext)? horizontalHeaderSeparatorBuilder,

    /// Horizontal separator for the grid body
    /// e.g (context, index) => const Divider()
    Widget Function(BuildContext, int)? horizontalSeparatorBuilder,
  })  : assert(
          rows.every((element) => element.children.length == columns.length),
        ),
        super(key: key) {
    this.horizontalSeparatorBuilder =
        horizontalSeparatorBuilder ?? (context, index) => Container();
    this.horizontalHeaderSeparatorBuilder =
        horizontalHeaderSeparatorBuilder ?? (context) => Container();

    _removeHiddenColumns();
  }

  void _removeHiddenColumns() {
    int removed = 0;
    for (int i = 0; i < columns.length; i++) {
      if (columns[i].hide) {
        for (GridRow row in rows) {
          row.children.removeAt(i - removed);
        }
        removed++;
      }
    }
    columns.removeWhere((element) => element.hide);
  }

  late final Widget Function(BuildContext, int) horizontalSeparatorBuilder;
  late final Widget Function(BuildContext) horizontalHeaderSeparatorBuilder;
  final double columnsHeaderHeight;
  final List<GridColumn> columns;
  final List<GridRow> rows;
  final int initialColumnIndex;
  final int defaultSortedColumnIndex;
  final ScrollPhysics? physics;
  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  late List<GridColumn> columns;
  late List<GridRow> rows;

  late ScrollController rowHeaderController;
  late ScrollController columnHeaderController;
  late ScrollController rowsControllerY;
  late ScrollController rowsControllerX;
  final verticalControllers = SyncScrollControllerGroup();
  late final SyncScrollControllerGroup horizontalControllers;

  @override
  void initState() {
    super.initState();
    columns = widget.columns.toList();
    rows = widget.rows.toList();
    horizontalControllers = SyncScrollControllerGroup(
      initialScrollOffset: calculateColumnOffset(
        widget.initialColumnIndex,
      ),
    );

    rowsControllerY = verticalControllers.addAndGet();
    rowsControllerX = horizontalControllers.addAndGet();
    rowHeaderController = verticalControllers.addAndGet();
    columnHeaderController = horizontalControllers.addAndGet();

    sortByColumn(widget.defaultSortedColumnIndex, false);
  }

  double calculateColumnOffset(int index) {
    double offset = 0;
    for (int i = 1; i < index + 1; i++) {
      offset += columns[i].width;
    }
    return offset;
  }

  void resetSortingState([int? excludeColumnIndex]) {
    for (var i = 0; i < columns.length; i++) {
      if (i == excludeColumnIndex) {
        continue;
      }
      columns[i].sortingState = SortingState.none;
    }
  }

  void sortByColumn(int columnIndex, [bool showSortIcon = true]) {
    final column = columns[columnIndex];
    column.sortingState =
        column.sortingState.getNextState(column.ascendingFirst);
    resetSortingState(showSortIcon ? columnIndex : null);
    switch (column.sortingState) {
      case SortingState.ascending:
        rows.sort(
          (a, b) => a.children[columnIndex].value.compareTo(
            b.children[columnIndex].value,
          ),
        );
        break;
      case SortingState.descending:
        rows.sort(
          (a, b) => b.children[columnIndex].value.compareTo(
            a.children[columnIndex].value,
          ),
        );
        break;
      case SortingState.none:
        sortByColumn(0);
        columns.first.sortingState = SortingState.none;
        break;
    }
    setState(() {});
  }

  @override
  void dispose() {
    rowsControllerX.dispose();
    rowsControllerY.dispose();
    columnHeaderController.dispose();
    rowHeaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridColumnHeader(
          physics: widget.physics,
          columnsHeaderHeight: widget.columnsHeaderHeight,
          sortByColumn: sortByColumn,
          columns: columns,
          scrollController: columnHeaderController,
        ),
        widget.horizontalHeaderSeparatorBuilder(context),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridRowHeader(
                physics: widget.physics,
                rows: rows,
                width: columns.first.width,
                scrollController: rowHeaderController,
                separatorBuilder: widget.horizontalSeparatorBuilder,
              ),
              GridRows(
                physics: widget.physics,
                rows: rows,
                columnWidths: columns.map((e) => e.width).toList(),
                horizontalSeparatorBuilder: widget.horizontalSeparatorBuilder,
                rowsControllerY: rowsControllerY,
                rowsControllerX: rowsControllerX,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GridCell<T extends Comparable<dynamic>> {
  const GridCell({
    required this.value,
    required this.child,
  });
  final Widget child;
  final T value;
}

class GridColumn {
  GridColumn({
    required this.child,
    this.width = 78,
    this.ascendingFirst = false,
    this.trailingIcon = false,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.hide = false,
  });
  final Widget child;
  final double width;
  final bool ascendingFirst;
  final bool trailingIcon;
  final MainAxisAlignment mainAxisAlignment;
  final bool hide;
  SortingState sortingState = SortingState.none;
}

class GridRow {
  const GridRow({
    required this.children,
    this.height = 40,
  });
  final List<GridCell> children;
  final double height;
}

enum SortingState {
  descending,
  ascending,
  none;

  Widget getIcon() {
    switch (this) {
      case SortingState.ascending:
        return const Icon(
          Icons.arrow_upward_rounded,
          size: 20,
        );
      case SortingState.descending:
        return const Icon(
          Icons.arrow_downward_rounded,
          size: 20,
        );
      case SortingState.none:
        return const SizedBox(width: 20, height: 20);
    }
  }

  SortingState getNextState(bool ascendingFirst) {
    if (ascendingFirst) {
      switch (this) {
        case SortingState.descending:
          return SortingState.none;
        case SortingState.ascending:
          return SortingState.descending;
        case SortingState.none:
          return SortingState.ascending;
      }
    }
    switch (this) {
      case SortingState.descending:
        return SortingState.ascending;
      case SortingState.ascending:
        return SortingState.none;
      case SortingState.none:
        return SortingState.descending;
    }
  }
}
