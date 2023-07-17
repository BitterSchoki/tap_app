part of 'classification_bloc.dart';

abstract class ClassificationEvent extends Equatable {
  const ClassificationEvent();

  @override
  List<Object> get props => [];
}

class ClassificationStarted extends ClassificationEvent {
  final tfl.Interpreter interpreter;
  final TapType tapType;
  const ClassificationStarted({
    required this.interpreter,
    required this.tapType,
  });

  @override
  List<Object> get props => [interpreter, tapType];
}

class RecordedAccelerometer extends ClassificationEvent {
  const RecordedAccelerometer({required this.values});
  final List<List<double>> values;

  @override
  List<Object> get props => [values];
}

class RecordedGyroscope extends ClassificationEvent {
  const RecordedGyroscope({required this.values});
  final List<List<double>> values;

  @override
  List<Object> get props => [values];
}

class ClassificationStopped extends ClassificationEvent {}
