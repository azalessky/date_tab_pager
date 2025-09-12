import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'date_time_extension.dart';

class WeeklyTabController extends PositionController {
  final DateTime initialDate;
  final List<int> weekdays;
  final int weekCount;

  late final TabController _tabController;
  late final PositionController _tabBarController;
  late final PositionController _tabViewController;

  WeeklyTabController({
    required this.initialDate,
    required this.weekdays,
    required this.weekCount,
    required TickerProvider vsync,
  }) : super(position: calcSafeDate(initialDate, weekdays)) {
    _tabController = TabController(length: weekdays.length, vsync: vsync);
    _tabBarController = PositionController(position: position);
    _tabViewController = PositionController(position: position);
  }

  TabController get tabController => _tabController;
  PositionController get tabBarController => _tabBarController;
  PositionController get tabViewController => _tabViewController;

  @override
  void dispose() {
    _tabController.dispose();
    _tabBarController.dispose();
    _tabViewController.dispose();
    super.dispose();
  }

  @override
  void animateTo(DateTime date) {
    super.animateTo(date);
    _tabBarController.animateTo(position);
    _tabViewController.animateTo(position);
  }

  @override
  void setPosition(DateTime date) {
    super.setPosition(calcSafeDate(date, weekdays));
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

class PositionController extends ChangeNotifier {
  DateTime position;
  DateTime? previous;

  PositionController({required this.position});

  bool get isWeekChanged => previous != null && !position.isSameWeek(previous!);

  void animateTo(DateTime date) {
    setPosition(date);
    notifyListeners();
  }

  void setPosition(DateTime date) {
    previous = position;
    position = date;
  }
}
