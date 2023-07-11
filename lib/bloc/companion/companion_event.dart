part of 'companion_bloc.dart';

abstract class CompanionEvent extends Equatable {
  const CompanionEvent();

  @override
  List<Object> get props => [];
}

class CompanionCheckStarted extends CompanionEvent {}
