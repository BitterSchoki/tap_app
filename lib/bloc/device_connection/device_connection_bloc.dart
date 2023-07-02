import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../provider/data_provider.dart';
import '../device_communication_receive/device_communication_receive_bloc.dart';

part 'device_connection_event.dart';
part 'device_connection_state.dart';

class DeviceConnectionBloc
    extends Bloc<DeviceConnectionEvent, DeviceConnectionState> {
  DeviceConnectionBloc({
    required this.dataProvider,
    required this.deviceCommunicationReceiveBloc,
  }) : super(DeviceConnectionInitial()) {
    on<DeviceConnectionStarted>((event, emit) async {
      await _deviceConnectionStarted(emit);
    });
  }

  final DataProvider dataProvider;
  final DeviceCommunicationReceiveBloc deviceCommunicationReceiveBloc;

  Future<void> _deviceConnectionStarted(
      Emitter<DeviceConnectionState> emitter) async {
    emitter(DeviceConnectionInProgress());

    try {
      final socket = await Socket.connect("192.168.2.91", 12234);
      print('Yo nice ' + socket.remoteAddress.address);

      socket.listen(
        (Uint8List data) {
          final serverResponse = String.fromCharCodes(data);
          print("Client $serverResponse");
        },
        onError: (error) {
          print("Client: $error");
          socket.destroy();
      emitter(DeviceConnectionFailure());

        },
        onDone: () {
          print("Client: Server Left");
          socket.destroy();
      emitter(DeviceConnectionFailure());

        },
      );

      // final serviceInfos = await dataProvider.startNetworkDiscovery(5000);
      // await dataProvider.connectToDevice(
      //   serviceInfo: serviceInfos.first,
      //   messageReceivedCallback: _messageReceived,
      // );

      emitter(DeviceConnectionSuccess());
    } catch (e) {
      emitter(DeviceConnectionFailure());
    }
  }

  void _messageReceived(String msg) {
    deviceCommunicationReceiveBloc.add(
      DeviceCommunicationMessageReceived(message: msg),
    );
  }
}
