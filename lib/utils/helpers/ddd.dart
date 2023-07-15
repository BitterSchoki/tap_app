import 'dart:math';

import 'package:tuple/tuple.dart';

void main() {
  final List<List<double>> test = [
    [0.38245655, 0.54401388, 0.03829054, 0.26689879, 0.77474957, 0.75104454],
    [0.47360491, 0.19483745, 0.24362794, 0.73467354, 0.63789722, 0.05145357],
    [0.20240105, 0.18439384, 0.74650874, 0.90979715, 0.83648555, 0.24797369],
    [0.91231075, 0.06130391, 0.88367261, 0.51753667, 0.88244709, 0.8739335],
    [0.95792566, 0.60517941, 0.62199365, 0.27404345, 0.19579978, 0.81860813],
    [0.47916398, 0.87943012, 0.29344077, 0.70458335, 0.12090002, 0.73710192],
    [0.86373401, 0.22681141, 0.17054701, 0.99438974, 0.90792385, 0.21921241],
    [0.40204963, 0.29631963, 0.01875745, 0.1930143, 0.46867772, 0.19787289],
    [0.07974664, 0.06424073, 0.43139057, 0.33735896, 0.3794432, 0.252358],
    [0.26125725, 0.1315732, 0.69919202, 0.60777452, 0.67914935, 0.96531423],
    [0.08779844, 0.211816, 0.09005717, 0.88423742, 0.44379957, 0.15310476]
  ];

  final smoothedData = smoothData(test);

  //print(smoothedData);

  final normalizedData = normalizeData(smoothedData);

  print(normalizedData);
}

class DataFrame {
  List<String> columns;
  List<List<double>> data;

  DataFrame(this.columns, this.data);

  DataFrame copy() {
    final copiedData = List<List<double>>.from(data.map((row) => List<double>.from(row)));
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
    final selectedData =
        List<List<double>>.generate(data.length, (_) => List<double>.filled(selectedColumns.length, 0));

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
    final rows = data.map((row) => row.map((value) => value.toStringAsFixed(6)).toList()).toList();
    final maxLengths = List<int>.from(columns.map((column) => max(column.length, 6)));
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

DataFrame smoothData(List<List<double>> array) {
  const windowSize = 5;

  final columns = ['X_acc', 'Y_acc', 'Z_acc', 'X_gyro', 'Y_gyro', 'Z_gyro'];
  final data = DataFrame(columns, array);
  final smoothedData = data.copy();

  for (final column in columns) {
    final columnData = data.getColumn(column);
    final smoothedColumnData = List<double>.filled(columnData.length, 0);

    for (int i = 0; i < columnData.length; i++) {
      final startIndex = max(0, i - windowSize ~/ 2);
      final endIndex = min(i + windowSize ~/ 2 + 1, columnData.length);
      final window = columnData.sublist(startIndex, endIndex);
      final mean = window.reduce((a, b) => a + b) / window.length.toDouble();
      smoothedColumnData[i] = mean;
    }

    smoothedData.setColumn(column, smoothedColumnData);
  }

  return smoothedData;
}

List<List<double>> normalizeData(DataFrame df) {
  final accelerometerColumns = ['X_acc', 'Y_acc', 'Z_acc'];
  final gyroscopeColumns = ['X_gyro', 'Y_gyro', 'Z_gyro'];

  final sensorData = df;

  final accelerometerData = sensorData.selectColumns(accelerometerColumns);
  final normalizedAccelerometer = accelerometerData.copy();
  for (final column in accelerometerColumns) {
    final columnData = accelerometerData.getColumn(column);
    final mean = columnData.reduce((a, b) => a + b) / columnData.length.toDouble();
    final stdDev =
        sqrt(columnData.map((value) => pow(value - mean, 2)).reduce((a, b) => a + b) / columnData.length.toDouble());
    final normalizedColumnData = columnData.map((value) => (value - mean) / stdDev).toList();
    normalizedAccelerometer.setColumn(column, normalizedColumnData);
  }

  final gyroscopeData = sensorData.selectColumns(gyroscopeColumns);
  final normalizedGyroscope = gyroscopeData.copy();
  for (final column in gyroscopeColumns) {
    final columnData = gyroscopeData.getColumn(column);
    final mean = columnData.reduce((a, b) => a + b) / columnData.length.toDouble();
    final stdDev =
        sqrt(columnData.map((value) => pow(value - mean, 2)).reduce((a, b) => a + b) / columnData.length.toDouble());
    final normalizedColumnData = columnData.map((value) => (value - mean) / stdDev).toList();
    normalizedGyroscope.setColumn(column, normalizedColumnData);
  }

  final normalizedAccelerometerResetIndex = normalizedAccelerometer.resetIndex(drop: true);
  final normalizedGyroscopeResetIndex = normalizedGyroscope.resetIndex(drop: true);

  return mergeData(normalizedAccelerometerResetIndex.data, normalizedGyroscopeResetIndex.data);
}

List<List<double>> mergeData(
  List<List<double>> accelerometerData,
  List<List<double>> gyroscopeData,
) {
  return List.generate(
    accelerometerData.length,
    (index) => List<double>.from(
      Tuple2(accelerometerData[index], gyroscopeData[index]).toList().expand((x) => x),
    ),
  );
}
