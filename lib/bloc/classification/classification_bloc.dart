import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

part 'classification_event.dart';
part 'classification_state.dart';

class ClassificationBloc
    extends Bloc<ClassificationEvent, ClassificationState> {
  ClassificationBloc() : super(ClassificationInitial()) {
    on<ClassificationEvent>((event, emit) {
      if (event is RecordedAccelerometer) {
        print(event.values);
      } else if (event is RecordedGyroscope) {
        print(event.values);
      } else if (event is ClassificationStarted) {
        _classificationStarted(emit, event);
      } else if (event is ClassificationStopped) {
        _classificationStopped(emit);
      }
    });
  }

  tfl.Interpreter? interpreter;
  final List<List<double>> _data = List.filled(11, List.filled(10, 0));

  bool hasAccelerometerInput = false;
  bool hasGyroscopeInput = false;

  void _recordedAccelerometer(RecordedAccelerometer event) {
    if (hasGyroscopeInput) {
      hasGyroscopeInput = false;
      final data = event.values;
      _startClassification();
    } else {
      hasAccelerometerInput = true;
    }
  }

  void _recordedGyroscope(RecordedGyroscope event) {
      if (hasAccelerometerInput) {
      hasAccelerometerInput = false;
      final data = event.values;
      _startClassification();
    } else {
      hasGyroscopeInput = true;
    }
  }

  void _classificationStarted(
      Emitter<ClassificationState> emit, ClassificationStarted event) {
    emit(ClassificationInterpreterSet());
    interpreter = event.interpreter;
  }

  void _classificationStopped(Emitter<ClassificationState> emit) {
    emit(ClassificationInitial());
  }

  void _startClassification() {
    final List<List<double>> data = List.from(_data);
    final input = _preProcessData(data);

    var output = List.filled(1, List.filled(1, double));

    interpreter.run(input, output);

    print('Classified: ${output.toString()}');

    interpreter.close();
  }

  List<List<double>> _preProcessData(List<List<double>> data) {
    final smoothed = smoothData(data, 5);
    final normalized = normalizeData(smoothed, false);

    for (int i = 0; i < normalized.length; i++) {
      final nor = normalized[i];
      normalized[i].add(calculateMean([nor[0], nor[1], nor[2]]));
      normalized[i].add(calculateStandardDeviation([nor[0], nor[1], nor[2]]));
      normalized[i].add(calculateMean([nor[3], nor[4], nor[5]]));
      normalized[i].add(calculateStandardDeviation([nor[3], nor[4], nor[5]]));
    }
    print('(${normalized.length},${normalized[0].length})');
    print(normalized[0]);
    return normalized;
  }

  double calculateMean(List<double> numbers) {
    double sum = numbers.reduce((value, element) => value + element);
    double mean = sum / numbers.length;
    return mean;
  }

  double calculateStandardDeviation(List<double> numbers) {
    double mean = calculateMean(numbers);
    double sumOfSquaredDifferences =
        numbers.fold(0, (value, element) => value + pow(element - mean, 2));
    double variance = sumOfSquaredDifferences / numbers.length;
    double standardDeviation = sqrt(variance);
    return standardDeviation;
  }

  List<List<double>> normalizeData(List<List<double>> data, bool labeled) {
    // Extract the sensor data columns
    List<List<double>> accelerometerData = [];
    List<List<double>> gyroscopeData = [];

    for (List<double> row in data) {
      accelerometerData.add([row[0], row[1], row[2]]);
      gyroscopeData.add([row[3], row[4], row[5]]);
    }

    // Normalize the accelerometer data
    List<List<double>> normalizedAccelerometer =
        normalizeColumns(accelerometerData);

    // Normalize the gyroscope data
    List<List<double>> normalizedGyroscope = normalizeColumns(gyroscopeData);

    // Combine the normalized sensor data with the non-normalized columns
    List<List<double>> normalizedData = [];
    for (int i = 0; i < data.length; i++) {
      List<double> row = [data[i][0]];
      row.addAll(normalizedAccelerometer[i]);

      row.addAll(normalizedGyroscope[i]);
      if (labeled) {
        row.add(data[i][9]);
      }
      normalizedData.add(row);
    }

    return normalizedData;
  }

  List<double> calculateColumnMean(List<List<double>> data) {
    List<double> mean = List.filled(data[0].length, 0.0);

    for (List<double> row in data) {
      for (int i = 0; i < row.length; i++) {
        mean[i] += row[i];
      }
    }

    mean = mean.map((value) => value / data.length).toList();
    return mean;
  }

  List<double> calculateColumnStandardDeviation(
      List<List<double>> data, List<double> mean) {
    List<double> std = List.filled(data[0].length, 0.0);

    for (List<double> row in data) {
      for (int i = 0; i < row.length; i++) {
        std[i] += pow(row[i] - mean[i], 2);
      }
    }

    std = std.map((value) => sqrt(value / data.length)).toList();
    return std;
  }

  List<List<double>> normalizeColumns(List<List<double>> data) {
    List<double> mean = calculateColumnMean(data);
    List<double> std = calculateColumnStandardDeviation(data, mean);

    List<List<double>> normalizedData = [];
    for (List<double> row in data) {
      List<double> normalizedRow = [];
      for (int i = 0; i < row.length; i++) {
        double normalizedValue = (row[i] - mean[i]) / std[i];
        normalizedRow.add(normalizedValue);
      }
      normalizedData.add(normalizedRow);
    }

    return normalizedData;
  }

  List<List<double>> smoothData(List<List<double>> data, int windowSize) {
    List<List<double>> smoothedData = List.from(data);

    for (int k = 0; k < 11; k++) {
      List<double> columnData = [];
      for (List<double> row in smoothedData) {
        columnData.add(row[k]);
      }

      List<double> smoothedColumnData = [];

      for (int i = 0; i < columnData.length; i++) {
        double sum = 0.0;
        int count = 0;

        for (int j = i - windowSize ~/ 2; j <= i + windowSize ~/ 2; j++) {
          if (j >= 0 && j < columnData.length) {
            sum += columnData[j];
            count++;
          }
        }

        double smoothedValue = sum / count;
        smoothedColumnData.add(smoothedValue);
      }

      for (int i = 0; i < smoothedData.length; i++) {
        smoothedData[i][k] = smoothedColumnData[i];
      }
    }

    return smoothedData;
  }
}
