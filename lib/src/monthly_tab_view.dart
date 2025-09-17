import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_tab_view.dart';
import 'monthly_adapter.dart';
import 'position_controller.dart';
import 'sync_controller.dart';

class MonthlyTabView extends PeriodTabView {
  const MonthlyTabView._({
    required super.controller,
    required super.sync,
    required super.pageBuilder,
    required super.adapter,
    super.onPageChanged,
    super.key,
  });

  factory MonthlyTabView({
    required PositionController controller,
    required SyncController sync,
    required PageBuilder pageBuilder,
    DateTimeCallback? onPageChanged,
    Key? key,
  }) =>
      MonthlyTabView._(
        controller: controller,
        sync: sync,
        pageBuilder: pageBuilder,
        adapter: MonthlyAdapter(weekdays: controller.weekdays),
        onPageChanged: onPageChanged,
        key: key,
      );
}
