import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart' as spl;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

part 'classification_event.dart';
part 'classification_state.dart';

class ClassificationBloc extends Bloc<ClassificationEvent, ClassificationState> {
  ClassificationBloc() : super(ClassificationInitial()) {
    on<ClassificationEvent>((event, emit) {
      if (event is ClassificationStarted) {
        _classificationStarted(emit, event);
      } else if (event is ClassificationStopped) {
        _classificationStopped(emit);
      }
    });
  }

  List<double>? _userAccelerometerValues;
  List<List<double>>? _userAccelerometerDataWindow;

  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  bool isClassifying = false;

  void _classificationStarted(Emitter<ClassificationState> emit, ClassificationStarted event) {
    emit(ClassificationHappening());
    isClassifying = true;
    _initSensorStreamSubscriptions();
    _startClassification(event.interpreter);
  }

  void _classificationStopped(Emitter<ClassificationState> emit) {
    for (var element in _streamSubscriptions) {
      element.cancel();
    }
    isClassifying = false;
    emit(ClassificationInitial());
  }

  void _initSensorStreamSubscriptions() {
    // _streamSubscriptions.add(
    //   spl.userAccelerometerEvents.listen(
    //     (spl.UserAccelerometerEvent event) {
    //       _userAccelerometerValues = <double>[event.x, event.y, event.z];

    //     },
    //     onError: (e) {},
    //     cancelOnError: true,
    //   ),
    // );
    _streamSubscriptions.add(
      spl.accelerometerEvents.listen(
        (spl.AccelerometerEvent event) {
          final accelerometerValues = <double>[event.x, event.y, event.z];
          print('${DateTime.now()} , $accelerometerValues');
        },
        onError: (e) {},
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      spl.gyroscopeEvents.listen(
        (spl.GyroscopeEvent event) {
          final gyroscopeValues = <double>[event.x, event.y, event.z];
          print('${DateTime.now()} , $gyroscopeValues');
        },
        onError: (e) {},
        cancelOnError: true,
      ),
    );
  }

  void _startClassification(tfl.Interpreter interpreter) {
    while (isClassifying) {
      final data = [_userAccelerometerValues];
      final preProcessedData = _preProcessData();
      final input = preProcessedData;

      var output = List.filled(1, List.filled(1, double));

      interpreter.run(input, output);

      print('Classified: ${output.toString()}');
    }
    interpreter.close();
  }

  List<List<double>?> _preProcessData() {
    return [
      _userAccelerometerValues,
      _accelerometerValues,
      _gyroscopeValues,
    ];
  }

  List<List<double>> normalizeData(List<List<double>> data, bool labeled, bool both) {
    // Extract the sensor data columns
    List<List<double>> accelerometerData = [];
    List<List<double>> gyroscopeData = [];

    for (List<double> row in data) {
      accelerometerData.add([row[0], row[1], row[2]]);
      gyroscopeData.add([row[3], row[4], row[5]]);
    }

    // Normalize the accelerometer data
    List<List<double>> normalizedAccelerometer = normalizeColumns(accelerometerData);

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

  List<double> calculateColumnStandardDeviation(List<List<double>> data, List<double> mean) {
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
}
