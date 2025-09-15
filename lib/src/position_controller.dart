import 'package:flutter/material.dart';

import 'date_time_extension.dart';

class PositionController extends ChangeNotifier {
  final List<int> _weekdays;
  DateTime _position;
  DateTime? _previous;

  PositionController({
    required DateTime position,
    required List<int> weekdays,
  })  : _weekdays = weekdays,
        _position = position.safeDate(weekdays);

  DateTime get position => _position;
  bool get isWeekChanged => _previous != null && !_position.isSameWeek(_previous!);

  void animateTo(DateTime date) {
    setPosition(date.safeDate(_weekdays));
    notifyListeners();
  }

  void setPosition(DateTime date) {
    _previous = _position;
    _position = date;
  }
}
