import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'weekly_tab_controller.dart';
import 'weekly_tab_bar.dart';
import 'weekly_tab_view.dart';

class WeeklyTabNavigator extends StatefulWidget {
  final WeeklyTabController controller;
  final List<int> weekdays;
  final int weekCount;
  final Widget Function(BuildContext context, DateTime date) tabBuilder;
  final Widget Function(BuildContext context, DateTime date) pageBuilder;
  final ScrollPhysics? scrollPhysics;
  final Function(DateTime date)? onTabScrolled;
  final Function(DateTime date)? onTabChanged;
  final Function(DateTime date)? onPageChanged;

  const WeeklyTabNavigator({
    required this.controller,
    required this.weekdays,
    required this.weekCount,
    required this.tabBuilder,
    required this.pageBuilder,
    this.scrollPhysics,
    this.onTabScrolled,
    this.onTabChanged,
    this.onPageChanged,
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
  late WeeklyTabController tabBarController;
  late WeeklyTabController tabViewController;
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    final pos = widget.controller.position;

    tabController = TabController(length: widget.weekdays.length, vsync: this);
    tabBarController = WeeklyTabController(position: pos);
    tabViewController = WeeklyTabController(position: pos);

    widget.controller.addListener(_updatePosition);
    widget.controller.animateTo(pos);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePosition);
    tabController.dispose();
    tabBarController.dispose();
    tabViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeeklyTabBar(
          controller: tabBarController,
          tabController: tabController,
          weekdays: widget.weekdays,
          weekCount: widget.weekCount,
          tabBuilder: widget.tabBuilder,
          onTabScrolled: widget.onTabScrolled,
          onTabChanged: (value) {
            tabViewController.animateTo(value);
            widget.controller.setPosition(value);
            widget.onTabChanged?.call(value);
          },
        ),
        Expanded(
          child: WeeklyTabView(
            controller: tabViewController,
            tabController: tabController,
            weekdays: widget.weekdays,
            weekCount: widget.weekCount,
            pageBuilder: (context, date) => widget.pageBuilder(context, date),
            scrollPhysics: widget.scrollPhysics,
            onPageChanged: (value) {
              tabBarController.animateTo(value);
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
    tabBarController.animateTo(position);
    tabViewController.animateTo(position);
  }
}
