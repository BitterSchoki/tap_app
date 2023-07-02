part of 'device_communication_receive_bloc.dart';

abstract class DeviceCommunicationReceiveEvent extends Equatable {
  const DeviceCommunicationReceiveEvent();

  @override
  List<Object> get props => [];
}

class DeviceCommunicationMessageReceived
    extends DeviceCommunicationReceiveEvent {
  const DeviceCommunicationMessageReceived({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
