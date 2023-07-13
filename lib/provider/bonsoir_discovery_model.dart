import 'dart:async';

import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';

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
