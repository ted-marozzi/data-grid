import 'package:flutter/material.dart';

import '../data_grid.dart';

class GridRowHeader extends StatelessWidget {
  const GridRowHeader({
    Key? key,
    required this.width,
    required this.separatorBuilder,
    required this.rows,
    required this.scrollController,
    required this.physics,
    required this.onHoverIndex,
    this.hoveringRowIndex,
    this.highlightDecoration,
    this.selectedRowIndex,
    this.selectedDecoration,
  }) : super(key: key);

  final double width;
  final Widget Function(BuildContext, int) separatorBuilder;
  final ScrollController scrollController;
  final List<GridRow> rows;
  final ScrollPhysics? physics;
  final void Function(int?) onHoverIndex;
  final int? hoveringRowIndex;
  final BoxDecoration? highlightDecoration;
  final int? selectedRowIndex;
  final BoxDecoration? selectedDecoration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ListView.separated(
        physics: physics,
        separatorBuilder: separatorBuilder,
        controller: scrollController,
        itemCount: rows.length,
        itemBuilder: (context, index) => _GridRowHeaderItem(
          item: rows[index],
          isHovering: hoveringRowIndex == index,
          onHover: (isHovering) => onHoverIndex(isHovering ? index : null),
          highlightDecoration: highlightDecoration,
          isSelected: selectedRowIndex == index,
          selectedDecoration: selectedDecoration,
        ),
      ),
    );
  }
}

class _GridRowHeaderItem extends StatefulWidget {
  const _GridRowHeaderItem({
    Key? key,
    required this.item,
    required this.onHover,
    this.isHovering = false,
    this.highlightDecoration,
    this.isSelected = false,
    this.selectedDecoration,
  }) : super(key: key);

  final GridRow item;
  final void Function(bool) onHover;
  final bool isHovering;
  final BoxDecoration? highlightDecoration;
  final bool isSelected;
  final BoxDecoration? selectedDecoration;

  @override
  State<_GridRowHeaderItem> createState() => _GridRowHeaderItemState();
}

class _GridRowHeaderItemState extends State<_GridRowHeaderItem> {
  var _isHovering = false;

  @override
  void initState() {
    super.initState();

    _isHovering = widget.isHovering;
  }

  @override
  void didUpdateWidget(covariant _GridRowHeaderItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    _isHovering = widget.isHovering;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Instead of limiting the click area to child's clickable area,
      // use complete area of widget
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.item.onTap?.call();
        widget.item.children.first.onTap?.call();
      },
      onLongPress: widget.item.onLongPress?.call,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          widget.onHover(true);
          setState(() => _isHovering = true);
        },
        onExit: (_) {
          widget.onHover(false);
          setState(() => _isHovering = false);
        },
        child: Container(
          decoration: _getDecoration(),
          height: widget.item.height,
          child: widget.item.children.first.child,
        ),
      ),
    );
  }

  BoxDecoration? _getDecoration() {
    if (widget.isSelected) {
      return widget.selectedDecoration ??
          BoxDecoration(
            color: Theme.of(context).primaryColor,
          );
    } else if (_isHovering) {
      return widget.highlightDecoration ??
          BoxDecoration(
            color: Theme.of(context).splashColor,
          );
    }

    return null;
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
    required this.indices,
    required this.sortingIconSettings,
    required this.hasRowHeader,
  }) : super(key: key);

  final List<GridColumn> columns;
  final ScrollController scrollController;
  final ScrollPhysics? physics;
  final List<int> indices;
  final SortingIconSettings sortingIconSettings;
  final bool hasRowHeader;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: columnsHeaderHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasRowHeader)
            GridColumnHeaderCell(
              sortColumn: () => sortByColumn(indices.first),
              column: columns[indices.first],
              sortingIconSettings: sortingIconSettings,
            ),
          Expanded(
            child: ListView.builder(
                physics: physics,
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: hasRowHeader ? indices.length - 1 : indices.length,
                itemBuilder: (context, columnIndex) {
                  int index =
                      indices[hasRowHeader ? columnIndex + 1 : columnIndex];
                  return GridColumnHeaderCell(
                    sortColumn: () => sortByColumn(index),
                    column: columns[index],
                    sortingIconSettings: sortingIconSettings,
                  );
                }),
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
    required this.sortingIconSettings,
  }) : super(key: key);

  final void Function() sortColumn;
  final GridColumn column;
  final SortingIconSettings sortingIconSettings;

  @override
  Widget build(BuildContext context) {
    final Widget sortIcon = Padding(
      padding: sortingIconSettings.padding,
      child: column.sortingState.getIcon(sortingIconSettings),
    );

    return SizedBox(
      width: column.width,
      child: InkWell(
        onTap: sortColumn,
        // So the inkwell takes the whole space available
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: column.mainAxisAlignment,
            children: [
              if (!column.trailingIcon) sortIcon,
              column.child,
              if (column.trailingIcon) sortIcon,
            ],
          ),
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
    required this.indices,
    required this.showHeader,
    required this.onHoverIndex,
    this.hoveringRowIndex,
    this.highlightDecoration,
    this.selectedRowIndex,
    this.selectedDecoration,
  }) : super(key: key);

  final List<GridRow> rows;
  final List<double> columnWidths;
  final Widget Function(BuildContext, int) horizontalSeparatorBuilder;
  final ScrollController rowsControllerX, rowsControllerY;
  final ScrollPhysics? physics;
  final List<int> indices;
  final bool showHeader;
  final void Function(int?) onHoverIndex;
  final int? hoveringRowIndex;
  final BoxDecoration? highlightDecoration;
  final int? selectedRowIndex;
  final BoxDecoration? selectedDecoration;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: rowsControllerX,
        physics: physics,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: columnWidths.fold<double>(
            // when header isn't shown, remove the header row width
            showHeader ? 0 : -columnWidths.first,
            (previousValue, width) => previousValue + width,
          ),
          child: ListView.separated(
            physics: physics,
            separatorBuilder: horizontalSeparatorBuilder,
            controller: rowsControllerY,
            itemCount: rows.length,
            itemBuilder: (context, rowIndex) => _GridRowItem(
              item: rows[rowIndex],
              columnWidths: columnWidths,
              indices: indices,
              showHeader: showHeader,
              isHovering: hoveringRowIndex == rowIndex,
              onHover: (isHovering) =>
                  onHoverIndex(isHovering ? rowIndex : null),
              highlightDecoration: highlightDecoration,
              isSelected: selectedRowIndex == rowIndex,
              selectedDecoration: selectedDecoration,
            ),
          ),
        ),
      ),
    );
  }
}

class _GridRowItem extends StatefulWidget {
  const _GridRowItem({
    required this.item,
    required this.columnWidths,
    required this.indices,
    required this.showHeader,
    required this.onHover,
    this.isHovering = false,
    this.highlightDecoration,
    this.isSelected = false,
    this.selectedDecoration,
    Key? key,
  }) : super(key: key);

  final GridRow item;
  final List<double> columnWidths;
  final List<int> indices;
  final bool showHeader;
  final void Function(bool) onHover;
  final bool isHovering;
  final BoxDecoration? highlightDecoration;
  final bool isSelected;
  final BoxDecoration? selectedDecoration;

  @override
  State<_GridRowItem> createState() => _GridRowItemState();
}

class _GridRowItemState extends State<_GridRowItem> {
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();

    _isHovering = widget.isHovering;
  }

  @override
  void didUpdateWidget(covariant _GridRowItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    _isHovering = widget.isHovering;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Instead of limiting the click area to child's clickable area,
      // use complete area of widget
      behavior: HitTestBehavior.translucent,
      onTap: widget.item.onTap?.call,
      onLongPress: widget.item.onLongPress?.call,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          widget.onHover(true);
          setState(() => _isHovering = true);
        },
        onExit: (_) {
          widget.onHover(false);
          setState(() => _isHovering = false);
        },
        child: Container(
          decoration: _getDecoration(),
          child: Row(
            children: [
              for (int i = widget.showHeader ? 0 : 1;
                  i < widget.indices.length;
                  i++)
                GestureDetector(
                  // As small as possible so only content is tapped
                  onTap: () {
                    widget.item.children[widget.indices[i]].onTap?.call();
                    // This detector absorbs onTap so also invoke GridRow onTap
                    widget.item.onTap?.call();
                  },
                  child: SizedBox(
                    height: widget.item.height,
                    width: widget.columnWidths[i],
                    child: widget.item.children[widget.indices[i]].child,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration? _getDecoration() {
    if (widget.isSelected) {
      return widget.selectedDecoration ??
          BoxDecoration(
            color: Theme.of(context).primaryColor,
          );
    } else if (_isHovering) {
      return widget.highlightDecoration ??
          BoxDecoration(
            color: Theme.of(context).splashColor,
          );
    }

    return null;
  }
}
