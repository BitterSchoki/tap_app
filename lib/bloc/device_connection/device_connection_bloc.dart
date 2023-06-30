import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

part 'device_connection_event.dart';
part 'device_connection_state.dart';

class DeviceConnectionBloc
    extends Bloc<DeviceConnectionEvent, DeviceConnectionState> {
  DeviceConnectionBloc() : super(DeviceConnectionInitial()) {
    on<DeviceConnectionStarted>((event, emit) async {
      await _deviceConnectionStarted(emit);
    });
  }

  TcpSocketConnection? socketConnection;

  void messageReceived() {
    //TODO: message receiving
  }

  Future<void> _deviceConnectionStarted(
      Emitter<DeviceConnectionState> emitter) async {
    emitter(DeviceConnectionInProgress());

    //TODO: network discovery implement

    const ip = "192.168.1.113";
    const port = 43534;

    socketConnection = TcpSocketConnection(ip, port);

    socketConnection!.enableConsolePrint(true);

    try {
      final canConnect = await socketConnection!.canConnect(5000, attempts: 3);

      if (canConnect) {
        await socketConnection!.connect(5000, messageReceived, attempts: 3);
        socketConnection!.isConnected();
      } else {
        throw Error();
      }

      emitter(DeviceConnectionSuccess());
    } catch (error) {
      emitter(DeviceConnectionFailure());
    }
  }

  void sendMessage(String message) {
    if (socketConnection!.isConnected()) {
      socketConnection!.sendMessage(message);
    } else {
      //throw NoConnectionError();
    }
  }
}
