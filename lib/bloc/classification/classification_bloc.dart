import 'dart:async';

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
    isClassifying = false;
    emit(ClassificationInitial());
  }

  void _initSensorStreamSubscriptions() {
    _streamSubscriptions.add(
      spl.userAccelerometerEvents.listen(
        (spl.UserAccelerometerEvent event) {
          _userAccelerometerValues = <double>[event.x, event.y, event.z];
        },
        onError: (e) {},
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      spl.accelerometerEvents.listen(
        (spl.AccelerometerEvent event) {
          _accelerometerValues = <double>[event.x, event.y, event.z];
        },
        onError: (e) {},
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      spl.gyroscopeEvents.listen(
        (spl.GyroscopeEvent event) {
          _gyroscopeValues = <double>[event.x, event.y, event.z];
        },
        onError: (e) {},
        cancelOnError: true,
      ),
    );
  }

  void _startClassification(tfl.Interpreter interpreter) {
    while (isClassifying) {
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
}
