import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_tab_view.dart';
import 'position_controller.dart';
import 'sync_controller.dart';
import 'daily_adapter.dart';

/// A page view widget for displaying a daily schedule.
/// Built on top of [PeriodTabView] and uses [DailyAdapter] to render days.
class DailyTabView extends PeriodTabView {
  const DailyTabView._({
    required super.controller,
    required super.sync,
    required super.adapter,
    required super.pageBuilder,
    super.onPageChanged,
    super.key,
  });

  /// Creates a page view for a daily schedule.
  factory DailyTabView({
    /// Controls the current position and provides weekday information.
    required PositionController controller,

    /// Synchronizes the page view with external tab bars or scrollable content.
    required SyncController sync,

    /// Builds a page widget for each day.
    required PageBuilder pageBuilder,

    /// Called when the visible page changes, passing the corresponding date.
    DateTimeCallback? onPageChanged,

    /// An optional key for this widget.
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
