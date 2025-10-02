import 'date_time_extension.dart';
import 'period_adapter.dart';

class DailyAdapter implements PeriodAdapter {
  final List<int> weekdays;

  const DailyAdapter({required this.weekdays});

  @override
  int pageSize(DateTime date) => weekdays.length;

  @override
  DateTime pageStart(DateTime date) => date.weekStart(weekdays);

  @override
  DateTime pageToDate(DateTime base, int page) =>
      base.add(Duration(days: page * 7));

  @override
  int dateToPage(DateTime base, DateTime date) => date.differenceInWeeks(base);

  @override
  DateTime indexToDate(DateTime base, int index) {
    final length = weekdays.length;
    final weeksOffset =
        (index >= 0) ? index ~/ length : ((index + 1) ~/ length) - 1;
    final subIndex = index - weeksOffset * length;

    final weekStart =
        base.add(Duration(days: weeksOffset * 7)).weekStart(weekdays);
    final day = weekdays[subIndex];
    return weekStart.add(Duration(days: day - weekdays.first));
  }

  @override
  int dateToIndex(DateTime base, DateTime date) {
    final diffDays = date.difference(base).inDays;
    final weeksOffset =
        (diffDays >= 0) ? diffDays ~/ 7 : ((diffDays + 1) ~/ 7) - 1;

    final subIndex = weekdays.indexOf(date.weekday);
    return weeksOffset * weekdays.length + subIndex;
  }

  @override
  DateTime subIndexToDate(DateTime pageDate, int subIndex) =>
      pageDate.add(Duration(days: weekdays[subIndex] - weekdays.first));

  @override
  int dateToSubIndex(DateTime pageDate, DateTime date) =>
      weekdays.indexOf(date.weekday);
}
