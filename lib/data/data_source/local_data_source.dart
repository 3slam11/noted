import 'dart:convert';
import 'package:noted/data/network/error_handler.dart';
import 'package:noted/data/objectbox/objectbox.dart';
import 'package:noted/data/objectbox/objectbox_manager.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/domain/model/models.dart';

// Constants
const String cacheHomeKey = "CACHE_HOME_KEY";
const String cacheStoreKey = "CACHE_STORE_KEY";
const int cacheTime = 60000;
const String todoListType = "todo";
const String finishedListType = "finished";
const String historyListType = "history";

abstract class LocalDataSource {
  // Cache operations
  Future<MainResponse> getHomeData();
  Future<void> saveHomeToCache(MainResponse homeResponse);
  void clearCache();
  void removeFromCache(String key);

  // Item update
  Future<void> updateItem(ItemResponse itemResponse);

  // Todo operations
  Future<List<ItemResponse>> getTodo();
  Future<void> addTodo(ItemResponse todoResponse);
  Future<void> removeTodo(String id, Category category);

  // Finished operations
  Future<List<ItemResponse>> getFinished();
  Future<void> addFinished(ItemResponse finishedResponse);
  Future<void> removeFinished(String id, Category category);

  // History operations
  Future<List<ItemResponse>> getHistory();
  Future<void> addHistory(ItemResponse historyResponse);
  Future<void> removeHistory(String id, Category category);

  // Methods to clear lists
  Future<void> clearTodo();
  Future<void> clearFinished();
  Future<void> clearHistory();
}

class LocalDataSourceImpl implements LocalDataSource {
  final ObjectBoxManager _objectBoxManager;

  LocalDataSourceImpl(this._objectBoxManager);

  // Cache operations
  @override
  Future<MainResponse> getHomeData() async {
    final cachedItem = _objectBoxManager.getCache(cacheHomeKey);

    if (cachedItem?.isValid(cacheTime) == true) {
      try {
        final jsonMap =
            jsonDecode(cachedItem!.jsonData) as Map<String, dynamic>;
        return MainResponse.fromJson(jsonMap);
      } catch (e) {
        // If parsing fails, remove invalid cache
        _objectBoxManager.removeCache(cacheHomeKey);
      }
    }

    throw ErrorHandler.handle(DataSource.CACHE_ERROR);
  }

  @override
  Future<void> saveHomeToCache(MainResponse homeResponse) async {
    try {
      final jsonData = jsonEncode(homeResponse.toJson());
      _objectBoxManager.setCache(cacheHomeKey, jsonData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void clearCache() {
    _objectBoxManager.clearAllCache();
  }

  @override
  void removeFromCache(String key) {
    _objectBoxManager.removeCache(key);
  }

  // Item update
  @override
  Future<void> updateItem(ItemResponse itemResponse) async {
    await _updateItemInList(itemResponse);
  }

  // Todo operations
  @override
  Future<List<ItemResponse>> getTodo() => _getItemList(todoListType);

  @override
  Future<void> addTodo(ItemResponse todoResponse) async {
    await _addItemToList(todoResponse, todoListType);
  }

  @override
  Future<void> removeTodo(String id, Category category) async {
    await _removeItemFromList(id, category, todoListType);
  }

  // Finished operations
  @override
  Future<List<ItemResponse>> getFinished() => _getItemList(finishedListType);

  @override
  Future<void> addFinished(ItemResponse finishedResponse) async {
    await _addItemToList(finishedResponse, finishedListType);
  }

  @override
  Future<void> removeFinished(String id, Category category) async {
    await _removeItemFromList(id, category, finishedListType);
  }

  // History operations
  @override
  Future<List<ItemResponse>> getHistory() => _getItemList(historyListType);

  @override
  Future<void> addHistory(ItemResponse historyResponse) async {
    await _addItemToList(historyResponse, historyListType);
  }

  @override
  Future<void> removeHistory(String id, Category category) async {
    await _removeItemFromList(id, category, historyListType);
  }

  // Private helper methods
  Future<List<ItemResponse>> _getItemList(String listType) async {
    try {
      final entities = _objectBoxManager.getItemsByType(listType);

      return entities
          .map(_convertEntityToResponse)
          .where((item) => item != null)
          .cast<ItemResponse>()
          .toList();
    } catch (error) {
      return [];
    }
  }

  ItemResponse? _convertEntityToResponse(ItemEntity entity) {
    try {
      return ItemResponse(
        entity.itemId,
        entity.title,
        entity.category,
        entity.posterUrl,
        entity.releaseDate,
        personalRating: entity.personalRating,
        personalNotes: entity.personalNotes,
        dateAdded: entity.dateAdded,
      );
    } catch (error) {
      return null;
    }
  }

  Future<void> _addItemToList(ItemResponse item, String listType) async {
    try {
      // Check if item already exists
      if (_itemExists(item, listType)) {
        return;
      }

      final entity = ItemEntity.fromDomain(
        item.id ?? '',
        item.title,
        item.category,
        item.posterUrl,
        item.releaseDate,
        listType,
        personalRating: item.personalRating,
        personalNotes: item.personalNotes,
        dateAdded: item.dateAdded ?? DateTime.now(),
      );

      _objectBoxManager.addItem(entity);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _updateItemInList(ItemResponse item) async {
    try {
      _objectBoxManager.updateItem(item);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _removeItemFromList(
    String id,
    Category category,
    String listType,
  ) async {
    try {
      _objectBoxManager.removeItem(id, category.name, listType);
    } catch (error) {
      rethrow;
    }
  }

  bool _itemExists(ItemResponse targetItem, String listType) {
    if (targetItem.id == null || targetItem.category == null) {
      return false;
    }

    return _objectBoxManager.itemExists(
      targetItem.id!,
      targetItem.category!.name,
      listType,
    );
  }

  @override
  Future<void> clearTodo() async {
    _objectBoxManager.clearItemsByType(todoListType);
  }

  @override
  Future<void> clearFinished() async {
    _objectBoxManager.clearItemsByType(finishedListType);
  }

  @override
  Future<void> clearHistory() async {
    _objectBoxManager.clearItemsByType(historyListType);
  }
}

class CachedItem {
  final dynamic data;
  final int cacheTime;

  CachedItem(this.data) : cacheTime = DateTime.now().millisecondsSinceEpoch;

  bool isValid(int expiryTimeMs) {
    final currentTimeMs = DateTime.now().millisecondsSinceEpoch;
    return currentTimeMs - cacheTime <= expiryTimeMs;
  }
}
