import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_tab_view.dart';
import 'position_controller.dart';
import 'sync_controller.dart';
import 'daily_adapter.dart';

class DailyTabView extends PeriodTabView {
  const DailyTabView._({
    required super.controller,
    required super.sync,
    required super.adapter,
    required super.pageBuilder,
    super.onPageChanged,
    super.key,
  });

  factory DailyTabView({
    required PositionController controller,
    required SyncController sync,
    required PageBuilder pageBuilder,
    DateTimeCallback? onPageChanged,
    Key? key,
  }) =>
      DailyTabView._(
        controller: controller,
        sync: sync,
        pageBuilder: pageBuilder,
        adapter: DailyAdapter(weekdays: controller.weekdays),
        onPageChanged: onPageChanged,
        key: key,
      );
}
