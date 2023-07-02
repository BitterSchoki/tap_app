import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tap_app/provider/data_provider.dart';
import '../../../utils/utils.dart';

part 'device_communication_send_event.dart';
part 'device_communication_send_state.dart';

class DeviceCommunicationSendBloc
    extends Bloc<DeviceCommunicationSendEvent, DeviceCommunicationSendState> {
  DeviceCommunicationSendBloc({required this.dataProvider})
      : super(DeviceActionInitial()) {
    on<DeviceCommunicationSendMessage>((event, emit) async {
      await _deviceCommunicationSendMessage(event, emit);
    });
  }

  final DataProvider dataProvider;

  Future<void> _deviceCommunicationSendMessage(
      DeviceCommunicationSendMessage event,
      Emitter<DeviceCommunicationSendState> emitter) async {
    final actionType = event.actionType;

    emitter(DeviceCommunicationSendInProgress(actionType: actionType));

    try {
      dataProvider.sendMessage(actionType.toShortString());

      emitter(DeviceCommunicationSendMessageSuccess(actionType: actionType));
    } catch (error) {
      emitter(DeviceCommunicationSendMessageFailure(actionType: actionType));
    }
  }
}