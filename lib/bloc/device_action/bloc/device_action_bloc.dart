import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../utils/utils.dart';

part 'device_action_event.dart';
part 'device_action_state.dart';

class DeviceActionBloc extends Bloc<DeviceActionEvent, DeviceActionState> {
  DeviceActionBloc() : super(DeviceActionInitial()) {
    on<DeviceActionStarted>((event, emit) async {
      await _deviceActionStarted(event, emit);
    });
  }

  Future<void> _deviceActionStarted(
      DeviceActionStarted event, Emitter<DeviceActionState> emitter) async {
    final actionType = event.actionType;

    emitter(DeviceActionInProgress(actionType: actionType));

    try {
      //TODO: Implement real action call
      await Future<void>.delayed(const Duration(seconds: 1));

      emitter(DeviceActionSuccess(actionType: actionType));
    } catch (error) {
      emitter(DeviceActionFailure(actionType: actionType));
    }
  }
}
