import 'package:flutter/material.dart';

class SyncController {
  final ValueNotifier<DateTime> position;
  final ValueNotifier<double> offset;

  SyncController()
      : position = ValueNotifier(DateTime.now()),
        offset = ValueNotifier(0);

  void dispose() {
    position.dispose();
    offset.dispose();
  }
}
