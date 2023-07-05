part of 'model_load_bloc.dart';

abstract class ModelLoadEvent extends Equatable {
  const ModelLoadEvent();

  @override
  List<Object> get props => [];
}

class ModelLoadStarted extends ModelLoadEvent {}
