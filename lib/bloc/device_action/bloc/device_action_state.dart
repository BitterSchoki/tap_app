part of 'device_action_bloc.dart';

abstract class DeviceActionState extends Equatable {
  const DeviceActionState();

  @override
  List<Object> get props => [];
}

class DeviceActionInitial extends DeviceActionState {}

class DeviceActionInProgress extends DeviceActionState {
  const DeviceActionInProgress({required this.actionType});

  final DeviceActionType actionType;

  @override
  List<Object> get props => [actionType];
}

class DeviceActionSuccess extends DeviceActionState {
  const DeviceActionSuccess({required this.actionType});

  final DeviceActionType actionType;

  @override
  List<Object> get props => [actionType];
}

class DeviceActionFailure extends DeviceActionState {
  const DeviceActionFailure({required this.actionType});

  final DeviceActionType actionType;

  @override
  List<Object> get props => [actionType];
}
