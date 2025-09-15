extension DateTimeExtension on DateTime {
  DateTime weekStart(List<int> days) => add(Duration(
        days: days.first - weekday,
      ));

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

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
}
