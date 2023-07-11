import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

part 'companion_event.dart';
part 'companion_state.dart';

class CompanionBloc extends Bloc<CompanionEvent, CompanionState> {
  CompanionBloc() : super(CompanionInitial()) {
    on<CompanionEvent>((event, emit) async {
      if (event is CompanionCheckStarted) {
        emit(CompanionInProgress());

        final prefs = await SharedPreferences.getInstance();

        final companion = prefs.getBool('onboarding');

        if (companion == null) {
          emit(ShowCompanionSuccess());
          await prefs.setBool('onboarding', true);
        } else {
          emit(DontShowCompanionSuccess());
        }
      }
    });
  }
}
