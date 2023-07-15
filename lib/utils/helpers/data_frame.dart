import 'dart:math';

class DataFrame {
  List<String> columns;
  List<List<double>> data;

  DataFrame(this.columns, this.data);

  DataFrame copy() {
    final copiedData =
        List<List<double>>.from(data.map((row) => List<double>.from(row)));
    return DataFrame(columns, copiedData);
  }

  List<double> getColumn(String column) {
    final columnIndex = columns.indexOf(column);
    if (columnIndex != -1) {
      return data.map((row) => row[columnIndex]).toList();
    }
    return [];
  }

  void setColumn(String column, List<double> values) {
    final columnIndex = columns.indexOf(column);
    if (columnIndex != -1) {
      for (int i = 0; i < values.length; i++) {
        data[i][columnIndex] = values[i];
      }
    }
  }

  void addColumn(String column, List<double> values) {
    columns.add(column);
    for (int i = 0; i < values.length; i++) {
      data[i].add(values[i]);
    }
  }

  DataFrame resetIndex({bool drop = false}) {
    final newIndex = List<int>.generate(data.length, (i) => i);
    if (drop) {
      columns.removeAt(0);
    } else {
      columns.insert(0, 'index');
      for (int i = 0; i < data.length; i++) {
        data[i].insert(0, newIndex[i].toDouble());
      }
    }
    return this;
  }

  DataFrame selectColumns(List<String> selectedColumns) {
    final selectedData = List<List<double>>.generate(
        data.length, (_) => List<double>.filled(selectedColumns.length, 0));

    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < selectedColumns.length; j++) {
        final columnIndex = columns.indexOf(selectedColumns[j]);
        selectedData[i][j] = data[i][columnIndex];
      }
    }

    return DataFrame(selectedColumns, selectedData);
  }

  @override
  String toString() {
    final rows = data
        .map((row) => row.map((value) => value.toStringAsFixed(6)).toList())
        .toList();
    final maxLengths =
        List<int>.from(columns.map((column) => max(column.length, 6)));
    for (final row in rows) {
      for (int i = 0; i < row.length; i++) {
        maxLengths[i] = max(maxLengths[i], row[i].length);
      }
    }

    final buffer = StringBuffer();
    for (int i = 0; i < columns.length; i++) {
      final value = columns[i].padRight(maxLengths[i]);
      buffer.write('$value ');
    }
    buffer.writeln();

    for (final row in rows) {
      for (int i = 0; i < row.length; i++) {
        final value = row[i].padRight(maxLengths[i]);
        buffer.write('$value ');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}
