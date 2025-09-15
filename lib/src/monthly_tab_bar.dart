import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_tab_bar.dart';
import 'monthly_adapter.dart';
import 'position_controller.dart';

class MonthlyTabBar extends StatelessWidget {
  final PositionController controller;
  final List<int> weekdays;
  final TabBuilder tabBuilder;
  final DateTimeCallback? onTabScrolled;
  final DateTimeCallback? onTabChanged;

  const MonthlyTabBar({
    required this.controller,
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
      adapter: MonthlyAdapter(weekdays: weekdays),
      tabBuilder: tabBuilder,
      onTabScrolled: onTabScrolled,
      onTabChanged: onTabChanged,
    );
  }
}
