abstract class PeriodAdapter {
  int pageSize(DateTime date);
  DateTime pageStart(DateTime date);

  DateTime pageToDate(DateTime base, int page);
  int dateToPage(DateTime base, DateTime date);

  DateTime indexToDate(DateTime base, int index);
  int dateToIndex(DateTime base, DateTime date);

  DateTime subIndexToDate(DateTime pageDate, int subIndex);
  int dateToSubIndex(DateTime pageDate, DateTime date);
}

extension PeriodAdapterExtension on PeriodAdapter {
  int pageCount(DateTime base, int maxPages) {
    int total = maxPages;
    int pages = 0;
    DateTime current = base;

    while (total > 0) {
      final count = pageSize(current);
      if (count == 0) break;

      pages++;
      total -= count;
      current = pageToDate(current, 1);
    }

    return pages;
  }

  int itemCount(DateTime base, int maxPages) {
    int pages = pageCount(base, maxPages);
    int items = 0;
    DateTime current = base;

    for (int i = 0; i < pages; i++) {
      items += pageSize(current);
      current = pageToDate(current, 1);
    }

    return items;
  }
}
