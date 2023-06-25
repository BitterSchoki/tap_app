part of 'device_connection_bloc.dart';

@immutable
abstract class DeviceConnectionState {}

class DeviceConnectionInitial extends DeviceConnectionState {}

class DeviceConnectionInProgress extends DeviceConnectionState {}

class DeviceConnectionSuccess extends DeviceConnectionState {}

class DeviceConnectionFailure extends DeviceConnectionState {}
