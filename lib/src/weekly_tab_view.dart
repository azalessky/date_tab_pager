import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_tab_view.dart';
import 'weekly_adapter.dart';
import 'position_controller.dart';
import 'sync_controller.dart';

class WeeklyTabView extends PeriodTabView {
  const WeeklyTabView._({
    required super.controller,
    required super.sync,
    required super.adapter,
    required super.pageBuilder,
    super.onPageChanged,
    super.key,
  });

  factory WeeklyTabView({
    required PositionController controller,
    required SyncController sync,
    required PageBuilder pageBuilder,
    DateTimeCallback? onPageChanged,
    Key? key,
  }) =>
      WeeklyTabView._(
        controller: controller,
        sync: sync,
        pageBuilder: pageBuilder,
        adapter: WeeklyAdapter(weekdays: controller.weekdays),
        onPageChanged: onPageChanged,
        key: key,
      );
}
