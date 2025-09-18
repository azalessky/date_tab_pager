import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_tab_bar.dart';
import 'monthly_adapter.dart';
import 'position_controller.dart';
import 'sync_controller.dart';

class MonthlyTabBar extends PeriodTabBar {
  const MonthlyTabBar._({
    required super.controller,
    required super.sync,
    required super.adapter,
    required super.tabBuilder,
    required super.height,
    super.onTabScrolled,
    super.onTabChanged,
    super.key,
  });

  factory MonthlyTabBar({
    required PositionController controller,
    required SyncController sync,
    double height = 48.0,
    required TabBuilder tabBuilder,
    DateTimeCallback? onTabScrolled,
    DateTimeCallback? onTabChanged,
    Key? key,
  }) =>
      MonthlyTabBar._(
        controller: controller,
        sync: sync,
        tabBuilder: tabBuilder,
        adapter: MonthlyAdapter(weekdays: controller.weekdays),
        height: height,
        onTabScrolled: onTabScrolled,
        onTabChanged: onTabChanged,
        key: key,
      );
}
