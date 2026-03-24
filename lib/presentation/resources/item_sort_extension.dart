import 'package:noted/domain/model/models.dart';

extension ItemSortExtension on List<Item> {
  /// Applies the selected sort option to a list of items.
  List<Item> applySort(SortOption sortOption) {
    List<Item> sortedList = List.from(this);

    int compareStrings(String? a, String? b) =>
        (a ?? '').toLowerCase().compareTo((b ?? '').toLowerCase());

    int compareDates(DateTime? a, DateTime? b) {
      if (a == null && b == null) return 0;
      if (a == null) return 1;
      if (b == null) return -1;
      return a.compareTo(b);
    }

    DateTime? parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return null;
      }
    }

    int compareRatings(double? a, double? b) => (b ?? 0.0).compareTo(a ?? 0.0);

    sortedList.sort((a, b) {
      switch (sortOption) {
        case SortOption.titleAsc:
          return compareStrings(a.title, b.title);
        case SortOption.titleDesc:
          return compareStrings(b.title, a.title);
        case SortOption.releaseDateNewest:
          return compareDates(
            parseDate(b.releaseDate),
            parseDate(a.releaseDate),
          );
        case SortOption.releaseDateOldest:
          return compareDates(
            parseDate(a.releaseDate),
            parseDate(b.releaseDate),
          );
        case SortOption.ratingHighest:
          return compareRatings(a.personalRating, b.personalRating);
        case SortOption.ratingLowest:
          return compareRatings(b.personalRating, a.personalRating);
        case SortOption.dateAddedNewest:
          return compareDates(b.dateAdded, a.dateAdded);
        case SortOption.dateAddedOldest:
          return compareDates(a.dateAdded, b.dateAdded);
      }
    });

    return sortedList;
  }
}
