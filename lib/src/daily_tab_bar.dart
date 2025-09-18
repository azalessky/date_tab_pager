import 'package:flutter/material.dart';

import 'period_tab_bar.dart';
import 'daily_adapter.dart';
import 'position_controller.dart';
import 'sync_controller.dart';
import 'data_types.dart';

class DailyTabBar extends PeriodTabBar {
  const DailyTabBar._({
    required super.controller,
    required super.sync,
    required super.adapter,
    required super.tabBuilder,
    required super.height,
    super.onTabScrolled,
    super.onTabChanged,
    super.key,
  });

  factory DailyTabBar({
    required PositionController controller,
    required SyncController sync,
    double height = 70.0,
    required TabBuilder tabBuilder,
    DateTimeCallback? onTabScrolled,
    DateTimeCallback? onTabChanged,
    Key? key,
  }) =>
      DailyTabBar._(
        controller: controller,
        sync: sync,
        tabBuilder: tabBuilder,
        adapter: DailyAdapter(weekdays: controller.weekdays),
        height: height,
        onTabScrolled: onTabScrolled,
        onTabChanged: onTabChanged,
        key: key,
      );
}
