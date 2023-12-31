import 'package:equatable/equatable.dart';

abstract class DataProviderError extends Equatable {
  @override
  List<Object?> get props => [];
}

class InvalidHostnameError extends DataProviderError {
  @override
  List<Object?> get props => [];
}

class InvalidPortError extends DataProviderError {
  @override
  List<Object?> get props => [];
}
