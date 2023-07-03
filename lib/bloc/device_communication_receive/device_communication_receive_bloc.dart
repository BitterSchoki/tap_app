import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'device_communication_receive_event.dart';
part 'device_communication_receive_state.dart';

class DeviceCommunicationReceiveBloc extends Bloc<DeviceCommunicationReceiveEvent, DeviceCommunicationReceiveState> {
  DeviceCommunicationReceiveBloc() : super(DeviceCommunicationReceiveInitial()) {
    on<DeviceCommunicationMessageReceived>((event, emit) {
      emit(DeviceCommunicationMessageReceivedSuccess(message: event.message));
    });
  }
}
