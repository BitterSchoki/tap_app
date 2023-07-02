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
      final serviceInfos = await dataProvider.startNetworkDiscovery(5000);
      await dataProvider.connectToDevice(
        serviceInfo: serviceInfos.first,
        messageReceivedCallback: _messageReceived,
      );

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
