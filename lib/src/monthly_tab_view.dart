import 'period_tab_view.dart';
import 'monthly_adapter.dart';

class MonthlyTabView extends PeriodTabView {
  MonthlyTabView({
    required super.controller,
    required super.sync,
    required List<int> weekdays,
    required super.pageBuilder,
    super.onPageChanged,
    super.key,
  }) : super(adapter: MonthlyAdapter(weekdays: weekdays));
}
