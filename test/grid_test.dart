import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:grid/grid.dart';

Grid generateGrid(
  int numRows,
  int numColumns, {
  List<int> hiddenColumns = const [],

  /// Horizontal separator for the grid header
  /// e.g (context, index) => const Divider()
  Widget Function(BuildContext)? horizontalHeaderSeparatorBuilder,

  /// Horizontal separator for the grid body
  /// e.g (context, index) => const Divider()
  Widget Function(BuildContext, int)? horizontalSeparatorBuilder,
  int initialColumnIndex = 0,
}) {
  final columns = List.generate(
    numColumns,
    (index) => GridColumn(
      hide: hiddenColumns.contains(index),
      ascendingFirst: true,
      width: 180,
      child: Text("Header $index"),
    ),
  );

  final rows = List.generate(
    numRows,
    (rowIndex) => GridRow(
      children: List.generate(
        columns.length,
        (columnIndex) => GridCell(
          value: "Row: $rowIndex, Column: $columnIndex",
          child: Text("Row: $rowIndex, Column: $columnIndex"),
        ),
      ),
    ),
  );

  return Grid(
    initialColumnIndex: initialColumnIndex,
    horizontalHeaderSeparatorBuilder: horizontalHeaderSeparatorBuilder,
    horizontalSeparatorBuilder: horizontalSeparatorBuilder,
    columns: columns,
    rows: rows,
  );
}

void main() {
  testWidgets('Grid displays', (tester) async {
    final grid = generateGrid(6, 3);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: grid)));
    await tester.pumpAndSettle();
    expect(find.text('Row: 0, Column: 0'), findsOneWidget);
    expect(find.text('Row: 0, Column: 1'), findsOneWidget);
    expect(find.text('Row: 1, Column: 0'), findsOneWidget);
    expect(find.text('Row: 1, Column: 0'), findsOneWidget);
  });

  testWidgets("tests grid sorts", (tester) async {
    final grid = generateGrid(6, 5);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: grid)));
    await tester.pumpAndSettle();
    expect(grid.rows.first.children[1].value, "Row: 0, Column: 1");
    expect(find.byIcon(Icons.arrow_upward_rounded), findsNothing);
    expect(find.byIcon(Icons.arrow_downward_rounded), findsNothing);

    await tester.tap(find.text("Header 2"));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
    expect(grid.rows.first.children[1].value, "Row: 0, Column: 1");

    await tester.tap(find.text("Header 2"));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
    expect(grid.rows.first.children[1].value, "Row: 5, Column: 1");

    await tester.tap(find.text("Header 2"));
    await tester.pumpAndSettle();
    expect(grid.rows.first.children.first.value, "Row: 0, Column: 0");
    expect(find.byIcon(Icons.arrow_upward_rounded), findsNothing);
    expect(find.byIcon(Icons.arrow_downward_rounded), findsNothing);
  });

  testWidgets("tests hidden columns", (tester) async {
    final grid = generateGrid(
      6,
      5,
      hiddenColumns: [1, 3],
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: grid)));
    await tester.pumpAndSettle();

    expect(find.text('Row: 0, Column: 0'), findsOneWidget);
    expect(find.text('Row: 1, Column: 0'), findsOneWidget);
    expect(find.text('Row: 1, Column: 0'), findsOneWidget);

    expect(find.text('Row: 0, Column: 1'), findsNothing);
    expect(find.text('Row: 0, Column: 3'), findsNothing);
    expect(find.text('Row: 1, Column: 1'), findsNothing);
    expect(find.text('Row: 1, Column: 3'), findsNothing);
  });

  testWidgets("tests horizontal separator", (tester) async {
    final grid = generateGrid(
      6,
      5,
      horizontalHeaderSeparatorBuilder: (context) => const Divider(),
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: grid)));
    await tester.pumpAndSettle();

    expect(find.byType(Divider), findsOneWidget);

    final gridTwo = generateGrid(
      6,
      5,
      horizontalSeparatorBuilder: (context, index) => const Divider(),
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: gridTwo)));
    await tester.pumpAndSettle();
    // 6 rows = 5 dividers but each row contains two dividers hence 10.
    // This is because the first row has a separate divider to the body,
    // due to the implementation
    expect(find.byType(Divider), findsNWidgets(10));
  });
}
