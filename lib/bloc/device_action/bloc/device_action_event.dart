part of 'device_action_bloc.dart';

abstract class DeviceActionEvent extends Equatable {
  const DeviceActionEvent();

  @override
  List<Object> get props => [];
}

class DeviceActionStarted extends DeviceActionEvent {
  const DeviceActionStarted({required this.actionType});

  final DeviceActionType actionType;

  @override
  List<Object> get props => [actionType];
}
