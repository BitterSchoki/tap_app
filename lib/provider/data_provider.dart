import 'dart:io';
import 'dart:typed_data';

import 'package:bonsoir/bonsoir.dart';
import 'package:tap_app/utils/utils.dart';

import 'data_provider_error.dart';

class DataProvider {
  static const String serviceType = '_wonderful-pml._tcp';
  Socket? socket;

  BonsoirDiscovery discovery = BonsoirDiscovery(type: serviceType);

  Future<ResolvedBonsoirService?> startNetworkDiscovery(
    int timeOut, {
    int attempts = 1,
  }) async {
    ResolvedBonsoirService? resolvedBonsoirService;

    await discovery.ready;
    discovery.eventStream!.listen((event) async {
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
        print('Service found : ${event.service.toString()}');
        print('Service is resolved: ${event.isServiceResolved}');

        if (event.isServiceResolved) {
          resolvedBonsoirService = event.service as ResolvedBonsoirService;
        }
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
        print('Service lost : ${event.service.toString()}');
      }
    });

    await discovery.start();

    await discovery.stop();

    return resolvedBonsoirService;
  }

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
