abstract class PeriodAdapter {
  DateTime pageDate(DateTime date);
  DateTime pageToDate(DateTime base, int page);
  int dateToPage(DateTime base, DateTime date);

  DateTime indexToDate(DateTime base, int index);
  int dateToIndex(DateTime base, DateTime date);

  int subCount(DateTime pageDate);
  DateTime subIndexToDate(DateTime pageDate, int subIndex);
  int dateToSubIndex(DateTime pageDate, DateTime date);
}
