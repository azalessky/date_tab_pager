import 'period_tab_view.dart';
import 'weekly_adapter.dart';

class WeeklyTabView extends PeriodTabView {
  WeeklyTabView({
    required super.controller,
    required super.sync,
    required List<int> weekdays,
    required super.pageBuilder,
    super.onPageChanged,
    super.key,
  }) : super(adapter: WeeklyAdapter(weekdays: weekdays));
}
