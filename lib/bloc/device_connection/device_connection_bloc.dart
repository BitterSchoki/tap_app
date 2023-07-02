import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_nsd/flutter_nsd.dart';
import 'package:meta/meta.dart';
import '../../provider/data_provider.dart';

part 'device_connection_event.dart';
part 'device_connection_state.dart';

class DeviceConnectionBloc
    extends Bloc<DeviceConnectionEvent, DeviceConnectionState> {
  DeviceConnectionBloc({required this.dataProvider})
      : super(DeviceConnectionInitial()) {
    on<DeviceConnectionStarted>((event, emit) async {
      await _deviceConnectionStarted(emit);
    });
  }
  final DataProvider dataProvider;

  Future<void> _deviceConnectionStarted(
      Emitter<DeviceConnectionState> emitter) async {
    emitter(DeviceConnectionInProgress());

/*     final serviceInfo = await dataProvider.startDiscovery(5000);
    if (serviceInfo == null) {
      throw Error();
    } */

    final connectionSuccessfull = await dataProvider.connectToDevice(
      messageReceivedCallback: messageReceived,
    );

    if (connectionSuccessfull) {
      emitter(DeviceConnectionSuccess());
    } else {
      emitter(DeviceConnectionFailure());
    }
  }

  void messageReceived(String msg) {
    print(msg);
    //TODO: message receiving
  }

/*   void sendMessage(String message) {
    if (socketConnection!.isConnected()) {
      socketConnection!.sendMessage(message);
    } else {
      //throw NoConnectionError();
    }
  } */
}
