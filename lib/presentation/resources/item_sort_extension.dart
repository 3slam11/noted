import 'package:noted/domain/model/models.dart';

extension ItemSortExtension on List<Item> {
  /// Applies the selected sort option to a list of items.
  List<Item> applySort(SortOption sortOption, bool isAscending) {
    List<Item> sortedList = List.from(this);

    int compareStrings(String? a, String? b) {
      final cmp = (a ?? '').toLowerCase().compareTo((b ?? '').toLowerCase());
      return isAscending ? cmp : -cmp;
    }

    int compareDates(DateTime? a, DateTime? b) {
      if (a == null && b == null) return 0;
      if (a == null) return 1; // Put nulls at the end
      if (b == null) return -1;
      final cmp = a.compareTo(b);
      return isAscending ? cmp : -cmp;
    }

    DateTime? parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return null;
      }
    }

    int compareRatings(double? a, double? b) {
      final cmp = (a ?? 0.0).compareTo(b ?? 0.0);
      return isAscending ? cmp : -cmp;
    }

    sortedList.sort((a, b) {
      switch (sortOption) {
        case SortOption.title:
          return compareStrings(a.title, b.title);
        case SortOption.releaseDate:
          return compareDates(
            parseDate(a.releaseDate),
            parseDate(b.releaseDate),
          );
        case SortOption.rating:
          return compareRatings(a.personalRating, b.personalRating);
        case SortOption.dateAdded:
          return compareDates(a.dateAdded, b.dateAdded);
      }
    });

    return sortedList;
  }
}
