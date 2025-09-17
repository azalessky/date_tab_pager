import 'period_tab_bar.dart';
import 'weekly_adapter.dart';

class WeeklyTabBar extends PeriodTabBar {
  WeeklyTabBar({
    required super.controller,
    required super.sync,
    required List<int> weekdays,
    super.height = 70.0,
    required super.tabBuilder,
    super.onTabScrolled,
    super.onTabChanged,
    super.key,
  }) : super(adapter: WeeklyAdapter(weekdays: weekdays));
}
