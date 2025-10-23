import 'date_time_extension.dart';
import 'period_adapter.dart';

class WeeklyAdapter implements PeriodAdapter {
  final List<int> weekdays;

  const WeeklyAdapter({required this.weekdays});

  @override
  int pageSize(DateTime date) => _weeks(date).length;

  @override
  DateTime pageStart(DateTime date) =>
      date.weekStart(weekdays).monthStart(weekdays);

  @override
  DateTime pageToDate(DateTime base, int page) =>
      DateTime.utc(base.year, base.month + page).monthStart(weekdays);

  @override
  int dateToPage(DateTime base, DateTime date) {
    final page = pageStart(date);
    return (page.year - base.year) * 12 + (page.month - base.month);
  }

  @override
  DateTime indexToDate(DateTime base, int index) =>
      base.add(Duration(days: index * 7));

  @override
  int dateToIndex(DateTime base, DateTime date) => date.differenceInWeeks(base);

  @override
  DateTime subIndexToDate(DateTime pageDate, int subIndex) =>
      _weeks(pageDate)[subIndex];

  @override
  int dateToSubIndex(DateTime pageDate, DateTime date) {
    final weeks = _weeks(pageDate);
    final index = weeks.indexWhere((d) => d.isSameWeek(date));
    return index >= 0 ? index : 0;
  }

  List<DateTime> _weeks(DateTime monthStart) {
    final weeks = <DateTime>[];
    var current = monthStart;

    while (current.month == monthStart.month) {
      weeks.add(current);
      current = current.add(const Duration(days: 7));
    }

    return weeks;
  }
}
