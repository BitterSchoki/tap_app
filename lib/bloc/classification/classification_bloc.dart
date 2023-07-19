import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_app/utils/utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import '../../utils/enums/enums.dart';
import '../../utils/helpers/helpers.dart';
import '../device_communication_send/device_communication_send_bloc.dart';

part 'classification_event.dart';
part 'classification_state.dart';

class ClassificationBloc extends Bloc<ClassificationEvent, ClassificationState> {
  ClassificationBloc({
    required this.deviceCommunicationSendBloc,
  }) : super(ClassificationInitial()) {
    on<ClassificationEvent>((event, emit) {
      if (event is RecordedAccelerometer) {
        _recordedAccelerometer(event);
      } else if (event is RecordedGyroscope) {
        _recordedGyroscope(event);
      } else if (event is ClassificationStarted) {
        _classificationStarted(emit, event);
      } else if (event is ClassificationStopped) {
        interpreter!.close();
      }
    });
  }
  final DeviceCommunicationSendBloc deviceCommunicationSendBloc;

  tfl.Interpreter? interpreter;

  TapType tapType = TapType.hand;
  bool hasAccelerometerInput = false;
  bool hasGyroscopeInput = false;
  bool hasClassifiedTap = false;
  bool isDoubleTap = false;

  List<List<double>> _accelerometerData = List.filled(11, List.filled(3, 1));
  List<List<double>> _gyroscopeData = List.filled(11, List.filled(3, 1));

  void _recordedAccelerometer(RecordedAccelerometer event) {
    _accelerometerData = List.of(event.values);

    if (hasGyroscopeInput) {
      hasGyroscopeInput = false;
      _accelerometerData = List.of(event.values);
      _startClassification();
    } else {
      hasAccelerometerInput = true;
    }
  }

  void _recordedGyroscope(RecordedGyroscope event) {
    _gyroscopeData = List.of(event.values);

    if (hasAccelerometerInput) {
      hasAccelerometerInput = false;
      _startClassification();
    } else {
      hasGyroscopeInput = true;
    }
  }

  void _classificationStarted(Emitter<ClassificationState> emit, ClassificationStarted event) async {
    emit(ClassificationInterpreterSet());
    interpreter ??= event.interpreter;

    tapType = event.tapType;
  }

  void _startClassification() async {
    if (interpreter == null) {
      return;
    }

    final prePorcessedData = PreProcessHelper.preProcessData(
      accelerometerData: _accelerometerData,
      gyroscopeData: _gyroscopeData,
      tapType: tapType,
    );

    final input = [prePorcessedData];

    var output = List.filled(1, List.filled(1, 0.0));

    interpreter!.run(input, output);

    print('Classified: ${output.first.first}');

    if (output.first.first > 0.8 && !hasClassifiedTap) {
      _sendMessage();
      print("TAB");

      hasClassifiedTap = true;

      await Future.delayed(const Duration(milliseconds: 500), () {
        hasClassifiedTap = false;
      });
    }
  }

  void _sendMessage() {
    deviceCommunicationSendBloc.add(
      const DeviceCommunicationSendMessage(message: "1"),
    );
  }

  @override
  Future<void> close() {
    interpreter!.close();
    return super.close();
  }
}
