part of 'device_communication_send_bloc.dart';

abstract class DeviceCommunicationSendState extends Equatable {
  const DeviceCommunicationSendState();

  @override
  List<Object> get props => [];
}

class DeviceCommunicationSendInitial extends DeviceCommunicationSendState {}

class DeviceCommunicationSendInProgress extends DeviceCommunicationSendState {
  const DeviceCommunicationSendInProgress({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class DeviceCommunicationSendMessageSuccess extends DeviceCommunicationSendState {
  const DeviceCommunicationSendMessageSuccess({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class DeviceCommunicationSendMessageFailure extends DeviceCommunicationSendState {
  const DeviceCommunicationSendMessageFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
