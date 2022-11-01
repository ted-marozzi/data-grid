import 'package:data_grid/data_grid.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // Man github copilot loved this
      home: Scaffold(
        body: SafeArea(
          child: Grid(
            horizontalHeaderSeparatorBuilder: (_) => const Divider(
              height: 0.1,
            ),
            columns: [
              GridColumn.fixedWidth(
                width: 130,
                trailingIcon: true,
                mainAxisAlignment: MainAxisAlignment.start,
                child: const Text(
                  'Frozen Column',
                ),
              ),
              GridColumn.fixedWidth(width: 120, child: const Text('Column 2')),
              GridColumn.fixedWidth(width: 120, child: const Text('Column 3')),
              GridColumn.fixedWidth(width: 120, child: const Text('Column 4')),
              GridColumn.fixedWidth(width: 120, child: const Text('Column 5')),
              GridColumn.fixedWidth(width: 120, child: const Text('Column 6')),
            ],
            rows: [
              GridRow(children: [
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Row 1, Column 1'),
                  ),
                  sortValue: "Row 1, Column 1",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 1, Column 2'),
                  ),
                  sortValue: "Row 1, Column 2",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 1, Column 3'),
                  ),
                  sortValue: "Row 1, Column 3",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 1, Column 4'),
                  ),
                  sortValue: "Row 1, Column 4",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 1, Column 5'),
                  ),
                  sortValue: "Row 1, Column 5",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 1, Column 6'),
                  ),
                  sortValue: "Row 1, Column 6",
                ),
              ]),
              GridRow(children: [
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Row 2, Column 1'),
                  ),
                  sortValue: "Row 2, Column 1",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 2, Column 2'),
                  ),
                  sortValue: "Row 2, Column 2",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 2, Column 3'),
                  ),
                  sortValue: "Row 2, Column 3",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 2, Column 4'),
                  ),
                  sortValue: "Row 2, Column 4",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 2, Column 5'),
                  ),
                  sortValue: "Row 2, Column 5",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 2, Column 6'),
                  ),
                  sortValue: "Row 2, Column 6",
                ),
              ]),
              GridRow(children: [
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Row 3, Column 1'),
                  ),
                  sortValue: "Row 3, Column 1",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 3, Column 2'),
                  ),
                  sortValue: "Row 3, Column 2",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 3, Column 3'),
                  ),
                  sortValue: "Row 3, Column 3",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 3, Column 4'),
                  ),
                  sortValue: "Row 3, Column 4",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 3, Column 5'),
                  ),
                  sortValue: "Row 3, Column 5",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 3, Column 6'),
                  ),
                  sortValue: "Row 3, Column 6",
                ),
              ]),
              GridRow(children: [
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Row 4, Column 1'),
                  ),
                  sortValue: "Row 4, Column 1",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 4, Column 2'),
                  ),
                  sortValue: "Row 4, Column 2",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 4, Column 3'),
                  ),
                  sortValue: "Row 4, Column 3",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 4, Column 4'),
                  ),
                  sortValue: "Row 4, Column 4",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 4, Column 5'),
                  ),
                  sortValue: "Row 4, Column 5",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 4, Column 6'),
                  ),
                  sortValue: "Row 4, Column 6",
                ),
              ]),
              GridRow(children: [
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Row 5, Column 1'),
                  ),
                  sortValue: "Row 5, Column 1",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 5, Column 2'),
                  ),
                  sortValue: "Row 5, Column 2",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 5, Column 3'),
                  ),
                  sortValue: "Row 5, Column 3",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 5, Column 4'),
                  ),
                  sortValue: "Row 5, Column 4",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 5, Column 5'),
                  ),
                  sortValue: "Row 5, Column 5",
                ),
                GridCell.fixedWidth(
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Row 5, Column 6'),
                  ),
                  sortValue: "Row 5, Column 6",
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
