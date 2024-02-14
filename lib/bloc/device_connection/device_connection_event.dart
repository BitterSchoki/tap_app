part of 'device_connection_bloc.dart';

@immutable
abstract class DeviceConnectionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeviceConnectionStarted extends DeviceConnectionEvent {}

class DeviceDisconnectionStarted extends DeviceConnectionEvent {}

class IPAdressSet extends DeviceConnectionEvent {
  final String ip;
  IPAdressSet({
    required this.ip,
  });
}
