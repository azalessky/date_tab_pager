abstract class PeriodAdapter {
  DateTime pageDate(DateTime date);

  DateTime addPages(DateTime base, int offset);

  int dateToPageOffset(DateTime base, DateTime date);

  int subCount(DateTime pageStart);

  DateTime subIndexToDate(DateTime pageStart, int subIndex);

  int dateToSubIndex(DateTime pageStart, DateTime date);
}
