This package is in development and breaking changes may be made at any time.

Data Grid is a performance focused data grid optimized for large numeric tables.

## Features

- Builders to prevent unnecessary rendering of data.
- Performant layout algorithm, either a fixedWidth or autoFitWidth that doesn't
  need to perform the expensive task of computing a each widgets getMinIntrinsicWidth
- Frozen header row and column headers

Grid widget for dart that features a frozen left and header column
![grid](https://user-images.githubusercontent.com/38032037/180996354-9d39f39e-70f4-4bcc-8680-188591d77d99.gif)

## Getting started

In the command line

```bash
flutter pub get linked_scroll_controller
```

## Usage

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Grid(
      columns: [
        GridColumn.autoFitWidth(text: "Hello"),
        GridColumn.autoFitWidth(text: "World"),
      ],
      rows: [
        GridRow(children: [
          GridCell.autoFitWidth(text: "123.12", sortValue: 123.12),
          GridCell.autoFitWidth(text: "12", sortValue: 12),
        ])
      ],
    );
  }
}

```
