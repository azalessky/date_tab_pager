import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_tab_bar.dart';
import 'monthly_adapter.dart';
import 'position_controller.dart';
import 'sync_controller.dart';

class MonthlyTabBar extends StatelessWidget {
  static const widgetHeight = 48.0;

  final PositionController controller;
  final SyncController sync;
  final List<int> weekdays;
  final TabBuilder tabBuilder;
  final DateTimeCallback? onTabScrolled;
  final DateTimeCallback? onTabChanged;

  const MonthlyTabBar({
    required this.controller,
    required this.sync,
    required this.weekdays,
    required this.tabBuilder,
    this.onTabScrolled,
    this.onTabChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PeriodTabBar(
      controller: controller,
      sync: sync,
      adapter: MonthlyAdapter(weekdays: weekdays),
      height: widgetHeight,
      tabBuilder: tabBuilder,
      onTabScrolled: onTabScrolled,
      onTabChanged: onTabChanged,
    );
  }
}
