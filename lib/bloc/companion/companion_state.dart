part of 'companion_bloc.dart';

abstract class CompanionState extends Equatable {
  const CompanionState();

  @override
  List<Object> get props => [];
}

class CompanionInitial extends CompanionState {}

class CompanionInProgress extends CompanionState {}

class ShowCompanionSuccess extends CompanionState {}

class DontShowCompanionSuccess extends CompanionState {}
