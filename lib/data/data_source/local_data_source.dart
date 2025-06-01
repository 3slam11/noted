import 'dart:convert';
import 'package:noted/data/network/error_handler.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/domain/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Constants
const String cacheHomeKey = "CACHE_HOME_KEY";
const String cacheStoreKey = "CACHE_STORE_KEY";
const int cacheTime = 60000;
const String todoListKey = "TODO_LIST_KEY";
const String finishedListKey = "FINISHED_LIST_KEY";
const String historyListKey = "HISTORY_LIST_KEY";

abstract class LocalDataSource {
  // Cache operations
  Future<MainResponse> getHomeData();
  Future<void> saveHomeToCache(MainResponse homeResponse);
  void clearCache();
  void removeFromCache(String key);

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
  // Runtime cache for temporary data
  final Map<String, CachedItem> _cachedMap = {};

  // SharedPreferences instance (cached for performance)
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _sharedPreferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  // Cache operations
  @override
  Future<MainResponse> getHomeData() async {
    final cachedItem = _cachedMap[cacheHomeKey];

    if (cachedItem?.isValid(cacheTime) == true) {
      return cachedItem!.data as MainResponse;
    }

    throw ErrorHandler.handle(DataSource.CACHE_ERROR);
  }

  @override
  Future<void> saveHomeToCache(MainResponse homeResponse) async {
    _cachedMap[cacheHomeKey] = CachedItem(homeResponse);
  }

  @override
  void clearCache() {
    _cachedMap.clear();
  }

  @override
  void removeFromCache(String key) {
    _cachedMap.remove(key);
  }

  // Todo operations
  @override
  Future<List<ItemResponse>> getTodo() => _getItemList(todoListKey);

  @override
  Future<void> addTodo(ItemResponse todoResponse) async {
    await _addItemToList(todoListKey, todoResponse, "Todo");
  }

  @override
  Future<void> removeTodo(String id, Category category) async {
    await _removeItemFromList(todoListKey, id, category);
  }

  // Finished operations
  @override
  Future<List<ItemResponse>> getFinished() => _getItemList(finishedListKey);

  @override
  Future<void> addFinished(ItemResponse finishedResponse) async {
    await _addItemToList(finishedListKey, finishedResponse, "Finished");
  }

  @override
  Future<void> removeFinished(String id, Category category) async {
    await _removeItemFromList(finishedListKey, id, category);
  }

  // History operations
  @override
  Future<List<ItemResponse>> getHistory() => _getItemList(historyListKey);

  @override
  Future<void> addHistory(ItemResponse historyResponse) async {
    await _addItemToList(historyListKey, historyResponse, "History");
  }

  @override
  Future<void> removeHistory(String id, Category category) async {
    await _removeItemFromList(historyListKey, id, category);
  }

  // Private helper methods
  Future<List<ItemResponse>> _getItemList(String key) async {
    try {
      final prefs = await _sharedPreferences;
      final jsonList = prefs.getStringList(key);

      if (jsonList == null || jsonList.isEmpty) {
        return [];
      }

      return jsonList
          .map(_parseItemFromJson)
          .where((item) => item != null)
          .cast<ItemResponse>()
          .toList();
    } catch (error) {
      return [];
    }
  }

  ItemResponse? _parseItemFromJson(String jsonString) {
    try {
      return ItemResponse.fromJson(jsonDecode(jsonString));
    } catch (error) {
      return null;
    }
  }

  Future<void> _addItemToList(
    String key,
    ItemResponse item,
    String listType,
  ) async {
    try {
      final items = await _getItemList(key);

      if (_itemExists(items, item)) {
        return;
      }

      items.add(item);
      await _saveItemList(key, items);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _removeItemFromList(
    String key,
    String id,
    Category category,
  ) async {
    try {
      final items = await _getItemList(key);
      final originalLength = items.length;

      items.removeWhere((item) => item.id == id && item.category == category);

      if (items.length < originalLength) {
        await _saveItemList(key, items);
      } else {}
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _saveItemList(String key, List<ItemResponse> items) async {
    try {
      final prefs = await _sharedPreferences;
      final jsonList = items
          .map(_encodeItemToJson)
          .where((jsonString) => jsonString != null)
          .cast<String>()
          .toList();

      await prefs.setStringList(key, jsonList);
    } catch (error) {
      rethrow;
    }
  }

  String? _encodeItemToJson(ItemResponse item) {
    try {
      return jsonEncode(item.toJson());
    } catch (error) {
      return null;
    }
  }

  bool _itemExists(List<ItemResponse> items, ItemResponse targetItem) {
    return items.any(
      (item) =>
          item.id == targetItem.id && item.category == targetItem.category,
    );
  }

  @override
  Future<void> clearTodo() async {
    await _saveItemList(todoListKey, []);
  }

  @override
  Future<void> clearFinished() async {
    await _saveItemList(finishedListKey, []);
  }

  @override
  Future<void> clearHistory() async {
    await _saveItemList(historyListKey, []);
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
