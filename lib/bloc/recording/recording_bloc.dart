import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart' as spl;

import '../classification/classification_bloc.dart';

part 'recording_event.dart';
part 'recording_state.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  RecordingBloc({
    required this.classificationBloc,
  }) : super(RecordingInitial()) {
    on<RecordingEvent>((event, emit) {
      if (event is RecordingStarted) {
        _recordingStarted(emit);
      } else if (event is RecordingStopped) {
        _recordingStopped(emit);
      }
    });
  }

  void _recordingStopped(Emitter<RecordingState> emitter) {
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    emitter(RecordingInitial());
  }

  final ClassificationBloc classificationBloc;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  void _recordingStarted(Emitter<RecordingState> emitter) {
    emitter(RecordingInProgress());
    _initSensorStreamSubscriptions(emitter);
  }

  void _initSensorStreamSubscriptions(Emitter<RecordingState> emitter) {
    int ia = 0;
    final List<List<double>> accelerometerData = [[]];

    _streamSubscriptions.add(
      spl.accelerometerEvents.listen(
        (spl.AccelerometerEvent event) {
          accelerometerData[ia][0] = event.x;
          accelerometerData[ia][1] = event.y;
          accelerometerData[ia][2] = event.z;

          ia++;

          if (ia > 10) {
            ia = 0;
            classificationBloc.add(
              RecordedAccelerometer(values: accelerometerData),
            );
          }
        },
        onError: (e) {
          emitter(RecordingFailure());
        },
        cancelOnError: true,
      ),
    );

    int ig = 0;
    final List<List<double>> gyroscopeData = [[]];

    _streamSubscriptions.add(
      spl.gyroscopeEvents.listen(
        (spl.GyroscopeEvent event) {
          gyroscopeData[ig][0] = event.x;
          gyroscopeData[ig][1] = event.y;
          gyroscopeData[ig][2] = event.z;

          ig++;

          if (ig > 10) {
            ig = 0;
            classificationBloc.add(
              RecordedGyroscope(values: gyroscopeData),
            );
          }
        },
        onError: (e) {
          emitter(RecordingFailure());
        },
        cancelOnError: true,
      ),
    );
  }
}
