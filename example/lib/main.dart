import 'package:flutter/material.dart';
import 'package:grid/grid.dart';

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
        body: Grid(
          columns: [
            GridColumn(
              width: 200,
              trailingIcon: true,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Frozen Column',
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            GridColumn(width: 100, child: const Text('Column 2')),
            GridColumn(width: 100, child: const Text('Column 3')),
            GridColumn(width: 100, child: const Text('Column 4')),
            GridColumn(width: 100, child: const Text('Column 5')),
            GridColumn(width: 100, child: const Text('Column 6')),
          ],
          rows: const [
            GridRow(children: [
              GridCell(
                  child: Text('Row 1, Column 1'), value: "Row 1, Column 1"),
              GridCell(
                  child: Text('Row 1, Column 2'), value: "Row 1, Column 2"),
              GridCell(
                  child: Text('Row 1, Column 3'), value: "Row 1, Column 3"),
              GridCell(
                  child: Text('Row 1, Column 4'), value: "Row 1, Column 4"),
              GridCell(
                  child: Text('Row 1, Column 5'), value: "Row 1, Column 5"),
              GridCell(
                  child: Text('Row 1, Column 6'), value: "Row 1, Column 6"),
            ]),
            GridRow(children: [
              GridCell(
                  child: Text('Row 2, Column 1'), value: "Row 2, Column 1"),
              GridCell(
                  child: Text('Row 2, Column 2'), value: "Row 2, Column 2"),
              GridCell(
                  child: Text('Row 2, Column 3'), value: "Row 2, Column 3"),
              GridCell(
                  child: Text('Row 2, Column 4'), value: "Row 2, Column 4"),
              GridCell(
                  child: Text('Row 2, Column 5'), value: "Row 2, Column 5"),
              GridCell(
                  child: Text('Row 2, Column 6'), value: "Row 2, Column 6"),
            ]),
            GridRow(children: [
              GridCell(
                  child: Text('Row 3, Column 1'), value: "Row 3, Column 1"),
              GridCell(
                  child: Text('Row 3, Column 2'), value: "Row 3, Column 2"),
              GridCell(
                  child: Text('Row 3, Column 3'), value: "Row 3, Column 3"),
              GridCell(
                  child: Text('Row 3, Column 4'), value: "Row 3, Column 4"),
              GridCell(
                  child: Text('Row 3, Column 5'), value: "Row 3, Column 5"),
              GridCell(
                  child: Text('Row 3, Column 6'), value: "Row 3, Column 6"),
            ]),
            GridRow(children: [
              GridCell(
                  child: Text('Row 4, Column 1'), value: "Row 4, Column 1"),
              GridCell(
                  child: Text('Row 4, Column 2'), value: "Row 4, Column 2"),
              GridCell(
                  child: Text('Row 4, Column 3'), value: "Row 4, Column 3"),
              GridCell(
                  child: Text('Row 4, Column 4'), value: "Row 4, Column 4"),
              GridCell(
                  child: Text('Row 4, Column 5'), value: "Row 4, Column 5"),
              GridCell(
                  child: Text('Row 4, Column 6'), value: "Row 4, Column 6"),
            ]),
            GridRow(children: [
              GridCell(
                  child: Text('Row 5, Column 1'), value: "Row 5, Column 1"),
              GridCell(
                  child: Text('Row 5, Column 2'), value: "Row 5, Column 2"),
              GridCell(
                  child: Text('Row 5, Column 3'), value: "Row 5, Column 3"),
              GridCell(
                  child: Text('Row 5, Column 4'), value: "Row 5, Column 4"),
              GridCell(
                  child: Text('Row 5, Column 5'), value: "Row 5, Column 5"),
              GridCell(
                  child: Text('Row 5, Column 6'), value: "Row 5, Column 6"),
            ]),
          ],
        ),
      ),
    );
  }
}
