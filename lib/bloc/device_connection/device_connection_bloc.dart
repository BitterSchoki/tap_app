import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'device_connection_event.dart';
part 'device_connection_state.dart';

class DeviceConnectionBloc
    extends Bloc<DeviceConnectionEvent, DeviceConnectionState> {
  DeviceConnectionBloc() : super(DeviceConnectionInitial()) {
    on<DeviceConnectionStarted>((event, emit) async {
      await _deviceConnectionStarted(emit);
    });
  }

  Future<void> _deviceConnectionStarted(
      Emitter<DeviceConnectionState> emitter) async {
    emitter(DeviceConnectionInProgress());

    try {
      //TODO: Implement real connection
      await Future<void>.delayed(const Duration(seconds: 2));

      emitter(DeviceConnectionSuccess());
    } catch (error) {
      emitter(DeviceConnectionFailure());
    }
  }
}
