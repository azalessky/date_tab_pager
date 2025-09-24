import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_tab_view.dart';
import 'weekly_adapter.dart';
import 'position_controller.dart';
import 'sync_controller.dart';

/// A page view widget for displaying a weekly schedule.
/// Built on top of [PeriodTabView] and uses [WeeklyAdapter] to render weeks.
class WeeklyTabView extends PeriodTabView {
  const WeeklyTabView._({
    required super.controller,
    required super.sync,
    required super.adapter,
    required super.pageBuilder,
    super.onPageChanged,
    super.key,
  });

  /// Creates a page view for a weekly schedule.
  factory WeeklyTabView({
    /// Controls the current position and provides weekday information.
    required PositionController controller,

    /// Synchronizes the page view with external tab bars or scrollable content.
    required SyncController sync,

    /// Builds a page widget for each week.
    required PageBuilder pageBuilder,

    /// Called when the visible page changes, passing the corresponding date.
    DateTimeCallback? onPageChanged,

    /// An optional key for this widget.
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
