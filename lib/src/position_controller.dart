import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'date_time_extension.dart';

class PositionController extends ChangeNotifier {
  final List<int> weekdays;
  DateTime position;
  DateTime? previous;

  PositionController({
    required this.position,
    required this.weekdays,
  });

  bool get isWeekChanged => previous != null && !position.isSameWeek(previous!);

  void animateTo(DateTime date) {
    setPosition(calcSafeDate(date, weekdays));
    notifyListeners();
  }

  void setPosition(DateTime date, {double? offset}) {
    previous = position;
    position = date;
  }

  static DateTime calcSafeDate(DateTime date, List<int> weekdays) {
    int min = weekdays.reduce(math.min);
    int max = weekdays.reduce(math.max);
    int day = date.weekday;

    if (day < min) {
      return date.add(Duration(days: min - day));
    } else if (day > max) {
      return date.add(Duration(days: min - day + 7));
    } else if (!weekdays.contains(day)) {
      int next = weekdays.where((e) => e > day).first;
      return date.add(Duration(days: next - day));
    }
    return date;
  }
}
