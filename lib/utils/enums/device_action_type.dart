enum DeviceActionType {
  next,
  previous,
}

extension ParseToString on DeviceActionType {
  String toShortString() {
    return toString().split('.').last;
  }
}
