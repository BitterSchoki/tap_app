import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bonsoir/bonsoir.dart';

import 'data_provider_error.dart';

class DataProvider {
  static const String serviceType = '_tapapp._tcp';
  Socket? socket;

  Future<bool> connectToDevice({
    required ResolvedBonsoirService serviceInfo,
    required Duration timeout,
    required Function messageReceivedCallback,
    required Function disconnectCallback,
  }) async {
    final hostname = serviceInfo.ip;
    final port = serviceInfo.port;

    if (hostname == null) {
      throw InvalidHostnameError();
    }

    socket = await Socket.connect(hostname, port, timeout: timeout);

    _startListeningForData(
      messageReceivedCallback: messageReceivedCallback,
      disconnectCallback: disconnectCallback,
    );

    return true;
  }

  void disconnect() {
    if (socket != null) {
      socket!.close();
    }
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

  void sendMessage(String message) async {
    if (socket != null) {
      socket!.write(message);
    }
  }
}
