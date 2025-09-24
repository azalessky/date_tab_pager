import 'package:flutter/material.dart';

import 'date_time_extension.dart';

class PositionController extends ChangeNotifier {
  final List<int> _weekdays;
  final int _maxItems;

  DateTime _position;
  DateTime? _previous;

  PositionController({
    required DateTime position,
    required List<int> weekdays,
    required int maxItems,
  })  : _weekdays = weekdays,
        _maxItems = maxItems,
        _position = position.safeDate(weekdays);

  DateTime get position => _position;
  List<int> get weekdays => _weekdays;
  int get maxItems => _maxItems;

  bool get isWeekChanged =>
      _previous != null && !_position.isSameWeek(_previous!);

  void animateTo(DateTime date) {
    setPosition(date.safeDate(_weekdays));
    notifyListeners();
  }

  void setPosition(DateTime date) {
    _previous = _position;
    _position = date;
  }
}
