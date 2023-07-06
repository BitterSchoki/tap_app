import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  PermissionsBloc() : super(PermissionsInitial()) {
    on<PermissionsEvent>((event, emit) async {
      if (event is PermissionRequestStarted) {
        _permissionRequestStarted(emit);
      }
    });
  }
  void _permissionRequestStarted(Emitter<PermissionsState> emitter) async {
    emitter(PermissionsInProgress());
  }
}
