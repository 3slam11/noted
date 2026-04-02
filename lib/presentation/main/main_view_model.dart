import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:noted/app/app_events.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/usecases/main_usecase.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:noted/presentation/resources/item_sort_extension.dart';
import 'package:rxdart/rxdart.dart';

class MainViewModel extends BaseViewModel
    implements MainViewModelInputs, MainViewModelOutputs {
  final MainUsecase _mainUsecase;
  final DataGlobalNotifier _dataGlobalNotifier;
  final AppPrefs _appPrefs;

  final BehaviorSubject<MainObject?> _mainDataController =
      BehaviorSubject<MainObject?>();
  final BehaviorSubject<Category> _selectedCategoryController =
      BehaviorSubject<Category>.seeded(Category.all);
  final BehaviorSubject<SortOption> _sortOptionController =
      BehaviorSubject<SortOption>.seeded(SortOption.dateAddedNewest);

  MainObject? _currentObject;
  bool _showSeriesTracker = true;

  final Set<String> _pendingDeletions = {};

  MainViewModel(this._mainUsecase, this._dataGlobalNotifier, this._appPrefs) {
    _dataGlobalNotifier.addListener(_silentRefresh);
  }

  bool get hasData => _currentObject?.mainData != null;

  @override
  bool get showSeriesTracker => _showSeriesTracker;

  String _getItemKey(Item item) => '${item.id}_${item.category}';

  @override
  void start() {
    loadMainData();
  }

  void _silentRefresh() {
    _fetchAndProcessData(isInitialLoad: false);
  }

  Future<void> loadMainData() async {
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    );
    await _fetchAndProcessData(isInitialLoad: true);
  }

  Future<void> _fetchAndProcessData({required bool isInitialLoad}) async {
    _showSeriesTracker = await _appPrefs.getShowSeriesTracker();
    final result = await _mainUsecase.execute(null);
    result.fold(
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
        _currentObject = null;
        _mainDataController.add(null);
      },
      (mainObject) {
        if (mainObject.mainData != null) {
          mainObject.mainData!.todos.removeWhere(
            (item) => _pendingDeletions.contains(_getItemKey(item)),
          );
          mainObject.mainData!.finished.removeWhere(
            (item) => _pendingDeletions.contains(_getItemKey(item)),
          );
          mainObject.mainData!.saved.removeWhere(
            (item) => _pendingDeletions.contains(_getItemKey(item)),
          );
        }

        _currentObject = mainObject;
        _applySortersAndFilters();
        if (isInitialLoad) {
          inputState.add(ContentState());
        }
      },
    );
  }

  void _applySortersAndFilters() {
    if (_currentObject?.mainData == null) {
      _mainDataController.add(_currentObject);
      return;
    }

    final currentSortOption = _sortOptionController.value;

    final sortedTodos = _currentObject!.mainData!.todos.applySort(
      currentSortOption,
    );
    final sortedFinished = _currentObject!.mainData!.finished.applySort(
      currentSortOption,
    );
    final sortedSaved = _currentObject!.mainData!.saved.applySort(
      currentSortOption,
    );

    final newMainData = TaskData(sortedTodos, sortedFinished, sortedSaved);
    _mainDataController.add(MainObject(newMainData));
  }

  void _handlePopupError(Failure failure) {
    inputState.add(
      ErrorState(
        stateRendererType: StateRendererType.popupErrorState,
        message: failure.message,
      ),
    );
  }

  Future<void> _performItemOperation(
    Future<Either<Failure, void>> Function() operation, {
    required void Function() onSuccess,
  }) async {
    final result = await operation();
    result.fold(_handlePopupError, (_) {
      onSuccess();
      _applySortersAndFilters();
      _dataGlobalNotifier.notifyDataImported();
    });
  }

  @override
  void setCategory(Category category) {
    _selectedCategoryController.add(category);
  }

  @override
  void setSortOption(SortOption sortOption) {
    _sortOptionController.add(sortOption);
    _applySortersAndFilters();
  }

  @override
  Future<void> updateItem(Item updatedItem) async {
    final result = await _mainUsecase.updateItem(updatedItem);
    result.fold(_handlePopupError, (_) {
      if (!hasData) return;

      final todoIndex = _currentObject!.mainData!.todos.indexWhere(
        (i) => _isSameItem(i, updatedItem),
      );
      if (todoIndex != -1) {
        _currentObject!.mainData!.todos[todoIndex] = updatedItem;
      }

      final finishedIndex = _currentObject!.mainData!.finished.indexWhere(
        (i) => _isSameItem(i, updatedItem),
      );
      if (finishedIndex != -1) {
        _currentObject!.mainData!.finished[finishedIndex] = updatedItem;
      }

      final savedIndex = _currentObject!.mainData!.saved.indexWhere(
        (i) => _isSameItem(i, updatedItem),
      );
      if (savedIndex != -1) {
        _currentObject!.mainData!.saved[savedIndex] = updatedItem;
      }

      _applySortersAndFilters();
      _dataGlobalNotifier.notifyDataImported();
    });
  }

  @override
  Future<void> moveToFinished(Item item) async {
    await _performItemOperation(
      () => _mainUsecase.moveToFinished(item),
      onSuccess: () => _moveItemToFinished(item),
    );
  }

  @override
  Future<void> moveToTodo(Item item) async {
    await _performItemOperation(
      () => _mainUsecase.moveToTodo(item),
      onSuccess: () => _moveItemToTodo(item),
    );
  }

  @override
  Future<void> moveToSaved(Item item) async {
    await _performItemOperation(
      () => _mainUsecase.moveToSaved(item),
      onSuccess: () => _moveItemToSaved(item),
    );
  }

  @override
  int? deleteTodoTemporarily(Item item) {
    if (!hasData) return null;
    _pendingDeletions.add(_getItemKey(item));
    final index = _currentObject!.mainData!.todos.indexWhere(
      (i) => _isSameItem(i, item),
    );
    if (index != -1) {
      _currentObject!.mainData!.todos.removeAt(index);
      _applySortersAndFilters();
      return index;
    }
    return null;
  }

  @override
  void undoDeleteTodo(Item item, int index) {
    if (!hasData) return;
    _pendingDeletions.remove(_getItemKey(item));
    if (index >= 0 && index <= _currentObject!.mainData!.todos.length) {
      _currentObject!.mainData!.todos.insert(index, item);
    } else {
      _currentObject!.mainData!.todos.add(item);
    }
    _applySortersAndFilters();
  }

  @override
  Future<void> confirmDeleteTodo(Item item) async {
    _pendingDeletions.remove(_getItemKey(item));
    final result = await _mainUsecase.deleteTodo(item);
    result.fold(
      (failure) {
        _handlePopupError(failure);
        loadMainData();
      },
      (_) {
        _dataGlobalNotifier.notifyDataImported();
      },
    );
  }

  @override
  int? deleteFinishedTemporarily(Item item) {
    if (!hasData) return null;
    _pendingDeletions.add(_getItemKey(item));
    final index = _currentObject!.mainData!.finished.indexWhere(
      (i) => _isSameItem(i, item),
    );
    if (index != -1) {
      _currentObject!.mainData!.finished.removeAt(index);
      _applySortersAndFilters();
      return index;
    }
    return null;
  }

  @override
  void undoDeleteFinished(Item item, int index) {
    if (!hasData) return;
    _pendingDeletions.remove(_getItemKey(item));
    if (index >= 0 && index <= _currentObject!.mainData!.finished.length) {
      _currentObject!.mainData!.finished.insert(index, item);
    } else {
      _currentObject!.mainData!.finished.add(item);
    }
    _applySortersAndFilters();
  }

  @override
  Future<void> confirmDeleteFinished(Item item) async {
    _pendingDeletions.remove(_getItemKey(item));
    final result = await _mainUsecase.deleteFinished(item);
    result.fold(
      (failure) {
        _handlePopupError(failure);
        loadMainData();
      },
      (_) {
        _dataGlobalNotifier.notifyDataImported();
      },
    );
  }

  @override
  int? deleteSavedTemporarily(Item item) {
    if (!hasData) return null;
    _pendingDeletions.add(_getItemKey(item));
    final index = _currentObject!.mainData!.saved.indexWhere(
      (i) => _isSameItem(i, item),
    );
    if (index != -1) {
      _currentObject!.mainData!.saved.removeAt(index);
      _applySortersAndFilters();
      return index;
    }
    return null;
  }

  @override
  void undoDeleteSaved(Item item, int index) {
    if (!hasData) return;
    _pendingDeletions.remove(_getItemKey(item));
    if (index >= 0 && index <= _currentObject!.mainData!.saved.length) {
      _currentObject!.mainData!.saved.insert(index, item);
    } else {
      _currentObject!.mainData!.saved.add(item);
    }
    _applySortersAndFilters();
  }

  @override
  Future<void> confirmDeleteSaved(Item item) async {
    _pendingDeletions.remove(_getItemKey(item));
    final result = await _mainUsecase.deleteSaved(item);
    result.fold(
      (failure) {
        _handlePopupError(failure);
        loadMainData();
      },
      (_) {
        _dataGlobalNotifier.notifyDataImported();
      },
    );
  }

  @override
  Future<void> moveToHistory(Item item) async {
    await _performItemOperation(
      () => _mainUsecase.moveToHistory(item),
      onSuccess: () {
        _removeFromTodoList(item);
        _removeFromFinishedList(item);
        _removeFromSavedList(item);
      },
    );
  }

  @override
  Future<void> deleteItemPermanently(Item item, ItemListType listType) async {
    final operation = listType == ItemListType.todo
        ? () => _mainUsecase.deleteTodo(item)
        : listType == ItemListType.finished
        ? () => _mainUsecase.deleteFinished(item)
        : () => _mainUsecase.deleteSaved(item);

    await _performItemOperation(
      operation,
      onSuccess: () {
        if (listType == ItemListType.todo) {
          _removeFromTodoList(item);
        } else if (listType == ItemListType.finished) {
          _removeFromFinishedList(item);
        } else {
          _removeFromSavedList(item);
        }
      },
    );
  }

  void _moveItemToFinished(Item item) {
    if (!hasData) return;
    _removeFromTodoList(item);
    _removeFromSavedList(item);
    _currentObject!.mainData!.finished.add(item);
  }

  void _moveItemToTodo(Item item) {
    if (!hasData) return;
    _removeFromFinishedList(item);
    _removeFromSavedList(item);
    _currentObject!.mainData!.todos.add(item);
  }

  void _moveItemToSaved(Item item) {
    if (!hasData) return;
    _removeFromTodoList(item);
    _removeFromFinishedList(item);
    _currentObject!.mainData!.saved.add(item);
  }

  void _removeFromTodoList(Item item) {
    if (!hasData) return;
    _currentObject!.mainData!.todos.removeWhere((i) => _isSameItem(i, item));
  }

  void _removeFromFinishedList(Item item) {
    if (!hasData) return;
    _currentObject!.mainData!.finished.removeWhere((i) => _isSameItem(i, item));
  }

  void _removeFromSavedList(Item item) {
    if (!hasData) return;
    _currentObject!.mainData!.saved.removeWhere((i) => _isSameItem(i, item));
  }

  bool _isSameItem(Item a, Item b) {
    return a.id == b.id && a.category == b.category;
  }

  @override
  MainObject? getCurrentMainData() => _currentObject;

  @override
  void dispose() {
    _mainDataController.close();
    _selectedCategoryController.close();
    _sortOptionController.close();
    _dataGlobalNotifier.removeListener(_silentRefresh);
    super.dispose();
  }

  @override
  Sink<MainObject?> get inputMainData => _mainDataController.sink;

  @override
  Sink<Category> get inputSelectedCategory => _selectedCategoryController.sink;

  @override
  Sink<SortOption> get inputSortOption => _sortOptionController.sink;

  @override
  Stream<MainObject?> get outputMainData => _mainDataController.stream;

  @override
  Stream<Category> get outputSelectedCategory =>
      _selectedCategoryController.stream;

  @override
  Stream<SortOption> get outputSortOption => _sortOptionController.stream;
}

abstract class MainViewModelInputs {
  Sink<MainObject?> get inputMainData;
  Sink<Category> get inputSelectedCategory;
  Sink<SortOption> get inputSortOption;

  void setCategory(Category category);
  void setSortOption(SortOption sortOption);

  Future<void> updateItem(Item item);

  Future<void> moveToFinished(Item item);
  Future<void> moveToTodo(Item item);
  Future<void> moveToHistory(Item item);
  Future<void> moveToSaved(Item item);

  MainObject? getCurrentMainData();

  int? deleteTodoTemporarily(Item item);
  void undoDeleteTodo(Item item, int index);
  Future<void> confirmDeleteTodo(Item item);

  int? deleteFinishedTemporarily(Item item);
  void undoDeleteFinished(Item item, int index);
  Future<void> confirmDeleteFinished(Item item);

  int? deleteSavedTemporarily(Item item);
  void undoDeleteSaved(Item item, int index);
  Future<void> confirmDeleteSaved(Item item);

  Future<void> deleteItemPermanently(Item item, ItemListType listType);
}

abstract class MainViewModelOutputs {
  Stream<MainObject?> get outputMainData;
  Stream<Category> get outputSelectedCategory;
  Stream<SortOption> get outputSortOption;
  bool get showSeriesTracker;
}
