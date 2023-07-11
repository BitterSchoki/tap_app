part of 'classification_bloc.dart';

abstract class ClassificationState extends Equatable {
  const ClassificationState();

  @override
  List<Object> get props => [];
}

class ClassificationInitial extends ClassificationState {}

class ClassificationInterpreterSet extends ClassificationState {}

class ClassificationError extends ClassificationState {}
