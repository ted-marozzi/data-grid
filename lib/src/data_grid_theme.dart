import 'package:flutter/material.dart';

class DataGridThemeData {
  /// Settings for sorting icons
  final SortingIconSettings sortingIconSettings;

  /// An optional decoration when a row is highlighted
  /// Defaults to splash color
  final BoxDecoration? rowHighlightDecoration;

  /// An optional decoration when a row is selected
  /// Defaults to primary color
  final BoxDecoration? rowSelectedDecoration;

  const DataGridThemeData({
    /// Settings for sorting icons
    this.sortingIconSettings = const SortingIconSettings(),

    /// An optional decoration when a row is highlighted
    /// Defaults to splash color
    this.rowHighlightDecoration,

    /// An optional decoration when a row is selected
    /// Defaults to primary color
    this.rowSelectedDecoration,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DataGridThemeData &&
        runtimeType == other.runtimeType &&
        sortingIconSettings == other.sortingIconSettings &&
        rowHighlightDecoration == other.rowHighlightDecoration &&
        rowSelectedDecoration == other.rowSelectedDecoration;
  }

  @override
  int get hashCode => Object.hash(
        sortingIconSettings,
        rowHighlightDecoration,
        rowSelectedDecoration,
      );
}

class SortingIconSettings {
  final IconData ascending;
  final IconData descending;
  final double size;
  final Color? color;
  final EdgeInsets padding;

  const SortingIconSettings({
    this.ascending = Icons.arrow_upward_rounded,
    this.descending = Icons.arrow_downward_rounded,
    this.size = 20,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SortingIconSettings &&
        other.ascending == ascending &&
        other.descending == descending &&
        other.size == size &&
        other.color == color &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(
        ascending,
        descending,
        size,
        color,
        padding,
      );
}
