import 'date_time_extension.dart';
import 'period_adapter.dart';

class WeeklyAdapter implements PeriodAdapter {
  final List<int> weekdays;

  const WeeklyAdapter({required this.weekdays});

  @override
  int pageSize(DateTime date) => _weeks(date).length;

  @override
  DateTime pageDate(DateTime date) => DateTime(date.year, date.month, 1);

  @override
  DateTime pageToDate(DateTime base, int page) => DateTime(base.year, base.month + page, 1);

  @override
  int dateToPage(DateTime base, DateTime date) =>
      (date.year - base.year) * 12 + (date.month - base.month);

  @override
  DateTime indexToDate(DateTime base, int index) => base.add(Duration(days: index * 7));

  @override
  int dateToIndex(DateTime base, DateTime date) => date.differenceInWeeks(base);

  @override
  DateTime subIndexToDate(DateTime pageDate, int subIndex) => _weeks(pageDate)[subIndex];

  @override
  int dateToSubIndex(DateTime pageDate, DateTime date) {
    final weeks = _weeks(pageDate);
    final index = weeks.indexWhere((d) => d.isSameWeek(date));
    return index >= 0 ? index : 0;
  }

  List<DateTime> _weeks(DateTime monthStart) {
    final firstDay = DateTime(monthStart.year, monthStart.month, 1);
    final lastDay = DateTime(monthStart.year, monthStart.month + 1, 0);

    final weeks = <DateTime>[];
    int firstWeekday = weekdays.first;

    var current = firstDay;
    if (current.weekday != firstWeekday) {
      final delta = (firstWeekday - current.weekday + 7) % 7;
      current = current.add(Duration(days: delta));
    }

    while (current.isBefore(lastDay.add(const Duration(days: 1)))) {
      weeks.add(current);
      current = current.add(const Duration(days: 7));
    }

    return weeks;
  }
}
