import 'dart:async';
import 'package:noted/app/app_events.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/usecases/saved_usecase.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class SavedViewModel extends BaseViewModel
    implements SavedViewModelInputs, SavedViewModelOutputs {
  final BehaviorSubject<List<Item>> _savedController =
      BehaviorSubject<List<Item>>();

  final BehaviorSubject<Category> _selectedCategoryController =
      BehaviorSubject<Category>.seeded(Category.all);

  final BehaviorSubject<SortOption> _sortOptionController =
      BehaviorSubject<SortOption>.seeded(SortOption.dateAddedNewest);

  final SavedUsecase _savedUsecase;
  final DataGlobalNotifier _dataGlobalNotifier;
  final AppPrefs _appPrefs;

  List<Item> _rawSavedItems = [];
  bool _showSeriesTracker = true;

  SavedViewModel(this._savedUsecase, this._dataGlobalNotifier, this._appPrefs) {
    _dataGlobalNotifier.addListener(_silentRefresh);
  }

  @override
  bool get showSeriesTracker => _showSeriesTracker;

  @override
  void start() {
    loadSavedItems();
  }

  void _silentRefresh() {
    _fetchAndProcessData(isInitialLoad: false);
  }

  @override
  Future<void> loadSavedItems() async {
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    );
    await _fetchAndProcessData(isInitialLoad: true);
  }

  Future<void> _fetchAndProcessData({required bool isInitialLoad}) async {
    _showSeriesTracker = await _appPrefs.getShowSeriesTracker();
    (await _savedUsecase.execute(null)).fold(
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
        _savedController.add([]);
      },
      (savedItems) {
        _rawSavedItems = savedItems;
        _applySort();
        if (isInitialLoad) {
          inputState.add(ContentState());
        }
      },
    );
  }

  void _applySort() {
    final sortedItems = _sortItems(_rawSavedItems, _sortOptionController.value);
    _savedController.add(sortedItems);
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
    _rawSavedItems.removeWhere((i) => _isSameItem(i, item));
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
  int? deleteSavedItemTemporarily(Item item) {
    final currentItems = _savedController.valueOrNull;
    if (currentItems == null) return null;

    final index = currentItems.indexWhere((i) => _isSameItem(i, item));
    if (index != -1) {
      _rawSavedItems.removeWhere((i) => _isSameItem(i, item));
      _applySort();
      return index;
    }
    return null;
  }

  @override
  void undoDeleteSavedItem(Item item, int index) {
    final currentItems = _savedController.valueOrNull;
    if (currentItems == null) return;

    if (index >= 0 && index <= _rawSavedItems.length) {
      _rawSavedItems.insert(index, item);
      _applySort();
    }
  }

  @override
  Future<void> confirmDeleteSavedItem(Item item) async {
    final result = await _savedUsecase.deleteSavedItem(item);
    result.fold(
      (failure) {
        _handlePopupError(failure.message);
        loadSavedItems();
      },
      (_) {
        _dataGlobalNotifier.notifyDataImported();
      },
    );
  }

  @override
  Future<void> deleteSavedItem(Item item) async {
    final result = await _savedUsecase.deleteSavedItem(item);
    result.fold((failure) => _handlePopupError(failure.message), (_) {
      _removeItemFromUI(item);
      _dataGlobalNotifier.notifyDataImported();
    });
  }

  @override
  Future<void> updateItem(Item updatedItem) async {
    final result = await _savedUsecase.updateItem(updatedItem);
    result.fold((failure) => _handlePopupError(failure.message), (_) {
      final index = _rawSavedItems.indexWhere(
        (i) => _isSameItem(i, updatedItem),
      );
      if (index != -1) {
        _rawSavedItems[index] = updatedItem;
        _applySort();
        _dataGlobalNotifier.notifyDataImported();
      }
    });
  }

  @override
  Future<void> moveToTodo(Item item) async {
    final result = await _savedUsecase.moveToTodo(item);
    result.fold((failure) => _handlePopupError(failure.message), (_) {
      _removeItemFromUI(item);
      _dataGlobalNotifier.notifyDataImported();
    });
  }

  @override
  Future<void> moveToFinished(Item item) async {
    final result = await _savedUsecase.moveToFinished(item);
    result.fold((failure) => _handlePopupError(failure.message), (_) {
      _removeItemFromUI(item);
      _dataGlobalNotifier.notifyDataImported();
    });
  }

  @override
  Future<void> moveToHistory(Item item) async {
    final result = await _savedUsecase.moveToHistory(item);
    result.fold((failure) => _handlePopupError(failure.message), (_) {
      _removeItemFromUI(item);
      _dataGlobalNotifier.notifyDataImported();
    });
  }

  @override
  void dispose() {
    _savedController.close();
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
  Stream<List<Item>> get outputSavedItems => _savedController.stream;

  @override
  Stream<Category> get outputSelectedCategory =>
      _selectedCategoryController.stream;

  @override
  Stream<SortOption> get outputSortOption => _sortOptionController.stream;
}

abstract class SavedViewModelInputs {
  Sink<Category> get inputSelectedCategory;
  Sink<SortOption> get inputSortOption;
  void setCategory(Category category);
  void setSortOption(SortOption sortOption);
  Future<void> loadSavedItems();

  int? deleteSavedItemTemporarily(Item item);
  void undoDeleteSavedItem(Item item, int index);
  Future<void> confirmDeleteSavedItem(Item item);

  Future<void> deleteSavedItem(Item item);
  Future<void> updateItem(Item item);
  Future<void> moveToTodo(Item item);
  Future<void> moveToFinished(Item item);
  Future<void> moveToHistory(Item item);
}

abstract class SavedViewModelOutputs {
  Stream<List<Item>> get outputSavedItems;
  Stream<Category> get outputSelectedCategory;
  Stream<SortOption> get outputSortOption;
  bool get showSeriesTracker;
}
