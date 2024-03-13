library weekly_tab_view;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:weekly_tab_view/weekly_tab_controller.dart';

import 'weekly_tab_calendar.dart';
import 'weekly_tab_paginator.dart';

class WeeklyTabView extends StatefulWidget {
  final WeeklyTabController controller;
  final List<int> weekdays;
  final int weekCount;
  final Widget Function(BuildContext, DateTime) tabBuilder;
  final Widget Function(BuildContext, DateTime) pageBuilder;
  final ScrollPhysics? scrollPhysics;
  final Function(DateTime)? onTabScrolled;
  final Function(DateTime)? onTabChanged;
  final Function(DateTime)? onPageChanged;

  const WeeklyTabView({
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
  State<WeeklyTabView> createState() => _WeeklyTabViewState();
}

class _WeeklyTabViewState extends State<WeeklyTabView> with SingleTickerProviderStateMixin {
  late WeeklyTabController calendarController;
  late WeeklyTabController paginatorController;
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    widget.controller.setPosition(_calcSafeDate(widget.controller.position));
    widget.controller.addListener(_updatePosition);

    tabController = TabController(length: widget.weekdays.length, vsync: this);
    calendarController = WeeklyTabController(position: widget.controller.position);
    paginatorController = WeeklyTabController(position: widget.controller.position);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePosition);
    tabController.dispose();
    calendarController.dispose();
    paginatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeeklyTabCalendar(
          controller: calendarController,
          tabController: tabController,
          weekdays: widget.weekdays,
          weekCount: widget.weekCount,
          tabBuilder: widget.tabBuilder,
          onTabScrolled: widget.onTabScrolled,
          onTabChanged: (value) {
            paginatorController.animateTo(value);
            widget.controller.setPosition(value);
            widget.onTabChanged?.call(value);
          },
        ),
        Expanded(
          child: WeeklyTabPaginator(
            controller: paginatorController,
            tabController: tabController,
            weekdays: widget.weekdays,
            weekCount: widget.weekCount,
            pageBuilder: (context, date) => widget.pageBuilder(context, date),
            scrollPhysics: widget.scrollPhysics,
            onPageChanged: (value) {
              calendarController.animateTo(value);
              widget.controller.setPosition(value);
              widget.onPageChanged?.call(value);
            },
          ),
        ),
      ],
    );
  }

  void _updatePosition() {
    calendarController.animateTo(widget.controller.position);
    paginatorController.animateTo(widget.controller.position);
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
