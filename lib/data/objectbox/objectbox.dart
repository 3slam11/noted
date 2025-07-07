import 'package:objectbox/objectbox.dart';
import 'package:noted/domain/model/models.dart';

@Entity()
class ItemEntity {
  @Id()
  int id = 0;

  String itemId;
  String? title;
  String? categoryName;
  String? posterUrl;
  String? releaseDate;
  String listType; // 'todo', 'finished', 'history'

  double? personalRating;
  String? personalNotes;

  @Property(type: PropertyType.date)
  DateTime? dateAdded;

  ItemEntity({
    this.id = 0,
    required this.itemId,
    this.title,
    this.categoryName,
    this.posterUrl,
    this.releaseDate,
    required this.listType,
    this.personalRating,
    this.personalNotes,
    this.dateAdded,
  });

  // Convert from domain model
  static ItemEntity fromDomain(
    String itemId,
    String? title,
    Category? category,
    String? posterUrl,
    String? releaseDate,
    String listType, {
    double? personalRating,
    String? personalNotes,
    DateTime? dateAdded,
  }) {
    return ItemEntity(
      itemId: itemId,
      title: title,
      categoryName: category?.name,
      posterUrl: posterUrl,
      releaseDate: releaseDate,
      listType: listType,
      personalRating: personalRating,
      personalNotes: personalNotes,
      dateAdded: dateAdded,
    );
  }

  // Convert to domain model
  Category? get category {
    if (categoryName == null) return null;
    try {
      return Category.values.firstWhere((c) => c.name == categoryName);
    } catch (e) {
      return null;
    }
  }
}

@Entity()
class AppPreferenceEntity {
  @Id()
  int id = 0;

  @Unique()
  String key;
  String? stringValue;
  int? intValue;
  double? doubleValue;
  bool? boolValue;
  String? type; // 'string', 'int', 'double', 'bool'

  AppPreferenceEntity({
    this.id = 0,
    required this.key,
    this.stringValue,
    this.intValue,
    this.doubleValue,
    this.boolValue,
    this.type,
  });
}

@Entity()
class CacheEntity {
  @Id()
  int id = 0;

  @Unique()
  String key;
  String jsonData;
  int cacheTime;

  CacheEntity({
    this.id = 0,
    required this.key,
    required this.jsonData,
    required this.cacheTime,
  });

  bool isValid(int expiryTimeMs) {
    final currentTimeMs = DateTime.now().millisecondsSinceEpoch;
    return currentTimeMs - cacheTime <= expiryTimeMs;
  }
}
