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
}

class _WeeklyTabNavigatorState extends State<WeeklyTabNavigator>
    with SingleTickerProviderStateMixin {
  late WeeklyTabController tabBarController;
  late WeeklyTabController tabViewController;
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: widget.weekdays.length, vsync: this);
    tabBarController = WeeklyTabController(position: widget.controller.position);
    tabViewController = WeeklyTabController(position: widget.controller.position);

    widget.controller.addListener(_updatePosition);
    widget.controller.animateTo(widget.controller.position);
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
    final position = _calcSafeDate(widget.controller.position);
    widget.controller.setPosition(position);

    tabBarController.animateTo(position);
    tabViewController.animateTo(position);
  }

  DateTime _calcSafeDate(DateTime date) {
    int min = widget.weekdays.reduce(math.min);
    int max = widget.weekdays.reduce(math.max);
    int day = date.weekday;

    if (day < min) {
      return date.add(Duration(days: min - day));
    } else if (day > max) {
      date = date.add(Duration(days: min - day + 7));
    } else if (!widget.weekdays.contains(day)) {
      int next = widget.weekdays.where((e) => e > day).first;
      return date.add(Duration(days: next - day));
    }
    return date;
  }
}
