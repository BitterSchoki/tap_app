part of 'device_communication_send_bloc.dart';

abstract class DeviceCommunicationSendEvent extends Equatable {
  const DeviceCommunicationSendEvent();

  @override
  List<Object> get props => [];
}

class DeviceCommunicationSendMessage extends DeviceCommunicationSendEvent {
  const DeviceCommunicationSendMessage({required this.actionType});

  final DeviceActionType actionType;

  @override
  List<Object> get props => [actionType];
}
