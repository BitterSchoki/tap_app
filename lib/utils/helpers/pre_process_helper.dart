import 'dart:math';

import 'package:tuple/tuple.dart';

import 'data_frame.dart';

class PreProcessHelper {
  static List<List<double>> preProcessData({
    required List<List<double>> accelerometerData,
    required List<List<double>> gyroscopeData,
  }) {
    final mergedData = mergeData(accelerometerData, gyroscopeData);
    final smoothedData = smoothData(mergedData);
    final normalizedData = normalizeData(smoothedData);

    return normalizedData;
  }

  static List<List<double>> mergeData(
    List<List<double>> accelerometerData,
    List<List<double>> gyroscopeData,
  ) {
    return List.generate(
      accelerometerData.length,
      (index) => List<double>.from(
        Tuple2(accelerometerData[index], gyroscopeData[index])
            .toList()
            .expand((x) => x),
      ),
    );
  }

  static DataFrame smoothData(List<List<double>> array) {
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

  static List<List<double>> normalizeData(DataFrame df) {
    final accelerometerColumns = ['X_acc', 'Y_acc', 'Z_acc'];
    final gyroscopeColumns = ['X_gyro', 'Y_gyro', 'Z_gyro'];

    final sensorData = df;

    final accelerometerData = sensorData.selectColumns(accelerometerColumns);
    final normalizedAccelerometer = accelerometerData.copy();
    for (final column in accelerometerColumns) {
      final columnData = accelerometerData.getColumn(column);
      final mean =
          columnData.reduce((a, b) => a + b) / columnData.length.toDouble();
      final stdDev = sqrt(columnData
              .map((value) => pow(value - mean, 2))
              .reduce((a, b) => a + b) /
          columnData.length.toDouble());
      final normalizedColumnData =
          columnData.map((value) => (value - mean) / stdDev).toList();
      normalizedAccelerometer.setColumn(column, normalizedColumnData);
    }

    final gyroscopeData = sensorData.selectColumns(gyroscopeColumns);
    final normalizedGyroscope = gyroscopeData.copy();
    for (final column in gyroscopeColumns) {
      final columnData = gyroscopeData.getColumn(column);
      final mean =
          columnData.reduce((a, b) => a + b) / columnData.length.toDouble();
      final stdDev = sqrt(columnData
              .map((value) => pow(value - mean, 2))
              .reduce((a, b) => a + b) /
          columnData.length.toDouble());
      final normalizedColumnData =
          columnData.map((value) => (value - mean) / stdDev).toList();
      normalizedGyroscope.setColumn(column, normalizedColumnData);
    }

    final normalizedAccelerometerResetIndex =
        normalizedAccelerometer.resetIndex(drop: true);
    final normalizedGyroscopeResetIndex =
        normalizedGyroscope.resetIndex(drop: true);

    return mergeData(normalizedAccelerometerResetIndex.data,
        normalizedGyroscopeResetIndex.data);
  }
}
