import 'period_adapter.dart';
import 'date_time_extension.dart';

class WeeklyAdapter implements PeriodAdapter {
  final List<int> weekdays;

  const WeeklyAdapter({required this.weekdays});

  @override
  DateTime pageDate(DateTime date) => date.weekStart(weekdays);

  @override
  DateTime pageToDate(DateTime base, int page) => base.add(Duration(days: page * 7));

  @override
  int dateToPage(DateTime base, DateTime date) => date.differenceInWeeks(base);

  @override
  DateTime indexToDate(DateTime base, int index) {
    final weeksOffset = index ~/ weekdays.length;
    final subIndex = index % weekdays.length;

    final weekStart = base.add(Duration(days: weeksOffset * 7));
    return weekStart.add(Duration(days: weekdays[subIndex] - weekdays.first));
  }

  @override
  int subCount(DateTime pageDate) => weekdays.length;

  @override
  DateTime subIndexToDate(DateTime pageDate, int subIndex) =>
      pageDate.add(Duration(days: weekdays[subIndex] - weekdays.first));

  @override
  int dateToSubIndex(DateTime pageDate, DateTime date) => weekdays.indexOf(date.weekday);
}
