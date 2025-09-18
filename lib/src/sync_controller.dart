import 'package:flutter/material.dart';

class SyncController {
  final AlwaysNotifier<DateTime> barPosition;
  final AlwaysNotifier<DateTime> viewPosition;
  final AlwaysNotifier<double> viewOffset;

  SyncController()
      : barPosition = AlwaysNotifier(DateTime.now()),
        viewPosition = AlwaysNotifier(DateTime.now()),
        viewOffset = AlwaysNotifier(0);

  void dispose() {
    barPosition.dispose();
    viewPosition.dispose();
    viewOffset.dispose();
  }
}

class AlwaysNotifier<T> extends ValueNotifier<T> {
  AlwaysNotifier(super.value);

  @override
  set value(T value) {
    super.value = value;
    notifyListeners();
  }
}
