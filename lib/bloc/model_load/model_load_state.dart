part of 'model_load_bloc.dart';

abstract class ModelLoadState extends Equatable {
  const ModelLoadState();

  @override
  List<Object> get props => [];
}

class ModelLoadInitial extends ModelLoadState {}

class ModelLoadInProgress extends ModelLoadState {}

class ModelLoadSuccess extends ModelLoadState {
  final tfl.Interpreter interpreter;
  const ModelLoadSuccess({
    required this.interpreter,
  });

  @override
  List<Object> get props => [interpreter];
}

class ModelLoadFailure extends ModelLoadState {}
