import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_app/provider/data_provider.dart';

part 'device_communication_send_event.dart';
part 'device_communication_send_state.dart';

class DeviceCommunicationSendBloc extends Bloc<DeviceCommunicationSendEvent, DeviceCommunicationSendState> {
  DeviceCommunicationSendBloc({required this.dataProvider}) : super(DeviceCommunicationSendInitial()) {
    on<DeviceCommunicationSendMessage>((event, emit) async {
      await _deviceCommunicationSendMessage(event, emit);
    });
  }

  final DataProvider dataProvider;

  Future<void> _deviceCommunicationSendMessage(
      DeviceCommunicationSendMessage event, Emitter<DeviceCommunicationSendState> emitter) async {
    final message = event.message;

    emitter(DeviceCommunicationSendInProgress(message: message));

    try {
      dataProvider.sendMessage(message);

      emitter(DeviceCommunicationSendMessageSuccess(message: message));
    } catch (error) {
      emitter(DeviceCommunicationSendMessageFailure(message: message));
    }
  }
}
