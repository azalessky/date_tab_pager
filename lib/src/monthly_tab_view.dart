import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_tab_view.dart';
import 'monthly_adapter.dart';
import 'position_controller.dart';
import 'sync_controller.dart';

class MonthlyTabView extends StatelessWidget {
  final PositionController controller;
  final SyncController sync;
  final List<int> weekdays;
  final PageBuilder pageBuilder;
  final DateTimeCallback? onPageChanged;

  const MonthlyTabView({
    required this.controller,
    required this.sync,
    required this.weekdays,
    required this.pageBuilder,
    this.onPageChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PeriodTabView(
      controller: controller,
      sync: sync,
      adapter: MonthlyAdapter(weekdays: weekdays),
      pageBuilder: pageBuilder,
      onPageChanged: onPageChanged,
    );
  }
}
