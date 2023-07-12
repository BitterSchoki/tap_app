import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

import '../../utils/python/python.dart';

part 'model_load_event.dart';
part 'model_load_state.dart';

class ModelLoadBloc extends Bloc<ModelLoadEvent, ModelLoadState> {
  ModelLoadBloc() : super(ModelLoadInitial()) {
    on<ModelLoadEvent>((event, emit) async {
      if (event is ModelLoadStarted) {
        await _modelLoadStarted(emit);
      }
    });
  }

  static const String _modelAssetPath =
      'lib/assets/models/model_combined_g.tflite';

  static const String _pythonScriptPath = 'prepos_script.py';

  Future<void> _modelLoadStarted(Emitter<ModelLoadState> emitter) async {
    emitter(ModelLoadInProgress());

    try {
      final interpreter = await tfl.Interpreter.fromAsset(_modelAssetPath);

      final preProcessor = PreProcessor();

      await preProcessor.initialize("python", _pythonScriptPath, false);

      emitter(ModelLoadSuccess(
        interpreter: interpreter,
        preProcessor: preProcessor,
      ));
    } catch (e) {
      emitter(ModelLoadFailure());
    }
  }
}
