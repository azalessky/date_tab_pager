import 'package:flutter/material.dart';

/// Synchronizes positions and offsets between tab bar and tab view.
/// Holds [barPosition], [viewPosition], and [viewOffset] notifiers to allow
/// reactive updates when the tab bar or tab view changes.
class SyncController {
  /// The current date position of the tab bar.
  final AlwaysNotifier<DateTime> barPosition;

  /// The current date position of the tab view.
  final AlwaysNotifier<DateTime> viewPosition;

  /// The current scroll offset of the tab view.
  final AlwaysNotifier<double> viewOffset;

  /// Creates a [SyncController] with initial values.
  SyncController()
      : barPosition = AlwaysNotifier(DateTime.now()),
        viewPosition = AlwaysNotifier(DateTime.now()),
        viewOffset = AlwaysNotifier(0);

  /// Disposes all internal notifiers.
  void dispose() {
    barPosition.dispose();
    viewPosition.dispose();
    viewOffset.dispose();
  }
}

/// A [ValueNotifier] that always notifies listeners even if the new value equals the old one.
class AlwaysNotifier<T> extends ValueNotifier<T> {
  /// Creates an [AlwaysNotifier] with the given initial [value].
  AlwaysNotifier(super.value);

  @override
  set value(T value) {
    super.value = value;
    notifyListeners();
  }
}
