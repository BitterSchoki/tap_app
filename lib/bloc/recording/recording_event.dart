part of 'recording_bloc.dart';

abstract class RecordingEvent extends Equatable {
  const RecordingEvent();

  @override
  List<Object> get props => [];
}

class RecordingStarted extends RecordingEvent {}

class RecordingStopped extends RecordingEvent {}
