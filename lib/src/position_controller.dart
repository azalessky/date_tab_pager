import 'package:flutter/material.dart';
import 'date_time_extension.dart';

/// Controls the current date position for tab views and notifies listeners on changes.
/// Supports safe positioning according to the allowed weekdays and tracks
/// the previous position to detect week changes.
class PositionController extends ChangeNotifier {
  final List<int> _weekdays;
  final int _maxItems;

  DateTime _position;
  DateTime? _previous;

  /// Creates a [PositionController].
  /// [position] is the initial date position.
  /// [weekdays] defines the allowed weekdays (1 = Monday, 7 = Sunday).
  /// [maxItems] limits the number of visible items in the view.
  PositionController({
    required DateTime position,
    required List<int> weekdays,
    required int maxItems,
  })  : _weekdays = weekdays,
        _maxItems = maxItems,
        _position = position.safeDate(weekdays);

  /// The currently selected date position.
  DateTime get position => _position;

  /// List of allowed weekdays.
  List<int> get weekdays => _weekdays;

  /// Maximum number of items visible in the view.
  int get maxItems => _maxItems;

  /// True if the week has changed since the previous position.
  bool get isWeekChanged =>
      _previous != null && !_position.isSameWeek(_previous!);

  /// Animates to the specified [date] and notifies listeners.
  void animateTo(DateTime date) {
    setPosition(date.safeDate(_weekdays));
    notifyListeners();
  }

  /// Sets the current position to [date] without notifying listeners.
  void setPosition(DateTime date) {
    _previous = _position;
    _position = date;
  }
}
