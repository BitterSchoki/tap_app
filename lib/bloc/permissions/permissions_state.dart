part of 'permissions_bloc.dart';

abstract class PermissionsState extends Equatable {
  const PermissionsState();

  @override
  List<Object> get props => [];
}

class PermissionsInitial extends PermissionsState {}

class PermissionsInProgress extends PermissionsState {}

class PermissionsNotAsked extends PermissionsState {}

class PermissionsAccepted extends PermissionsState {}

class PermissionsDenied extends PermissionsState {}
