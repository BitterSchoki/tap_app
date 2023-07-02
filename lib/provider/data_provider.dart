import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:flutter_nsd/flutter_nsd.dart';

class DataProvider {
  final flutterNsd = FlutterNsd();
  final services = <NsdServiceInfo>[];

  TcpSocketConnection? socketConnection;

  Future<List<NsdServiceInfo>> startNetworkDiscovery(
    int timeOut, {
    int attempts = 1,
  }) async {
    _startListeningForNetworks();

    await flutterNsd.discoverServices('_http._tcp.');

    await flutterNsd.stopDiscovery();
    return services;
  }

  void _startListeningForNetworks() {
    flutterNsd.stream.listen(
      (NsdServiceInfo service) {
        print(service);
        services.add(service);
      },
      onError: (e) async {
        if (e is NsdError) {
          if (e.errorCode == NsdErrorCode.startDiscoveryFailed ||
              e.errorCode == NsdErrorCode.stopDiscoveryFailed) {
            await flutterNsd.stopDiscovery();
          }
        }
      },
    );
  }

  Future<bool> connectToDevice({
    required NsdServiceInfo serviceInfo,
    required Function messageReceivedCallback,
  }) async {
    final hostname = serviceInfo.hostname;
    final port = serviceInfo.port;
    if (hostname == null) {
      return false;
    }
    if (port == null) {
      return false;
    }

    socketConnection = TcpSocketConnection("192.168.2.91", 12234);

    if (socketConnection == null) {
      return false;
    }

    socketConnection!.enableConsolePrint(true);

    final canConnect = await socketConnection!.canConnect(5000, attempts: 3);

    if (canConnect) {
      await socketConnection!
          .connect(5000, messageReceivedCallback, attempts: 3);
      if (socketConnection!.isConnected()) {
        return true;
      }
    }

    return false;
  }

  void sendMessage(String msg) async {
    if (socketConnection!.isConnected()) {
      socketConnection!.sendMessage(msg);
    } else {
      throw Error();
    }
  }
}
