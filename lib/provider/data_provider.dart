import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_nsd/flutter_nsd.dart';
import 'package:tap_app/utils/utils.dart';

import 'data_provider_error.dart';

class DataProvider {
  final flutterNsd = FlutterNsd();
  final services = <NsdServiceInfo>[];

  Socket? socket;

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
        services.add(service);
      },
      onError: (e) async {
        await flutterNsd.stopDiscovery();
      },
    );
  }

  Future connectToDevice({
    required NsdServiceInfo serviceInfo,
    required Duration timeout,
    required Function messageReceivedCallback,
    required Function disconnectCallback,
  }) async {
    final hostname = serviceInfo.hostname;
    final port = serviceInfo.port;
    if (hostname == null) {
      throw InvalidHostnamError();
    }
    if (port == null) {
      throw InvalidPortError();
    }

    socket = await Socket.connect(hostname, port, timeout: timeout);

    _startListeningForData(
      messageReceivedCallback: messageReceivedCallback,
      disconnectCallback: disconnectCallback,
    );
  }

  void _startListeningForData({
    required Function messageReceivedCallback,
    required Function disconnectCallback,
  }) {
    if (socket != null) {
      socket!.listen(
        (Uint8List data) {
          final message = String.fromCharCodes(data);
          messageReceivedCallback(message);
        },
        onError: (error) {
          disconnectCallback();
          socket!.destroy();
        },
        onDone: () {
          disconnectCallback();
          socket!.destroy();
        },
      );
    }
  }

  void sendMessage(DeviceActionType actionType) async {
    if (socket != null) {
      socket!.write(actionType);
    }
  }
}
