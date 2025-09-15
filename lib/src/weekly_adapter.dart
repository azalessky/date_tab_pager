import 'period_adapter.dart';
import 'date_time_extension.dart';

class WeeklyAdapter implements PeriodAdapter {
  final List<int> weekdays;

  const WeeklyAdapter({required this.weekdays});

  @override
  DateTime pageStartFor(DateTime date) => date.weekStart(weekdays);

  @override
  DateTime addPages(DateTime base, int offset) => base.add(Duration(days: offset * 7));

  @override
  int dateToPageOffset(DateTime base, DateTime date) => date.differenceInWeeks(base);

  @override
  int subCount(DateTime pageStart) => weekdays.length;

  @override
  DateTime subIndexToDate(DateTime pageStart, int subIndex) =>
      pageStart.add(Duration(days: weekdays[subIndex] - weekdays.first));

  @override
  int dateToSubIndex(DateTime pageStart, DateTime date) => weekdays.indexOf(date.weekday);
}
