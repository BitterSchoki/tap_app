import 'dart:math';

import 'package:tap_app/utils/utils.dart';
import 'package:tuple/tuple.dart';

import 'data_frame.dart';

class PreProcessHelper {
  static const _columns = ['X_acc', 'Y_acc', 'Z_acc', 'X_gyro', 'Y_gyro', 'Z_gyro'];

  static List<List<double>> preProcessData({
    required List<List<double>> accelerometerData,
    required List<List<double>> gyroscopeData,
    required TapType tapType,
  }) {
    final meanStd = getMeanStd(tapType);
    final mergedData = mergeData(accelerometerData, gyroscopeData);
    final smoothedData = smoothData(mergedData, meanStd);
    final normalizedData = normalizeData(smoothedData, meanStd);

    return normalizedData;
  }

  static List<List<double>> mergeData(
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

  static DataFrame smoothData(List<List<double>> array, DataFrame meanStd) {
    const windowSize = 5;

    final data = DataFrame(_columns, array);
    final smoothedData = data.copy();

    for (final column in _columns) {
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

  static List<List<double>> normalizeData(DataFrame df, DataFrame meanStd) {
    final accelerometerColumns = ['X_acc', 'Y_acc', 'Z_acc'];
    final gyroscopeColumns = ['X_gyro', 'Y_gyro', 'Z_gyro'];

    final sensorData = df;

    final accelerometerData = sensorData.selectColumns(accelerometerColumns);
    final normalizedAccelerometer = accelerometerData.copy();
    final accelerometerMeanStd = meanStd.selectColumns(accelerometerColumns);
    for (final column in accelerometerColumns) {
      final columnData = accelerometerData.getColumn(column);
      final mean = accelerometerMeanStd.getColumn(column).first;
      final stdDev = accelerometerMeanStd.getColumn(column)[1];
      final mean2 = columnData.reduce((a, b) => a + b) / columnData.length.toDouble();
      final stdDev2 =
          sqrt(columnData.map((value) => pow(value - mean2, 2)).reduce((a, b) => a + b) / columnData.length.toDouble());
      final normalizedColumnData = columnData.map((value) => (value - mean) / stdDev).toList();
      normalizedAccelerometer.setColumn(column, normalizedColumnData);
    }

    final gyroscopeData = sensorData.selectColumns(gyroscopeColumns);
    final normalizedGyroscope = gyroscopeData.copy();
    final gyroscopeMeanStd = meanStd.selectColumns(gyroscopeColumns);

    for (final column in gyroscopeColumns) {
      final columnData = gyroscopeData.getColumn(column);
      final mean = gyroscopeMeanStd.getColumn(column).first;
      final stdDev = gyroscopeMeanStd.getColumn(column)[1];
      //final mean = columnData.reduce((a, b) => a + b) / columnData.length.toDouble();
      //final stdDev = sqrt(columnData.map((value) => pow(value - mean, 2)).reduce((a, b) => a + b) / columnData.length.toDouble());
      final normalizedColumnData = columnData.map((value) => (value - mean) / stdDev).toList();
      normalizedGyroscope.setColumn(column, normalizedColumnData);
    }

    final normalizedAccelerometerResetIndex = normalizedAccelerometer.resetIndex(drop: true);
    final normalizedGyroscopeResetIndex = normalizedGyroscope.resetIndex(drop: true);

    return mergeData(normalizedAccelerometerResetIndex.data, normalizedGyroscopeResetIndex.data);
  }

  static DataFrame getMeanStd(TapType tapType) {
    switch (tapType) {
      case TapType.table:
        final data = [
          [
            -0.020217225267179496,
            -0.03870577078830254,
            -9.778396841499942,
            9.156649911282858e-05,
            -0.00012756180270734126,
            0.00019155926441321984
          ],
          [
            0.10490450193061293,
            0.1526082321744609,
            0.04410767323443176,
            0.00438234516962088,
            0.010900056233460867,
            0.028143047612405426
          ],
        ];
        return DataFrame(_columns, data);

      case TapType.hand:
        final data = [
          [
            5.553724486047594,
            1.5485913419105821,
            1.5811578432006292,
            0.10055436893785556,
            -0.019078226064074336,
            0.03686792612554372
          ],
          [
            3.395914690232077,
            4.89863930519786,
            5.1843604390301765,
            0.5107528985208833,
            0.30984763374795365,
            0.17465375887898793
          ]
        ];
        return DataFrame(_columns, data);
      case TapType.pocket:
      default:
        final data = [
          [
            2.1650233844407243,
            -7.659952457503043,
            -0.9537686969027767,
            -0.0010997522196154587,
            0.009851779230803989,
            0.0020721126028826016
          ],
          [
            4.1619047334595765,
            3.6587003461363348,
            1.3282862122484813,
            0.11877803805854546,
            0.2088491236667819,
            0.06076382194327156
          ],
        ];
        return DataFrame(_columns, data);
    }
  }
}
