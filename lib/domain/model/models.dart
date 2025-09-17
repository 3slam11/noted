import 'package:noted/gen/strings.g.dart';

// main models

enum ItemListType { todo, finished, history }

enum Category {
  all,
  movies,
  series,
  books,
  games;

  String localizedCategory() {
    switch (this) {
      case Category.all:
        return t.home.all;
      case Category.movies:
        return t.home.movies;
      case Category.series:
        return t.home.series;
      case Category.books:
        return t.home.books;
      case Category.games:
        return t.home.games;
    }
  }
}

enum SortOption {
  dateAddedNewest,
  dateAddedOldest,
  titleAsc,
  titleDesc,
  releaseDateNewest,
  releaseDateOldest,
  ratingHighest,
  ratingLowest;

  String localizedName() {
    switch (this) {
      case SortOption.dateAddedNewest:
        return t.sort.dateAddedNewest;
      case SortOption.dateAddedOldest:
        return t.sort.dateAddedOldest;
      case SortOption.titleAsc:
        return t.sort.titleAsc;
      case SortOption.titleDesc:
        return t.sort.titleDesc;
      case SortOption.releaseDateNewest:
        return t.sort.releaseDateNewest;
      case SortOption.releaseDateOldest:
        return t.sort.releaseDateOldest;
      case SortOption.ratingHighest:
        return t.sort.ratingHighest;
      case SortOption.ratingLowest:
        return t.sort.ratingLowest;
    }
  }
}

class Item {
  final String? id;
  final String? title;
  final Category? category;
  final String? posterUrl;
  final String? releaseDate;
  final double? personalRating;
  final String? personalNotes;
  final DateTime? dateAdded;

  Item(
    this.id,
    this.title,
    this.category,
    this.posterUrl,
    this.releaseDate, {
    this.personalRating,
    this.personalNotes,
    this.dateAdded,
  });

  Item copyWith({
    String? id,
    String? title,
    Category? category,
    String? posterUrl,
    String? releaseDate,
    double? personalRating,
    String? personalNotes,
    DateTime? dateAdded,
  }) {
    return Item(
      id ?? this.id,
      title ?? this.title,
      category ?? this.category,
      posterUrl ?? this.posterUrl,
      releaseDate ?? this.releaseDate,
      personalRating: personalRating ?? this.personalRating,
      personalNotes: personalNotes ?? this.personalNotes,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}

class TaskData {
  final List<Item> todos;
  final List<Item> finished;
  TaskData(this.todos, this.finished);
}

class MainObject {
  TaskData? mainData;
  MainObject(this.mainData);
}

// details models
class Details {
  final String id;
  final String title;
  final String? description;
  final String? releaseDate;
  final double? rating;
  final String? publisher;
  final List<String>? platforms;
  final List<String> imageUrls;
  Category category;

  Details({
    required this.id,
    required this.title,
    required this.imageUrls,
    this.description,
    this.releaseDate,
    this.rating,
    this.publisher,
    this.platforms,
    required this.category,
  });
}

// search models
class SearchResults {
  List<SearchItem>? items;
  SearchResults({this.items});
}

class SearchItem {
  String id;
  String title;
  String? imageUrl;
  String? releaseDate;
  Category category;
  final bool isLocallyAdded;
  SearchItem({
    required this.id,
    required this.title,
    this.imageUrl,
    this.releaseDate,
    required this.category,
    this.isLocallyAdded = false,
  });

  SearchItem copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? releaseDate,
    Category? category,
    bool? isLocallyAdded,
  }) {
    return SearchItem(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      releaseDate: releaseDate ?? this.releaseDate,
      category: category ?? this.category,
      isLocallyAdded: isLocallyAdded ?? this.isLocallyAdded,
    );
  }
}

// statistics model
class StatisticsData {
  final int totalItems;
  final Map<Category, int> categoryCounts;
  final bool isMonthly;

  StatisticsData({
    required this.totalItems,
    required this.categoryCounts,
    required this.isMonthly,
  });
}
