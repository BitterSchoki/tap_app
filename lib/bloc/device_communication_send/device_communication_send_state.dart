part of 'device_communication_send_bloc.dart';

abstract class DeviceCommunicationSendState extends Equatable {
  const DeviceCommunicationSendState();

  @override
  List<Object> get props => [];
}

class DeviceActionInitial extends DeviceCommunicationSendState {}

class DeviceCommunicationSendInProgress extends DeviceCommunicationSendState {
  const DeviceCommunicationSendInProgress({required this.actionType});

  final DeviceActionType actionType;

  @override
  List<Object> get props => [actionType];
}

class DeviceCommunicationSendMessageSuccess
    extends DeviceCommunicationSendState {
  const DeviceCommunicationSendMessageSuccess({required this.actionType});

  final DeviceActionType actionType;

  @override
  List<Object> get props => [actionType];
}

class DeviceCommunicationSendMessageFailure
    extends DeviceCommunicationSendState {
  const DeviceCommunicationSendMessageFailure({required this.actionType});

  final DeviceActionType actionType;

  @override
  List<Object> get props => [actionType];
}
