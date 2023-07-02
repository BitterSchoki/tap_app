part of 'device_communication_receive_bloc.dart';

abstract class DeviceCommunicationReceiveState extends Equatable {
  const DeviceCommunicationReceiveState();

  @override
  List<Object> get props => [];
}

class DeviceCommunicationReceiveInitial
    extends DeviceCommunicationReceiveState {}

class DeviceCommunicationMessageReceivedSuccess
    extends DeviceCommunicationReceiveState {
  const DeviceCommunicationMessageReceivedSuccess({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
