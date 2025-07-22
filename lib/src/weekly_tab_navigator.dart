import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'weelky_tab_types.dart';
import 'weekly_tab_controller.dart';
import 'weekly_tab_bar.dart';
import 'weekly_tab_view.dart';

class WeeklyTabNavigator extends StatefulWidget {
  final WeeklyTabController controller;
  final List<int> weekdays;
  final int weekCount;
  final WeeklyTabBuilder tabBuilder;
  final WeeklyTabBuilder pageBuilder;
  final WeeklyTabCallback? onTabScrolled;
  final WeeklyTabCallback? onTabChanged;
  final WeeklyTabCallback? onPageChanged;
  final ScrollPhysics? scrollPhysics;

  const WeeklyTabNavigator({
    required this.controller,
    required this.weekdays,
    required this.weekCount,
    required this.tabBuilder,
    required this.pageBuilder,
    this.onTabScrolled,
    this.onTabChanged,
    this.onPageChanged,
    this.scrollPhysics,
    super.key,
  });

  @override
  State<WeeklyTabNavigator> createState() => _WeeklyTabNavigatorState();

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

class _WeeklyTabNavigatorState extends State<WeeklyTabNavigator>
    with SingleTickerProviderStateMixin {
  late WeeklyTabController _tabBarController;
  late WeeklyTabController _tabViewController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    final pos = widget.controller.position;

    _tabController = TabController(length: widget.weekdays.length, vsync: this);
    _tabBarController = WeeklyTabController(position: pos);
    _tabViewController = WeeklyTabController(position: pos);

    widget.controller.addListener(_updatePosition);
    widget.controller.animateTo(pos);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePosition);
    _tabController.dispose();
    _tabBarController.dispose();
    _tabViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeeklyTabBar(
          controller: _tabBarController,
          tabController: _tabController,
          weekdays: widget.weekdays,
          weekCount: widget.weekCount,
          tabBuilder: widget.tabBuilder,
          onTabScrolled: widget.onTabScrolled,
          onTabChanged: (value) {
            _tabViewController.animateTo(value);
            widget.controller.setPosition(value);
            widget.onTabChanged?.call(value);
          },
        ),
        Expanded(
          child: WeeklyTabView(
            controller: _tabViewController,
            tabController: _tabController,
            weekdays: widget.weekdays,
            weekCount: widget.weekCount,
            pageBuilder: widget.pageBuilder,
            scrollPhysics: widget.scrollPhysics,
            onPageChanged: (value) {
              _tabBarController.animateTo(value);
              widget.controller.setPosition(value);
              widget.onPageChanged?.call(value);
            },
          ),
        ),
      ],
    );
  }

  void _updatePosition() {
    final position = WeeklyTabNavigator.calcSafeDate(
      widget.controller.position,
      widget.weekdays,
    );
    widget.controller.setPosition(position);
    _tabBarController.animateTo(position);
    _tabViewController.animateTo(position);
  }
}
