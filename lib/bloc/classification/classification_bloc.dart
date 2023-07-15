import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import '../../utils/helpers/helpers.dart';

part 'classification_event.dart';
part 'classification_state.dart';

class ClassificationBloc extends Bloc<ClassificationEvent, ClassificationState> {
  ClassificationBloc() : super(ClassificationInitial()) {
    on<ClassificationEvent>((event, emit) {
      if (event is RecordedAccelerometer) {
        _recordedAccelerometer(event);
      } else if (event is RecordedGyroscope) {
        _recordedGyroscope(event);
      } else if (event is ClassificationStarted) {
        _classificationStarted(emit, event);
      }
    });
  }

  tfl.Interpreter? interpreter;

  bool hasAccelerometerInput = false;
  bool hasGyroscopeInput = false;

  List<List<double>> _accelerometerData = List.filled(11, List.filled(3, 0));
  List<List<double>> _gyroscopeData = List.filled(11, List.filled(3, 0));

  void _recordedAccelerometer(RecordedAccelerometer event) {
    if (hasGyroscopeInput) {
      hasGyroscopeInput = false;
      _accelerometerData = List.of(event.values);
      _startClassification();
    } else {
      hasAccelerometerInput = true;
    }
  }

  void _recordedGyroscope(RecordedGyroscope event) {
    if (hasAccelerometerInput) {
      hasAccelerometerInput = false;
      _gyroscopeData = List.of(event.values);
      _startClassification();
    } else {
      hasGyroscopeInput = true;
    }
  }

  void _classificationStarted(Emitter<ClassificationState> emit, ClassificationStarted event) async {
    emit(ClassificationInterpreterSet());
    interpreter = event.interpreter;
  }

  void _startClassification() async {
    if (state is! ClassificationInterpreterSet) {
      return;
    }

    final prePorcessedData = PreProcessHelper.preProcessData(
      accelerometerData: _accelerometerData,
      gyroscopeData: _gyroscopeData,
    );

    var output;

    interpreter!.run(prePorcessedData, output);
    interpreter!.close();

    print('Classified: ${output.toString()}');
  }
}
