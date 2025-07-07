import 'package:noted/data/objectbox/objectbox.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:noted/data/objectbox/objectbox.g.dart';

class ObjectBoxManager {
  static ObjectBoxManager? _instance;
  static ObjectBoxManager get instance => _instance!;
  late final Store _store;
  late final Box<ItemEntity> _itemBox;
  late final Box<AppPreferenceEntity> _preferenceBox;
  late final Box<CacheEntity> _cacheBox;

  ObjectBoxManager._create(this._store) {
    _itemBox = Box<ItemEntity>(_store);
    _preferenceBox = Box<AppPreferenceEntity>(_store);
    _cacheBox = Box<CacheEntity>(_store);
  }

  static Future<void> initialize() async {
    if (_instance == null) {
      final docsDir = await getApplicationDocumentsDirectory();
      final store = await openStore(
        directory: p.join(docsDir.path, "objectbox"),
      );
      _instance = ObjectBoxManager._create(store);
    }
  }

  // Getters for boxes
  Box<ItemEntity> get itemBox => _itemBox;
  Box<AppPreferenceEntity> get preferenceBox => _preferenceBox;
  Box<CacheEntity> get cacheBox => _cacheBox;

  void close() {
    _store.close();
  }

  // Item operations
  List<ItemEntity> getItemsByType(String listType) {
    return _itemBox.query(ItemEntity_.listType.equals(listType)).build().find();
  }

  void addItem(ItemEntity item) {
    _itemBox.put(item);
  }

  void updateItem(ItemResponse item) {
    final query = _itemBox
        .query(
          ItemEntity_.itemId
              .equals(item.id!)
              .and(ItemEntity_.categoryName.equals(item.category!.name)),
        )
        .build();
    final existingItem = query.findFirst();
    query.close();

    if (existingItem != null) {
      existingItem.personalRating = item.personalRating;
      existingItem.personalNotes = item.personalNotes;
      _itemBox.put(existingItem);
    }
  }

  bool removeItem(String itemId, String categoryName, String listType) {
    final query = _itemBox
        .query(
          ItemEntity_.itemId
              .equals(itemId)
              .and(ItemEntity_.categoryName.equals(categoryName))
              .and(ItemEntity_.listType.equals(listType)),
        )
        .build();
    final items = query.find();
    query.close();
    if (items.isNotEmpty) {
      _itemBox.remove(items.first.id);
      return true;
    }
    return false;
  }

  void clearItemsByType(String listType) {
    final query = _itemBox.query(ItemEntity_.listType.equals(listType)).build();
    final items = query.find();
    query.close();
    if (items.isNotEmpty) {
      _itemBox.removeMany(items.map((e) => e.id).toList());
    }
  }

  bool itemExists(String itemId, String categoryName, String listType) {
    final query = _itemBox
        .query(
          ItemEntity_.itemId
              .equals(itemId)
              .and(ItemEntity_.categoryName.equals(categoryName))
              .and(ItemEntity_.listType.equals(listType)),
        )
        .build();
    final count = query.count();
    query.close();
    return count > 0;
  }

  // Batch operations for backup/restore efficiency
  void addItemsBatch(List<ItemEntity> items) {
    _itemBox.putMany(items);
  }

  Map<String, List<ItemEntity>> getAllItemsByType() {
    final allItems = _itemBox.getAll();
    final Map<String, List<ItemEntity>> grouped = {};

    for (final item in allItems) {
      grouped.putIfAbsent(item.listType, () => []).add(item);
    }

    return grouped;
  }

  int getItemCountByType(String listType) {
    final query = _itemBox.query(ItemEntity_.listType.equals(listType)).build();
    final count = query.count();
    query.close();
    return count;
  }

  // Cache operations
  void setCache(String key, String jsonData) {
    // Remove existing cache with this key
    final existingQuery = _cacheBox.query(CacheEntity_.key.equals(key)).build();
    final existing = existingQuery.findFirst();
    existingQuery.close();

    if (existing != null) {
      _cacheBox.remove(existing.id);
    }

    // Add new cache
    final cache = CacheEntity(
      key: key,
      jsonData: jsonData,
      cacheTime: DateTime.now().millisecondsSinceEpoch,
    );
    _cacheBox.put(cache);
  }

  CacheEntity? getCache(String key) {
    final query = _cacheBox.query(CacheEntity_.key.equals(key)).build();
    final cache = query.findFirst();
    query.close();
    return cache;
  }

  void removeCache(String key) {
    final query = _cacheBox.query(CacheEntity_.key.equals(key)).build();
    final cache = query.findFirst();
    query.close();
    if (cache != null) {
      _cacheBox.remove(cache.id);
    }
  }

  void clearAllCache() {
    _cacheBox.removeAll();
  }

  // Enhanced cache operations for backup/restore
  List<CacheEntity> getAllValidCache({int? maxAgeMs}) {
    final allCache = _cacheBox.getAll();
    if (maxAgeMs == null) return allCache;

    return allCache.where((cache) => cache.isValid(maxAgeMs)).toList();
  }

  void setCacheBatch(List<CacheEntity> cacheItems) {
    _cacheBox.putMany(cacheItems);
  }

  // Preference operations
  void setPreference(String key, dynamic value) {
    // Remove existing preference with this key
    final existingQuery = _preferenceBox
        .query(AppPreferenceEntity_.key.equals(key))
        .build();
    final existing = existingQuery.findFirst();
    existingQuery.close();

    if (existing != null) {
      _preferenceBox.remove(existing.id);
    }

    // Create new preference based on value type
    AppPreferenceEntity preference;
    if (value is String) {
      preference = AppPreferenceEntity(
        key: key,
        stringValue: value,
        type: 'string',
      );
    } else if (value is int) {
      preference = AppPreferenceEntity(key: key, intValue: value, type: 'int');
    } else if (value is double) {
      preference = AppPreferenceEntity(
        key: key,
        doubleValue: value,
        type: 'double',
      );
    } else if (value is bool) {
      preference = AppPreferenceEntity(
        key: key,
        boolValue: value,
        type: 'bool',
      );
    } else {
      throw ArgumentError('Unsupported preference type: ${value.runtimeType}');
    }

    _preferenceBox.put(preference);
  }

  T? getPreference<T>(String key) {
    final query = _preferenceBox
        .query(AppPreferenceEntity_.key.equals(key))
        .build();
    final preference = query.findFirst();
    query.close();

    if (preference == null) return null;

    switch (preference.type) {
      case 'string':
        return preference.stringValue as T?;
      case 'int':
        return preference.intValue as T?;
      case 'double':
        return preference.doubleValue as T?;
      case 'bool':
        return preference.boolValue as T?;
      default:
        return null;
    }
  }

  void removePreference(String key) {
    final query = _preferenceBox
        .query(AppPreferenceEntity_.key.equals(key))
        .build();
    final preference = query.findFirst();
    query.close();
    if (preference != null) {
      _preferenceBox.remove(preference.id);
    }
  }

  void clearAllPreferences() {
    _preferenceBox.removeAll();
  }

  void setPreferencesBatch(List<AppPreferenceEntity> preferences) {
    _preferenceBox.putMany(preferences);
  }

  // Backup/Restore utility methods
  Future<Map<String, dynamic>> createFullBackup() async {
    final items = getAllItemsByType();
    final preferences = _preferenceBox.getAll();
    final cache = _cacheBox.getAll();

    return {
      'version': '1.0',
      'timestamp': DateTime.now().toIso8601String(),
      'items': items.map(
        (type, entities) => MapEntry(
          type,
          entities
              .map(
                (e) => {
                  'itemId': e.itemId,
                  'title': e.title,
                  'categoryName': e.categoryName,
                  'posterUrl': e.posterUrl,
                  'releaseDate': e.releaseDate,
                  'personalRating': e.personalRating,
                  'personalNotes': e.personalNotes,
                },
              )
              .toList(),
        ),
      ),
      'preferences': preferences
          .map(
            (p) => {
              'key': p.key,
              'stringValue': p.stringValue,
              'intValue': p.intValue,
              'doubleValue': p.doubleValue,
              'boolValue': p.boolValue,
              'type': p.type,
            },
          )
          .toList(),
      'cache': cache
          .map(
            (c) => {
              'key': c.key,
              'jsonData': c.jsonData,
              'cacheTime': c.cacheTime,
            },
          )
          .toList(),
    };
  }

  Future<bool> restoreFromBackup(Map<String, dynamic> backupData) async {
    try {
      // Clear existing data
      _clearAllData();

      // Restore items
      if (backupData.containsKey('items')) {
        final itemsData = backupData['items'] as Map<String, dynamic>;
        for (final entry in itemsData.entries) {
          final listType = entry.key;
          final items = (entry.value as List).map((itemData) {
            final data = itemData as Map<String, dynamic>;
            return ItemEntity(
              itemId: data['itemId'] ?? '',
              title: data['title'],
              categoryName: data['categoryName'],
              posterUrl: data['posterUrl'],
              releaseDate: data['releaseDate'],
              listType: listType,
              personalRating: data['personalRating'],
              personalNotes: data['personalNotes'],
            );
          }).toList();
          addItemsBatch(items);
        }
      }

      // Restore preferences
      if (backupData.containsKey('preferences')) {
        final preferencesData = backupData['preferences'] as List;
        final preferences = preferencesData.map((prefData) {
          final data = prefData as Map<String, dynamic>;
          return AppPreferenceEntity(
            key: data['key'],
            stringValue: data['stringValue'],
            intValue: data['intValue'],
            doubleValue: data['doubleValue'],
            boolValue: data['boolValue'],
            type: data['type'],
          );
        }).toList();
        setPreferencesBatch(preferences);
      }

      // Restore cache
      if (backupData.containsKey('cache')) {
        final cacheData = backupData['cache'] as List;
        final cacheItems = cacheData.map((cache) {
          final data = cache as Map<String, dynamic>;
          return CacheEntity(
            key: data['key'],
            jsonData: data['jsonData'],
            cacheTime: data['cacheTime'],
          );
        }).toList();
        setCacheBatch(cacheItems);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  void _clearAllData() {
    _itemBox.removeAll();
    _preferenceBox.removeAll();
    _cacheBox.removeAll();
  }

  // Database statistics for backup info
  Map<String, int> getDatabaseStats() {
    return {
      'totalItems': _itemBox.count(),
      'todoItems': getItemCountByType('todo'),
      'finishedItems': getItemCountByType('finished'),
      'historyItems': getItemCountByType('history'),
      'preferences': _preferenceBox.count(),
      'cacheEntries': _cacheBox.count(),
    };
  }
}
