import 'sync_notifiers.dart';

/// Synchronizes positions and offsets between tab bar and tab view.
/// Holds [barPosition], [viewPosition], and [viewOffset] notifiers to allow
/// reactive updates when the tab bar or tab view changes.
class SyncController {
  /// The current date position of the tab bar.
  final VoidNotifier barPosition;

  /// The current date position of the tab view.
  final VoidNotifier viewPosition;

  /// The current scroll offset of the tab view.
  final AlwaysNotifier<double> viewOffset;

  /// Creates a [SyncController] with initial values.
  SyncController()
      : barPosition = VoidNotifier(),
        viewPosition = VoidNotifier(),
        viewOffset = AlwaysNotifier(0);

  /// Disposes all internal notifiers.
  void dispose() {
    barPosition.dispose();
    viewPosition.dispose();
    viewOffset.dispose();
  }
}
