import 'dart:async';
import 'package:noted/app/app_events.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/usecases/history_usecase.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class HistoryViewModel extends BaseViewModel
    implements HistoryViewModelInputs, HistoryViewModelOutputs {
  final BehaviorSubject<List<Item>> _historyController =
      BehaviorSubject<List<Item>>();

  final BehaviorSubject<Category> _selectedCategoryController =
      BehaviorSubject<Category>.seeded(Category.all);

  final BehaviorSubject<SortOption> _sortOptionController =
      BehaviorSubject<SortOption>.seeded(SortOption.dateAddedNewest);

  final HistoryUsecase _historyUsecase;
  final DataGlobalNotifier _dataGlobalNotifier;

  List<Item> _rawHistoryItems = [];

  HistoryViewModel(this._historyUsecase, this._dataGlobalNotifier) {
    _dataGlobalNotifier.addListener(_silentRefresh);
  }

  @override
  void start() {
    loadHistoryItems();
  }

  void _silentRefresh() {
    _fetchAndProcessData(isInitialLoad: false);
  }

  @override
  Future<void> loadHistoryItems() async {
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    );
    await _fetchAndProcessData(isInitialLoad: true);
  }

  Future<void> _fetchAndProcessData({required bool isInitialLoad}) async {
    (await _historyUsecase.execute(null)).fold(
      (failure) {
        if (isInitialLoad) {
          inputState.add(
            ErrorState(
              stateRendererType: StateRendererType.fullScreenErrorState,
              message: failure.message,
            ),
          );
        } else {
          inputState.add(
            ErrorState(
              stateRendererType: StateRendererType.popupErrorState,
              message: failure.message,
            ),
          );
        }
        _historyController.add([]);
      },
      (historyItems) {
        _rawHistoryItems = historyItems;
        _applySort();
        if (isInitialLoad) {
          inputState.add(ContentState());
        }
      },
    );
  }

  void _applySort() {
    final sortedItems = _sortItems(
      _rawHistoryItems,
      _sortOptionController.value,
    );
    _historyController.add(sortedItems);
  }

  List<Item> _sortItems(List<Item> items, SortOption sortOption) {
    List<Item> sortedList = List.from(items);

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

  @override
  void setCategory(Category category) {
    _selectedCategoryController.add(category);
  }

  @override
  void setSortOption(SortOption sortOption) {
    _sortOptionController.add(sortOption);
    _applySort();
  }

  bool _isSameItem(Item a, Item b) => a.id == b.id && a.category == b.category;

  void _removeItemFromUI(Item item) {
    _rawHistoryItems.removeWhere((i) => _isSameItem(i, item));
    _applySort();
  }

  void _handlePopupError(String message) {
    inputState.add(
      ErrorState(
        stateRendererType: StateRendererType.popupErrorState,
        message: message,
      ),
    );
  }

  @override
  int? deleteHistoryItemTemporarily(Item item) {
    final currentItems = _historyController.valueOrNull;
    if (currentItems == null) return null;

    final index = currentItems.indexWhere((i) => _isSameItem(i, item));
    if (index != -1) {
      _rawHistoryItems.removeWhere((i) => _isSameItem(i, item));
      _applySort();
      return index;
    }
    return null;
  }

  @override
  void undoDeleteHistoryItem(Item item, int index) {
    final currentItems = _historyController.valueOrNull;
    if (currentItems == null) return;

    if (index >= 0 && index <= _rawHistoryItems.length) {
      _rawHistoryItems.insert(index, item);
      _applySort();
    }
  }

  @override
  Future<void> confirmDeleteHistoryItem(Item item) async {
    final result = await _historyUsecase.deleteHistoryItem(item);
    result.fold(
      (failure) {
        _handlePopupError(failure.message);
        loadHistoryItems(); // On failure, restore state by reloading
      },
      (_) {
        // On success, UI is already updated. No action needed.
      },
    );
  }

  @override
  Future<void> deleteHistoryItem(Item item) async {
    final result = await _historyUsecase.deleteHistoryItem(item);
    result.fold(
      (failure) => _handlePopupError(failure.message),
      (_) => _removeItemFromUI(item),
    );
  }

  @override
  Future<void> updateItem(Item updatedItem) async {
    final result = await _historyUsecase.updateItem(updatedItem);
    result.fold((failure) => _handlePopupError(failure.message), (_) {
      final index = _rawHistoryItems.indexWhere(
        (i) => _isSameItem(i, updatedItem),
      );
      if (index != -1) {
        _rawHistoryItems[index] = updatedItem;
        _applySort();
      }
    });
  }

  @override
  Future<void> moveToTodo(Item item) async {
    final result = await _historyUsecase.moveToTodo(item);
    result.fold((failure) => _handlePopupError(failure.message), (_) {
      _removeItemFromUI(item);
      _dataGlobalNotifier.notifyDataImported();
    });
  }

  @override
  Future<void> moveToFinished(Item item) async {
    final result = await _historyUsecase.moveToFinished(item);
    result.fold((failure) => _handlePopupError(failure.message), (_) {
      _removeItemFromUI(item);
      _dataGlobalNotifier.notifyDataImported();
    });
  }

  @override
  void dispose() {
    _historyController.close();
    _selectedCategoryController.close();
    _sortOptionController.close();
    _dataGlobalNotifier.removeListener(_silentRefresh);
    super.dispose();
  }

  @override
  Sink<Category> get inputSelectedCategory => _selectedCategoryController.sink;

  @override
  Sink<SortOption> get inputSortOption => _sortOptionController.sink;

  @override
  Stream<List<Item>> get outputHistoryItems => _historyController.stream;

  @override
  Stream<Category> get outputSelectedCategory =>
      _selectedCategoryController.stream;

  @override
  Stream<SortOption> get outputSortOption => _sortOptionController.stream;
}

abstract class HistoryViewModelInputs {
  Sink<Category> get inputSelectedCategory;
  Sink<SortOption> get inputSortOption;
  void setCategory(Category category);
  void setSortOption(SortOption sortOption);
  Future<void> loadHistoryItems();

  // Deletion with Undo
  int? deleteHistoryItemTemporarily(Item item);
  void undoDeleteHistoryItem(Item item, int index);
  Future<void> confirmDeleteHistoryItem(Item item);

  // Permanent deletion from dialog
  Future<void> deleteHistoryItem(Item item);

  // Update action
  Future<void> updateItem(Item item);

  // Move actions
  Future<void> moveToTodo(Item item);
  Future<void> moveToFinished(Item item);
}

abstract class HistoryViewModelOutputs {
  Stream<List<Item>> get outputHistoryItems;
  Stream<Category> get outputSelectedCategory;
  Stream<SortOption> get outputSortOption;
}
