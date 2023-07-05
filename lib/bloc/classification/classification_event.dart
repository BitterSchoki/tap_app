part of 'classification_bloc.dart';

abstract class ClassificationEvent extends Equatable {
  const ClassificationEvent();

  @override
  List<Object> get props => [];
}

class ClassificationStarted extends ClassificationEvent {
  final tfl.Interpreter interpreter;
  const ClassificationStarted({
    required this.interpreter,
  });

  @override
  List<Object> get props => [interpreter];
}

class ClassificationStopped extends ClassificationEvent {}
