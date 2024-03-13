import 'package:flutter/material.dart';

import 'date_time_extension.dart';

class WeeklyTabController extends ChangeNotifier {
  DateTime position;
  DateTime previous;

  WeeklyTabController({
    required this.position,
  }) : previous = position;

  bool get isWeekChanged => !position.isSameWeek(previous);

  void animateTo(DateTime value) {
    setPosition(value);
    notifyListeners();
  }

  void setPosition(DateTime value) {
    previous = position;
    position = value;
  }
}
