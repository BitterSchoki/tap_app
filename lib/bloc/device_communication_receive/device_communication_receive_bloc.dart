import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'device_communication_receive_event.dart';
part 'device_communication_receive_state.dart';

class DeviceCommunicationReceiveBloc extends Bloc<
    DeviceCommunicationReceiveEvent, DeviceCommunicationReceiveState> {
  DeviceCommunicationReceiveBloc()
      : super(DeviceCommunicationReceiveInitial()) {
    on<DeviceCommunicationMessageReceived>((event, emit) {
      emit(DeviceCommunicationMessageReceivedSuccess(message: event.message));
    });
  }
}
