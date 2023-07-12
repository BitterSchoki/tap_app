import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:tap_app/utils/utils.dart';

import 'data_provider_error.dart';

class DataProvider {
  static const String serviceType = '_tapapp._tcp';
  Socket? socket;

  BonsoirDiscoveryModel startNetworkDiscovery(
    int timeOut, {
    int attempts = 1,
  }) {
    BonsoirDiscoveryModel model = BonsoirDiscoveryModel();
    model.start();
    return model;
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

  void sendMessage(DeviceActionType actionType) async {
    if (socket != null) {
      socket!.write(actionType);
    }
  }
}

class BonsoirDiscoveryModel extends ChangeNotifier {
  static const String serviceType = '_tapapp._tcp';

  /// The current Bonsoir discovery object instance.
  BonsoirDiscovery? _bonsoirDiscovery;

  /// Contains all discovered (and resolved) services.
  final List<ResolvedBonsoirService> _resolvedServices = [];

  /// The subscription object.
  StreamSubscription<BonsoirDiscoveryEvent>? _subscription;

  /// Returns all discovered (and resolved) services.
  List<ResolvedBonsoirService> get discoveredServices => List.of(_resolvedServices);

  /// Starts the Bonsoir discovery.
  Future<void> start() async {
    if (_bonsoirDiscovery == null || _bonsoirDiscovery!.isStopped) {
      _bonsoirDiscovery = BonsoirDiscovery(type: serviceType);
      await _bonsoirDiscovery!.ready;
    }

    _subscription = _bonsoirDiscovery!.eventStream!.listen(_onEventOccurred);
    await _bonsoirDiscovery!.start();
  }

  /// Stops the Bonsoir discovery.
  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _bonsoirDiscovery?.stop();
  }

  /// Triggered when a Bonsoir discovery event occurred.
  void _onEventOccurred(BonsoirDiscoveryEvent event) {
    if (event.service == null || !event.isServiceResolved) {
      return;
    }

    ResolvedBonsoirService service = event.service as ResolvedBonsoirService;
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      _resolvedServices.add(service);
      notifyListeners();
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceLost) {
      _resolvedServices.remove(service);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
