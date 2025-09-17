import 'package:flutter/material.dart';

import 'period_tab_bar.dart';
import 'weekly_adapter.dart';
import 'position_controller.dart';
import 'sync_controller.dart';
import 'data_types.dart';

class WeeklyTabBar extends PeriodTabBar {
  const WeeklyTabBar._({
    required super.controller,
    required super.sync,
    required super.tabBuilder,
    required super.adapter,
    required super.height,
    super.onTabScrolled,
    super.onTabChanged,
    super.key,
  });

  factory WeeklyTabBar({
    required PositionController controller,
    required SyncController sync,
    double height = 70.0,
    required TabBuilder tabBuilder,
    DateTimeCallback? onTabScrolled,
    DateTimeCallback? onTabChanged,
    Key? key,
  }) =>
      WeeklyTabBar._(
        controller: controller,
        sync: sync,
        tabBuilder: tabBuilder,
        adapter: WeeklyAdapter(weekdays: controller.weekdays),
        height: height,
        onTabScrolled: onTabScrolled,
        onTabChanged: onTabChanged,
        key: key,
      );
}
