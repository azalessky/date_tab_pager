import 'package:flutter/material.dart';

import 'data_types.dart';
import 'period_tab_bar.dart';
import 'weekly_adapter.dart';
import 'position_controller.dart';
import 'sync_controller.dart';

/// A tab bar widget for displaying a weekly schedule.
/// Built on top of [PeriodTabBar] and uses [WeeklyAdapter] to render weeks.
class WeeklyTabBar extends PeriodTabBar {
  const WeeklyTabBar._({
    required super.controller,
    required super.sync,
    required super.adapter,
    required super.height,
    super.labelPadding,
    required super.tabBuilder,
    super.onTabScrolled,
    super.onTabChanged,
    super.key,
  });

  /// Creates a tab bar for a weekly schedule.
  factory WeeklyTabBar({
    /// Controls the current position and provides weekday information.
    required PositionController controller,

    /// Synchronizes the tab bar with external scrollable content.
    required SyncController sync,

    /// The height of the tab bar.
    required double height,

    /// Optional padding around the tab labels.
    EdgeInsets? labelPadding,

    /// Builds a widget for each tab (e.g. a week cell).
    required TabBuilder tabBuilder,

    /// Called when the tab bar is scrolled, passing the corresponding date.
    DateTimeCallback? onTabScrolled,

    /// Called when the active tab changes, passing the corresponding date.
    DateTimeCallback? onTabChanged,

    /// An optional key for this widget.
    Key? key,
  }) =>
      WeeklyTabBar._(
        controller: controller,
        sync: sync,
        tabBuilder: tabBuilder,
        adapter: WeeklyAdapter(weekdays: controller.weekdays),
        height: height,
        labelPadding: labelPadding,
        onTabScrolled: onTabScrolled,
        onTabChanged: onTabChanged,
        key: key,
      );
}
