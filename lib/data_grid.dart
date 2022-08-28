library data_grid;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:data_grid/src/components.dart';
import 'package:sync_scroll_controller/sync_scroll_controller.dart';

/// The [Grid]
class Grid extends StatefulWidget {
  /// Create a [Grid]
  Grid({
    Key? key,

    /// The columns headings of the grid
    required this.columns,

    /// The rows of the grid
    required this.rows,

    /// The height of the columns header.
    this.columnsHeaderHeight = 40,

    /// The initial column to show
    /// Set this to 1 to have the column at index 0 hidden by scroll
    this.initialColumnIndex = 0,

    /// The column index to sort initially
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

  /// Horizontal separator for the grid body
  late final Widget Function(BuildContext, int) horizontalSeparatorBuilder;

  /// Horizontal separator for the grid header
  late final Widget Function(BuildContext) horizontalHeaderSeparatorBuilder;
  // The height of the columns header
  final double columnsHeaderHeight;

  /// The columns headings of the grid
  final List<GridColumn> columns;

  /// The rows of the grid
  final List<GridRow> rows;

  /// The initial column to show
  final int initialColumnIndex;

  /// The column index to sort initially
  final int defaultSortedColumnIndex;

  /// Scroll Physics for the [Gr  id]
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

  void resortBySortedColumn() {
    for (int i = 0; i < widget.columns.length; i++) {
      switch (widget.columns[i].sortingState) {
        case SortingState.descending:
          widget.rows.sort(
            (a, b) => a.children[i].sortValue.compareTo(
              b.children[i].sortValue,
            ),
          );
          return;
        case SortingState.ascending:
          widget.rows.sort(
            (a, b) => b.children[i].sortValue.compareTo(
              a.children[i].sortValue,
            ),
          );
          return;
        case SortingState.none:
          continue;
      }
    }
  }

  List<int> createVirtualColumnIndices() {
    List<int> result = [];
    for (int i = 0; i < widget.columns.length; i++) {
      if (!widget.columns[i].hide) {
        result.add(i);
      }
    }
    return result;
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
    assert(column._autoFitColumnData != null);

    const sortIconWidth = 20;
    const sortIconPadding = 8;
    double width = _textWidth(
          column._autoFitColumnData!.text,
          column._autoFitColumnData?.style,
        ) +
        sortIconWidth +
        sortIconPadding +
        (column._autoFitColumnData!.padding?.horizontal ?? 0);

    for (int j = 0; j < widget.rows.length; j++) {
      final autoFitColumnData =
          rows[j].children[columnIndex]._autoFitColumnData;
      if (autoFitColumnData == null) {
        throw ArgumentError(
          "Column(${column.child}): $columnIndex was a GridColumn.autoFitWidth column but GridCell Column: $columnIndex Row: $j was not a GridCell.autoFitWidth. Every cell in an GridColumn.autoFitWidth column must be an GridCell.autoFitWidth cell.",
        );
      }
      width = max(
        width,
        _textWidth(
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

  List<double> calculateColumnWidths(List<int> indices) {
    List<double> result = [];
    for (int index in indices) {
      result.add(widget.columns[index].width);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final indices = createVirtualColumnIndices();
    sizeColumns(widget.columns, widget.rows);
    resortBySortedColumn();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridColumnHeader(
          physics: widget.physics,
          columnsHeaderHeight: widget.columnsHeaderHeight,
          sortByColumn: sortByColumn,
          columns: widget.columns,
          indices: indices,
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
                indices: indices,
                physics: widget.physics,
                rows: widget.rows,
                columnWidths: calculateColumnWidths(indices),
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

double _textWidth(String text, TextStyle? style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size.width;
}

/// [GridCell] contains the information to display a Grid Cell Widget
class GridCell<T extends Comparable<dynamic>> {
  /// Must be placed in a [GridColumn.autoFitWidth] column
  /// Will sized to the width of the widest cell in the column
  /// efficiently for large data sets
  GridCell.autoFitWidth({
    required this.sortValue,
    required String text,
    TextStyle? style,
    BuildContext? context,
    EdgeInsets? padding = EdgeInsets.zero,
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
        _autoFitColumnData = _AutoFitColumnData(
          text: text,
          style: style ?? DefaultTextStyle.of(context!).style,
          padding: padding,
        );

  /// Must be placed in a [GridColumn.fixedWidth] column
  /// Will sized to the fixed width of the column
  const GridCell.fixedWidth({
    required this.sortValue,
    required this.child,
  }) : _autoFitColumnData = null;

  final Widget child;
  final T sortValue;
  final _AutoFitColumnData? _autoFitColumnData;
}

/// Describes the data needed to size a column to the width of the widest cell
class _AutoFitColumnData {
  const _AutoFitColumnData({
    /// The text to display
    required this.text,

    /// The style of the text
    required this.style,

    /// The padding of the text
    this.padding,
  });

  /// The text to display
  final String text;

  /// The style of the text
  final TextStyle style;

  /// The padding of the text
  final EdgeInsets? padding;
}

class GridColumn {
  /// autoFitWidth Columns will be resized to fit the width of the largest cell
  /// in the column.
  /// Has to be a String so we can calculate the width of the text.
  GridColumn.autoFitWidth({
    /// The text to display
    required String text,

    /// Context to calculate the default text style if no text style is provided
    BuildContext? context,

    /// The text style
    TextStyle? style,

    /// The alignment of the text in the [GridCell]
    Alignment alignment = Alignment.centerRight,

    /// The text alignment of the text
    TextAlign textAlign = TextAlign.right,

    /// The padding of the text
    EdgeInsets? padding,

    /// Whether to sort ascending first
    this.ascendingFirst = false,

    /// Whether sort icon should be first or last
    this.trailingIcon = false,

    /// Whether mainAxisAlignment should be start or end
    this.mainAxisAlignment = MainAxisAlignment.end,

    /// Whether to hide this column or not
    this.hide = false,
  })  : assert(context != null || style != null),
        _autoFitColumnData = _AutoFitColumnData(
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
  })  : _autoFitColumnData = null,
        autoFitWidth = false,
        assert(width > 0);

  final Widget child;

  final _AutoFitColumnData? _autoFitColumnData;
  final bool autoFitWidth;
  // Fixed width
  double width;

  final bool ascendingFirst;
  final bool trailingIcon;
  final MainAxisAlignment mainAxisAlignment;
  bool hide;
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

/// The current sorting state of a column
enum SortingState {
  descending,
  ascending,
  none;

  /// The icon to display for the current sorting state
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

  /// The next sorting state
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
