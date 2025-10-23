extension DateTimeExtension on DateTime {
  DateTime weekStart(List<int> weekdays) {
    int delta = (weekday - weekdays.first + 7) % 7;
    return subtract(Duration(days: delta));
  }

  DateTime monthStart(List<int> weekdays) {
    final start = DateTime.utc(year, month);
    int delta = (weekdays.first - start.weekday + 7) % 7;
    return start.add(Duration(days: delta));
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameWeek(DateTime other) =>
      DateTime.utc(year, month, day - weekday) ==
      DateTime.utc(other.year, other.month, other.day - other.weekday);

  int differenceInWeeks(DateTime other) {
    final diff = differenceInDays(other);
    final days = weekday - other.weekday;
    final weeks = diff ~/ 7 +
        (diff < 0 && days > 0 ? -1 : 0) +
        (diff > 0 && days < 0 ? 1 : 0);
    return weeks;
  }

  int differenceInDays(DateTime other) {
    DateTime start = DateTime.utc(year, month, day);
    DateTime end = DateTime.utc(other.year, other.month, other.day);
    return start.difference(end).inDays;
  }

  DateTime safeDate(List<int> weekdays) {
    final next = weekdays.firstWhere(
      (d) => d >= weekday,
      orElse: () => weekdays.first,
    );

    final delta = (next - weekday + 7) % 7;
    return DateTime.utc(year, month, day + delta);
  }
}
