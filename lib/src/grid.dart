import 'package:flutter/material.dart';

import '../grid.dart';

class GridRowHeader extends StatelessWidget {
  const GridRowHeader({
    Key? key,
    required this.width,
    required this.separatorBuilder,
    required this.rows,
    required this.scrollController,
    required this.physics,
  }) : super(key: key);
  final double width;
  final Widget Function(BuildContext, int) separatorBuilder;
  final ScrollController scrollController;
  final List<GridRow> rows;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ListView.separated(
        physics: physics,
        separatorBuilder: separatorBuilder,
        controller: scrollController,
        itemCount: rows.length,
        itemBuilder: (context, index) => SizedBox(
          height: rows[index].height,
          child: rows[index].children.first.child,
        ),
      ),
    );
  }
}

class GridColumnHeader extends StatelessWidget {
  final double columnsHeaderHeight;
  final void Function(int) sortByColumn;
  const GridColumnHeader({
    Key? key,
    required this.columnsHeaderHeight,
    required this.sortByColumn,
    required this.columns,
    required this.scrollController,
    required this.physics,
  }) : super(key: key);
  final List<GridColumn> columns;
  final ScrollController scrollController;
  final ScrollPhysics? physics;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: columnsHeaderHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridColumnHeaderCell(
            sortColumn: () => sortByColumn(0),
            column: columns.first,
          ),
          Expanded(
            child: ListView.builder(
              physics: physics,
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: columns.length - 1,
              itemBuilder: (context, columnIndex) => GridColumnHeaderCell(
                sortColumn: () => sortByColumn(columnIndex + 1),
                column: columns[columnIndex + 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridColumnHeaderCell extends StatelessWidget {
  const GridColumnHeaderCell({
    Key? key,
    required this.sortColumn,
    required this.column,
  }) : super(key: key);
  final void Function() sortColumn;
  final GridColumn column;
  @override
  Widget build(BuildContext context) {
    final Widget sortIcon = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: column.sortingState.getIcon(),
    );
    return InkWell(
      onTap: sortColumn,
      child: SizedBox(
        width: column.width,
        child: Row(
          mainAxisAlignment: column.mainAxisAlignment,
          children: [
            if (!column.trailingIcon) sortIcon,
            column.child,
            if (column.trailingIcon) sortIcon,
          ],
        ),
      ),
    );
  }
}

class GridRows extends StatelessWidget {
  const GridRows({
    Key? key,
    required this.rows,
    required this.columnWidths,
    required this.horizontalSeparatorBuilder,
    required this.rowsControllerX,
    required this.rowsControllerY,
    required this.physics,
  }) : super(key: key);
  final List<GridRow> rows;
  final List<double> columnWidths;
  final Widget Function(BuildContext, int) horizontalSeparatorBuilder;
  final ScrollController rowsControllerX, rowsControllerY;
  final ScrollPhysics? physics;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: rowsControllerX,
        physics: physics,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: columnWidths.fold<double>(
            -columnWidths.first,
            (previousValue, width) => previousValue + width,
          ),
          child: ListView.separated(
            physics: physics,
            separatorBuilder: horizontalSeparatorBuilder,
            controller: rowsControllerY,
            itemCount: rows.length,
            itemBuilder: (context, rowIndex) => Row(
              children: [
                for (int i = 1; i < columnWidths.length; i++)
                  SizedBox(
                    height: rows[rowIndex].height,
                    width: columnWidths[i],
                    child: rows[rowIndex].children[i].child,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
