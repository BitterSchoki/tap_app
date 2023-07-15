import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_app/utils/utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import '../../utils/helpers/helpers.dart';
import '../device_communication_send/device_communication_send_bloc.dart';

part 'classification_event.dart';
part 'classification_state.dart';

class ClassificationBloc
    extends Bloc<ClassificationEvent, ClassificationState> {
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
      }
    });
  }
  final DeviceCommunicationSendBloc deviceCommunicationSendBloc;

  tfl.Interpreter? interpreter;

  bool hasAccelerometerInput = false;
  bool hasGyroscopeInput = false;

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

  void _classificationStarted(
      Emitter<ClassificationState> emit, ClassificationStarted event) async {
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

    final List<List<List<double>>> data = [
      [
        [
          0.38245655,
          0.54401388,
          0.03829054,
          0.26689879,
          0.77474957,
          0.75104454
        ],
        [
          0.47360491,
          0.19483745,
          0.24362794,
          0.73467354,
          0.63789722,
          0.05145357
        ],
        [
          0.20240105,
          0.18439384,
          0.74650874,
          0.90979715,
          0.83648555,
          0.24797369
        ],
        [0.91231075, 0.06130391, 0.88367261, 0.51753667, 0.88244709, 0.8739335],
        [
          0.95792566,
          0.60517941,
          0.62199365,
          0.27404345,
          0.19579978,
          0.81860813
        ],
        [
          0.47916398,
          0.87943012,
          0.29344077,
          0.70458335,
          0.12090002,
          0.73710192
        ],
        [
          0.86373401,
          0.22681141,
          0.17054701,
          0.99438974,
          0.90792385,
          0.21921241
        ],
        [0.40204963, 0.29631963, 0.01875745, 0.1930143, 0.46867772, 0.19787289],
        [0.07974664, 0.06424073, 0.43139057, 0.33735896, 0.3794432, 0.252358],
        [0.26125725, 0.1315732, 0.69919202, 0.60777452, 0.67914935, 0.96531423],
        [0.08779844, 0.211816, 0.09005717, 0.88423742, 0.44379957, 0.15310476],
      ]
    ];

    final List<List<double>> data2 = [
      [
        0.38245655,
        0.54401388,
        0.03829054,
        0.26689879,
        0.77474957,
        0.75104454,
        0.47360491,
        0.19483745,
        0.24362794,
        0.73467354
      ],
      [
        0.63789722,
        0.05145357,
        0.20240105,
        0.18439384,
        0.74650874,
        0.90979715,
        0.83648555,
        0.24797369,
        0.91231075,
        0.06130391
      ],
      [
        0.88367261,
        0.51753667,
        0.88244709,
        0.8739335,
        0.95792566,
        0.60517941,
        0.62199365,
        0.27404345,
        0.19579978,
        0.81860813
      ],
      [
        0.47916398,
        0.87943012,
        0.29344077,
        0.70458335,
        0.12090002,
        0.73710192,
        0.86373401,
        0.22681141,
        0.17054701,
        0.99438974
      ],
      [
        0.90792385,
        0.21921241,
        0.40204963,
        0.29631963,
        0.01875745,
        0.1930143,
        0.46867772,
        0.19787289,
        0.07974664,
        0.06424073
      ],
      [
        0.43139057,
        0.33735896,
        0.3794432,
        0.252358,
        0.26125725,
        0.1315732,
        0.69919202,
        0.60777452,
        0.67914935,
        0.96531423
      ],
      [
        0.08779844,
        0.211816,
        0.09005717,
        0.88423742,
        0.44379957,
        0.15310476,
        0.68798093,
        0.8722462,
        0.96157426,
        0.28574223
      ],
      [
        0.85740791,
        0.60161074,
        0.16255508,
        0.36419686,
        0.15417566,
        0.50780204,
        0.16928311,
        0.40458345,
        0.66263839,
        0.24113211
      ],
      [
        0.70175311,
        0.6212874,
        0.50463026,
        0.22084384,
        0.13743663,
        0.1057465,
        0.25121241,
        0.04713532,
        0.23413995,
        0.54698223
      ],
      [
        0.26732111,
        0.82142252,
        0.34508041,
        0.26428777,
        0.22564092,
        0.4883339,
        0.88320923,
        0.74880162,
        0.1930813,
        0.31417142
      ],
      [
        0.57041721,
        0.24636429,
        0.94419239,
        0.87156191,
        0.62747652,
        0.22801471,
        0.57168285,
        0.69477293,
        0.23841879,
        0.51251565
      ]
    ];

    var output = List.filled(1, List.filled(1, 0));

    interpreter!.run(data, output);

    print('Classified: ${output.toString()}');

    //depending on the output, call _sendMessage
    if (true) {
      _sendMessage();
    }
  }

  void _sendMessage() {
    deviceCommunicationSendBloc.add(
      const DeviceCommunicationSendMessage(actionType: DeviceActionType.next),
    );
  }

  @override
  Future<void> close() {
    interpreter!.close();
    return super.close();
  }
}
