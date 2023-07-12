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
  const DeviceCommunicationMessageReceivedSuccess({required this.messages});

  final List<String> messages;

  @override
  List<Object> get props => [messages];
}
