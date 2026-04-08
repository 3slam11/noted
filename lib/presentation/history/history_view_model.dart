import 'dart:async';
import 'package:noted/app/app_events.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/usecases/history_usecase.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:noted/presentation/resources/item_sort_extension.dart';
import 'package:rxdart/rxdart.dart';

class HistoryViewModel extends BaseViewModel
    implements HistoryViewModelInputs, HistoryViewModelOutputs {
  final BehaviorSubject<List<Item>> _historyController =
      BehaviorSubject<List<Item>>();

  final BehaviorSubject<Category> _selectedCategoryController =
      BehaviorSubject<Category>.seeded(Category.all);

  final BehaviorSubject<SortOption> _sortOptionController =
      BehaviorSubject<SortOption>.seeded(SortOption.dateAdded);

  final BehaviorSubject<bool> _isAscendingController =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<bool> _isFilterVisibleController =
      BehaviorSubject<bool>.seeded(true);
  final BehaviorSubject<bool> _showFilterToggleController =
      BehaviorSubject<bool>.seeded(true);

  final HistoryUsecase _historyUsecase;
  final DataGlobalNotifier _dataGlobalNotifier;
  final AppPrefs _appPrefs;

  List<Item> _rawHistoryItems = [];
  bool _showSeriesTracker = true;

  final Set<String> _pendingDeletions = {};

  HistoryViewModel(
    this._historyUsecase,
    this._dataGlobalNotifier,
    this._appPrefs,
  ) {
    _dataGlobalNotifier.addListener(_silentRefresh);
  }

  @override
  bool get showSeriesTracker => _showSeriesTracker;

  String _getItemKey(Item item) => '${item.id}_${item.category}';

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
    _showSeriesTracker = await _appPrefs.getShowSeriesTracker();
    _isFilterVisibleController.add(await _appPrefs.getIsFilterVisible());
    _showFilterToggleController.add(await _appPrefs.getShowFilterToggle());

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
        _rawHistoryItems = historyItems
            .where((item) => !_pendingDeletions.contains(_getItemKey(item)))
            .toList();
        _applySort();
        if (isInitialLoad) {
          inputState.add(ContentState());
        }
      },
    );
  }

  void _applySort() {
    final sortedItems = _rawHistoryItems.applySort(
      _sortOptionController.value,
      _isAscendingController.value,
    );
    _historyController.add(sortedItems);
  }

  @override
  void setCategory(Category category) {
    _selectedCategoryController.add(category);
  }

  @override
  void setSortOption(SortOption sortOption) {
    if (_sortOptionController.value == sortOption) {
      _isAscendingController.add(!_isAscendingController.value);
    } else {
      _sortOptionController.add(sortOption);
      _isAscendingController.add(false);
    }
    _applySort();
  }

  @override
  void toggleFilter() async {
    final newValue = !_isFilterVisibleController.value;
    _isFilterVisibleController.add(newValue);
    await _appPrefs.setIsFilterVisible(newValue);
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
    _pendingDeletions.add(_getItemKey(item));
    final index = _rawHistoryItems.indexWhere((i) => _isSameItem(i, item));
    if (index != -1) {
      _rawHistoryItems.removeAt(index);
      _applySort();
      return index;
    }
    return null;
  }

  @override
  void undoDeleteHistoryItem(Item item, int index) {
    _pendingDeletions.remove(_getItemKey(item));
    if (index >= 0 && index <= _rawHistoryItems.length) {
      _rawHistoryItems.insert(index, item);
    } else {
      _rawHistoryItems.add(item);
    }
    _applySort();
  }

  @override
  Future<void> confirmDeleteHistoryItem(Item item) async {
    _pendingDeletions.remove(_getItemKey(item));
    final result = await _historyUsecase.deleteHistoryItem(item);
    result.fold(
      (failure) {
        _handlePopupError(failure.message);
        loadHistoryItems();
      },
      (_) {
        _dataGlobalNotifier.notifyDataImported();
      },
    );
  }

  @override
  Future<void> deleteHistoryItem(Item item) async {
    final result = await _historyUsecase.deleteHistoryItem(item);
    result.fold((failure) => _handlePopupError(failure.message), (_) {
      _removeItemFromUI(item);
      _dataGlobalNotifier.notifyDataImported();
    });
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
        _dataGlobalNotifier.notifyDataImported();
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
  Future<void> moveToSaved(Item item) async {
    final result = await _historyUsecase.moveToSaved(item);
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
    _isAscendingController.close();
    _isFilterVisibleController.close();
    _showFilterToggleController.close();
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

  @override
  Stream<bool> get outputIsAscending => _isAscendingController.stream;

  @override
  Stream<bool> get outputIsFilterVisible => _isFilterVisibleController.stream;

  @override
  Stream<bool> get outputShowFilterToggle => _showFilterToggleController.stream;
}

abstract class HistoryViewModelInputs {
  Sink<Category> get inputSelectedCategory;
  Sink<SortOption> get inputSortOption;
  void setCategory(Category category);
  void setSortOption(SortOption sortOption);
  void toggleFilter();
  Future<void> loadHistoryItems();

  int? deleteHistoryItemTemporarily(Item item);
  void undoDeleteHistoryItem(Item item, int index);
  Future<void> confirmDeleteHistoryItem(Item item);

  Future<void> deleteHistoryItem(Item item);
  Future<void> updateItem(Item item);
  Future<void> moveToTodo(Item item);
  Future<void> moveToFinished(Item item);
  Future<void> moveToSaved(Item item);
}

abstract class HistoryViewModelOutputs {
  Stream<List<Item>> get outputHistoryItems;
  Stream<Category> get outputSelectedCategory;
  Stream<SortOption> get outputSortOption;
  Stream<bool> get outputIsAscending;
  Stream<bool> get outputIsFilterVisible;
  Stream<bool> get outputShowFilterToggle;
  bool get showSeriesTracker;
}
