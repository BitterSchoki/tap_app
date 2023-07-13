import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:tuple/tuple.dart';

class PreProcessHelper {
  static const int windowSize = 3;

  static List<List<double>> preProcessData({
    required List<List<double>> accelerometerData,
    required List<List<double>> gyroscopeData,
  }) {
    final mergedData = _mergeData(
      accelerometerData: accelerometerData,
      gyroscopeData: gyroscopeData,
    );

    final dataFrame = DataFrame(
      mergedData,
      header: ['X_acc', 'Y_acc', 'Z_acc', 'X_gyro', 'Y_gyro', 'Z_gyro'],
    );

    // DataFrame calculateRollingMean(DataFrame data, int windowSize) {
    //   final List<Map<String, dynamic>> rows = data.toRows();

    //   for (final column in data.toColumns()) {
    //     final String columnName = column.header;
    //     final List<dynamic> values = column.series;

    //     final List<double> smoothedValues = calculateSingleColumnRollingMean(values.cast<double>(), windowSize);

    //     for (int i = 0; i < rows.length; i++) {
    //       rows[i][columnName] = smoothedValues[i];
    //     }
    //   }

    //   return DataFrame.fromRows(rows);
    // }

    // List<double> calculateSingleColumnRollingMean(List<double> values, int windowSize) {
    //   final List<double> smoothedValues = [];

    //   for (int i = 0; i < values.length; i++) {
    //     final int startIndex = (i - windowSize ~/ 2).clamp(0, values.length - windowSize);
    //     final int endIndex = startIndex + windowSize;
    //     final List<double> window = values.sublist(startIndex, endIndex);

    //     final double mean = window.reduce((a, b) => a + b) / windowSize;
    //     smoothedValues.add(mean);
    //   }

    //   return smoothedValues;
    // }

    return [[]];
  }

  static List<List<double>> _mergeData({
    required List<List<double>> accelerometerData,
    required List<List<double>> gyroscopeData,
  }) {
    return List.generate(
      accelerometerData.length,
      (index) => List<double>.from(
        Tuple2(accelerometerData[index], gyroscopeData[index]).toList().expand((x) => x),
      ),
    );
  }
}
