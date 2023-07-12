import 'package:bonsoir/bonsoir.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../provider/data_provider.dart';
import '../device_communication_receive/device_communication_receive_bloc.dart';

part 'device_connection_event.dart';
part 'device_connection_state.dart';

class DeviceConnectionBloc extends Bloc<DeviceConnectionEvent, DeviceConnectionState> {
  DeviceConnectionBloc({
    required this.dataProvider,
    required this.deviceCommunicationReceiveBloc,
  }) : super(DeviceConnectionInitial()) {
    on<DeviceConnectionEvent>((event, emit) async {
      if (event is DeviceConnectionStarted) {
        await _deviceConnectionStarted(emit);
      } else if (event is DeviceDisconnectionStarted) {
        await _deviceDisconnctionStarted(emit);
      }
    });
  }

  final DataProvider dataProvider;
  final DeviceCommunicationReceiveBloc deviceCommunicationReceiveBloc;

  Future<void> _deviceConnectionStarted(Emitter<DeviceConnectionState> emitter) async {
    emitter(DeviceConnectionInProgress());

    try {
      final model = dataProvider.startNetworkDiscovery(5000);
      await Future.delayed(Duration(seconds: 2));
      final discoveredServices = model.discoveredServices;

      print(discoveredServices);

      if (discoveredServices.isEmpty) {
        const resolvedBonsoirService = ResolvedBonsoirService(
          ip: '10.163.181.31',
          port: 12345,
          name: 'tapApp2',
          type: '_tapapp2._tcp',
        );
        discoveredServices.add(resolvedBonsoirService);
      }

      final isConnected = await dataProvider.connectToDevice(
        serviceInfo: discoveredServices.first,
        timeout: const Duration(milliseconds: 10000),
        messageReceivedCallback: _onMessageReceived,
        disconnectCallback: _onDisconnected,
      );

      if (isConnected) {
        emitter(DeviceConnectionSuccess());
      } else {
        throw Error();
      }
    } catch (e) {
      emitter(DeviceConnectionFailure());
    }
  }

  Future<void> _deviceDisconnctionStarted(Emitter<DeviceConnectionState> emitter) async {
    dataProvider.disconnect();
    emitter(DeviceConnectionInitial());
  }

  void _onMessageReceived(String msg) {
    deviceCommunicationReceiveBloc.add(
      DeviceCommunicationMessageReceived(message: msg),
    );
  }

  void _onDisconnected() {
    add(DeviceDisconnectionStarted());
  }
}
