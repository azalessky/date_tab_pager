import 'period_tab_bar.dart';
import 'monthly_adapter.dart';

class MonthlyTabBar extends PeriodTabBar {
  MonthlyTabBar({
    required super.controller,
    required super.sync,
    required List<int> weekdays,
    super.height = 48.0,
    required super.tabBuilder,
    super.onTabScrolled,
    super.onTabChanged,
    super.key,
  }) : super(adapter: MonthlyAdapter(weekdays: weekdays));
}
