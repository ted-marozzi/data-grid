library data_grid;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:data_grid/src/components.dart';
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
  late ScrollController rowHeaderController;
  late ScrollController columnHeaderController;
  late ScrollController rowsControllerY;
  late ScrollController rowsControllerX;
  final verticalControllers = SyncScrollControllerGroup();
  late final SyncScrollControllerGroup horizontalControllers;

  @override
  void initState() {
    super.initState();
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
      if (widget.columns[i].autoFitWidth) {
        offset +=
            calculateAutoFitColumnWidth(i, widget.columns[i], widget.rows);
      } else {
        offset += widget.columns[i].width;
      }
    }
    return offset;
  }

  void resetSortingState([int? excludeColumnIndex]) {
    for (var i = 0; i < widget.columns.length; i++) {
      if (i == excludeColumnIndex) {
        continue;
      }
      widget.columns[i].sortingState = SortingState.none;
    }
  }

  void sortByColumn(int columnIndex, [bool showSortIcon = true]) {
    final column = widget.columns[columnIndex];
    column.sortingState =
        column.sortingState.getNextState(column.ascendingFirst);
    resetSortingState(showSortIcon ? columnIndex : null);
    switch (column.sortingState) {
      case SortingState.ascending:
        widget.rows.sort(
          (a, b) => a.children[columnIndex].sortValue.compareTo(
            b.children[columnIndex].sortValue,
          ),
        );
        break;
      case SortingState.descending:
        widget.rows.sort(
          (a, b) => b.children[columnIndex].sortValue.compareTo(
            a.children[columnIndex].sortValue,
          ),
        );
        break;
      case SortingState.none:
        sortByColumn(0);
        widget.columns.first.sortingState = SortingState.none;
        break;
    }
    setState(() {});
  }

  void removeHiddenColumns(List<GridColumn> columns, List<GridRow> rows) {
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

  void sizeColumns(List<GridColumn> columns, List<GridRow> rows) {
    for (int i = 0; i < columns.length; i++) {
      if (columns[i].autoFitWidth) {
        for (int j = 0; j < rows.length; j++) {
          columns[i].width = calculateAutoFitColumnWidth(
            i,
            widget.columns[i],
            widget.rows,
          );
        }
      }
    }
  }

  double calculateAutoFitColumnWidth(
    int columnIndex,
    GridColumn column,
    List<GridRow> rows,
  ) {
    assert(column.autoFitColumnData != null);

    const sortIconWidth = 20;
    const sortIconPadding = 8;
    double width = textWidth(
          column.autoFitColumnData!.text,
          column.autoFitColumnData?.style,
        ) +
        sortIconWidth +
        sortIconPadding +
        (column.autoFitColumnData!.padding?.horizontal ?? 0);

    for (int j = 0; j < widget.rows.length; j++) {
      final autoFitColumnData = rows[j].children[columnIndex].autoFitColumnData;
      if (autoFitColumnData == null) {
        throw ArgumentError(
          "Column(${column.child}): $columnIndex was a GridColumn.autoFitWidth column but GridCell Column: $columnIndex Row: $j was not a GridCell.autoFitWidth. Every cell in an GridColumn.autoFitWidth column must be an GridCell.autoFitWidth cell.",
        );
      }
      width = max(
        width,
        textWidth(
              autoFitColumnData.text,
              autoFitColumnData.style,
            ) +
            (autoFitColumnData.padding?.horizontal ?? 0),
      );
    }
    return width;
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
    removeHiddenColumns(widget.columns, widget.rows);
    sizeColumns(widget.columns, widget.rows);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridColumnHeader(
          physics: widget.physics,
          columnsHeaderHeight: widget.columnsHeaderHeight,
          sortByColumn: sortByColumn,
          columns: widget.columns,
          scrollController: columnHeaderController,
        ),
        widget.horizontalHeaderSeparatorBuilder(context),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridRowHeader(
                physics: widget.physics,
                rows: widget.rows,
                width: widget.columns.first.width,
                scrollController: rowHeaderController,
                separatorBuilder: widget.horizontalSeparatorBuilder,
              ),
              GridRows(
                physics: widget.physics,
                rows: widget.rows,
                columnWidths: widget.columns.map((e) => e.width).toList(),
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

double textWidth(String text, TextStyle? style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size.width;
}

class GridCell<T extends Comparable<dynamic>> {
  GridCell.autoFitWidth({
    required this.sortValue,
    required String text,
    TextStyle? style,
    BuildContext? context,
    EdgeInsets? padding = const EdgeInsets.only(left: 16),
    Alignment alignment = Alignment.centerRight,
    TextAlign textAlign = TextAlign.right,
  })  : assert(style != null || context != null),
        child = Container(
          alignment: alignment,
          padding: padding,
          child: Text(
            text,
            textAlign: textAlign,
            style: style,
          ),
        ),
        autoFitColumnData = AutoFitColumnData(
          text: text,
          style: style ?? DefaultTextStyle.of(context!).style,
          padding: padding,
        );

  const GridCell.fixedWidth({
    required this.sortValue,
    required this.child,
  }) : autoFitColumnData = null;

  final Widget child;
  final T sortValue;
  final AutoFitColumnData? autoFitColumnData;
}

class AutoFitColumnData {
  const AutoFitColumnData({
    required this.text,
    required this.style,
    this.padding,
  });

  final String text;
  final TextStyle style;
  final EdgeInsets? padding;
}

class GridColumn {
  /// autoFitWidth Columns will be resized to fit the width of the largest cell
  /// in the column.
  /// Has to be a String so we can calculate the width of the text.
  GridColumn.autoFitWidth({
    required String text,
    BuildContext? context,
    TextStyle? style,
    Alignment alignment = Alignment.centerRight,
    TextAlign textAlign = TextAlign.right,
    EdgeInsets? padding,

    // Common properties
    this.ascendingFirst = false,
    this.trailingIcon = false,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.hide = false,
  })  : assert(context != null || style != null),
        autoFitColumnData = AutoFitColumnData(
          text: text,
          style: style ?? DefaultTextStyle.of(context!).style,
          padding: padding,
        ),
        autoFitWidth = true,
        width = -1,
        child = Container(
          padding: padding,
          alignment: alignment,
          child: Text(
            text,
            textAlign: textAlign,
            style: style,
          ),
        );

  GridColumn.fixedWidth({
    required this.child,
    this.width = 80,
    this.ascendingFirst = false,
    this.trailingIcon = false,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.hide = false,
  })  : autoFitColumnData = null,
        autoFitWidth = false,
        assert(width > 0);

  final Widget child;

  // AutoFit
  final AutoFitColumnData? autoFitColumnData;
  final bool autoFitWidth;
  // Fixed width
  double width;

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
