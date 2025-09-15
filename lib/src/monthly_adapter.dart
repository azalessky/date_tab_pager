import 'period_adapter.dart';

class MonthlyAdapter implements PeriodAdapter {
  final List<int> weekdays;

  const MonthlyAdapter({required this.weekdays});

  @override
  DateTime pageStartFor(DateTime date) => DateTime(date.year, date.month, 1);

  @override
  DateTime addPages(DateTime base, int offset) => DateTime(base.year, base.month + offset, 1);

  @override
  int dateToPageOffset(DateTime base, DateTime date) =>
      (date.year - base.year) * 12 + (date.month - base.month);

  @override
  int subCount(DateTime pageStart) => _weeks(pageStart).length;

  @override
  DateTime subIndexToDate(DateTime pageStart, int subIndex) => _weeks(pageStart)[subIndex];

  @override
  int dateToSubIndex(DateTime pageStart, DateTime date) {
    final weekIndex = (date.day - 1) ~/ 7;
    if (weekIndex < 0 || weekIndex >= subCount(pageStart)) return -1;
    return weekIndex;
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
