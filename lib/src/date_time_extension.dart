import 'dart:math' as math;

extension DateTimeExtension on DateTime {
  DateTime weekStart(List<int> weekdays) {
    int delta = (weekday - weekdays.first + 7) % 7;
    return subtract(Duration(days: delta));
  }

  DateTime monthStart(List<int> weekdays) {
    final start = DateTime(year, month);
    int delta = (weekdays.first - start.weekday + 7) % 7;
    return start.add(Duration(days: delta));
  }

  bool isSameWeek(DateTime other) =>
      DateTime(year, month, day - weekday) ==
      DateTime(other.year, other.month, other.day - other.weekday);

  int differenceInWeeks(DateTime other) {
    final diff = differenceInDays(other);
    final days = weekday - other.weekday;
    final weeks = diff ~/ 7 +
        (diff < 0 && days > 0 ? -1 : 0) +
        (diff > 0 && days < 0 ? 1 : 0);
    return weeks;
  }

  int differenceInDays(DateTime other) {
    final from = DateTime(year, month, day);
    final to = DateTime(other.year, other.month, other.day);
    return (from.difference(to).inHours / 24).round();
  }

  DateTime safeDate(List<int> weekdays) {
    final date = DateTime(year, month, day);
    int min = weekdays.reduce(math.min);
    int max = weekdays.reduce(math.max);
    int weekday = date.weekday;

    if (weekday < min) {
      return date.add(Duration(days: min - weekday));
    } else if (weekday > max) {
      return date.add(Duration(days: min - weekday + 7));
    } else if (!weekdays.contains(weekday)) {
      int next = weekdays.where((e) => e > weekday).first;
      return date.add(Duration(days: next - weekday));
    }
    return date;
  }
}
