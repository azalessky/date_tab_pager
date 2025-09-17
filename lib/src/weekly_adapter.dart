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
    final length = weekdays.length;
    final weeksOffset = (index >= 0) ? index ~/ length : ((index + 1) ~/ length) - 1;
    final subIndex = index - weeksOffset * length;

    final weekStart = base.add(Duration(days: weeksOffset * 7)).weekStart(weekdays);
    final day = weekdays[subIndex];
    return weekStart.add(Duration(days: day - 1));
  }

  @override
  int dateToIndex(DateTime base, DateTime date) {
    final diffDays = date.difference(base).inDays;
    final weeksOffset = (diffDays >= 0) ? diffDays ~/ 7 : ((diffDays + 1) ~/ 7) - 1;

    final subIndex = weekdays.indexOf(date.weekday);
    return weeksOffset * weekdays.length + subIndex;
  }

  @override
  int subCount(DateTime pageDate) => weekdays.length;

  @override
  DateTime subIndexToDate(DateTime pageDate, int subIndex) {
    final weekStart = pageDate.weekStart(weekdays);
    final day = weekdays[subIndex];
    return weekStart.add(Duration(days: day - 1));
  }

  @override
  int dateToSubIndex(DateTime pageDate, DateTime date) => weekdays.indexOf(date.weekday);
}
