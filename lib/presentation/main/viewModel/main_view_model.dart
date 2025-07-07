import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:noted/app/app_events.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/usecases/main_usecase.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:noted/presentation/main/view/main_view.dart';
import 'package:rxdart/rxdart.dart';

class MainViewModel extends BaseViewModel
    implements MainViewModelInputs, MainViewModelOutputs {
  final MainUsecase _mainUsecase;
  final DataGlobalNotifier _dataGlobalNotifier;

  final BehaviorSubject<MainObject?> _mainDataController =
      BehaviorSubject<MainObject?>();
  final BehaviorSubject<Category> _selectedCategoryController =
      BehaviorSubject<Category>.seeded(Category.all);
  final BehaviorSubject<SortOption> _sortOptionController =
      BehaviorSubject<SortOption>.seeded(SortOption.dateAddedNewest);

  MainObject? _currentObject;

  MainViewModel(this._mainUsecase, this._dataGlobalNotifier) {
    _dataGlobalNotifier.addListener(loadMainData);
  }

  bool get hasData => _currentObject?.mainData != null;

  @override
  void start() {
    loadMainData();
  }

  Future<void> loadMainData() async {
    _setLoadingState();

    final result = await _mainUsecase.execute(null);
    result.fold(
      (failure) {
        inputState.add(
          ErrorState(
            stateRendererType: StateRendererType.fullScreenErrorState,
            message: failure.message,
          ),
        );
        _currentObject = null;
        _mainDataController.add(null);
      },
      (mainObject) {
        _currentObject = mainObject;
        _applySortersAndFilters();
        inputState.add(ContentState());
      },
    );
  }

  void _applySortersAndFilters() {
    if (_currentObject?.mainData == null) {
      _mainDataController.add(_currentObject);
      return;
    }

    final currentSortOption = _sortOptionController.value;

    final sortedTodos = _sortItems(
      _currentObject!.mainData!.todos,
      currentSortOption,
    );
    final sortedFinished = _sortItems(
      _currentObject!.mainData!.finished,
      currentSortOption,
    );

    final newMainData = TaskData(sortedTodos, sortedFinished);
    _mainDataController.add(MainObject(newMainData));
  }

  List<Item> _sortItems(List<Item> items, SortOption sortOption) {
    List<Item> sortedList = List.from(items);

    int compareStrings(String? a, String? b) {
      return (a ?? '').toLowerCase().compareTo((b ?? '').toLowerCase());
    }

    int compareDates(DateTime? a, DateTime? b) {
      if (a == null && b == null) return 0;
      if (a == null) return 1; // Nulls last
      if (b == null) return -1; // Nulls last
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

    int compareRatings(double? a, double? b) {
      return (b ?? 0.0).compareTo(a ?? 0.0); // Descending (b vs a)
    }

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

  void _setLoadingState() {
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    );
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

      // Update item in 'todos' list
      final todoIndex = _currentObject!.mainData!.todos.indexWhere(
        (i) => _isSameItem(i, updatedItem),
      );
      if (todoIndex != -1) {
        _currentObject!.mainData!.todos[todoIndex] = updatedItem;
      }

      // Update item in 'finished' list
      final finishedIndex = _currentObject!.mainData!.finished.indexWhere(
        (i) => _isSameItem(i, updatedItem),
      );
      if (finishedIndex != -1) {
        _currentObject!.mainData!.finished[finishedIndex] = updatedItem;
      }

      _applySortersAndFilters();
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
  int? deleteTodoTemporarily(Item item) {
    if (!hasData) return null;
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
    if (index >= 0 && index <= _currentObject!.mainData!.todos.length) {
      _currentObject!.mainData!.todos.insert(index, item);
      _applySortersAndFilters();
    }
  }

  @override
  Future<void> confirmDeleteTodo(Item item) async {
    final result = await _mainUsecase.deleteTodo(item);
    result.fold(
      (failure) {
        _handlePopupError(failure);
        loadMainData(); // On failure, restore state by reloading
      },
      (_) {
        // On success, do nothing. The UI and ViewModel state are already correct.
      },
    );
  }

  @override
  int? deleteFinishedTemporarily(Item item) {
    if (!hasData) return null;
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
    if (index >= 0 && index <= _currentObject!.mainData!.finished.length) {
      _currentObject!.mainData!.finished.insert(index, item);
      _applySortersAndFilters();
    }
  }

  @override
  Future<void> confirmDeleteFinished(Item item) async {
    final result = await _mainUsecase.deleteFinished(item);
    result.fold(
      (failure) {
        _handlePopupError(failure);
        loadMainData(); // On failure, restore state by reloading
      },
      (_) {
        // On success, do nothing. The UI and ViewModel state are already correct.
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
      },
    );
  }

  @override
  Future<void> deleteItemPermanently(Item item, ItemListType listType) async {
    final operation = listType == ItemListType.todo
        ? () => _mainUsecase.deleteTodo(item)
        : () => _mainUsecase.deleteFinished(item);

    await _performItemOperation(
      operation,
      onSuccess: () {
        if (listType == ItemListType.todo) {
          _removeFromTodoList(item);
        } else {
          _removeFromFinishedList(item);
        }
      },
    );
  }

  void _moveItemToFinished(Item item) {
    if (!hasData) return;
    _removeFromTodoList(item);
    _currentObject!.mainData!.finished.add(item);
  }

  void _moveItemToTodo(Item item) {
    if (!hasData) return;
    _removeFromFinishedList(item);
    _currentObject!.mainData!.todos.add(item);
  }

  void _removeFromTodoList(Item item) {
    if (!hasData) return;
    _currentObject!.mainData!.todos.removeWhere((i) => _isSameItem(i, item));
  }

  void _removeFromFinishedList(Item item) {
    if (!hasData) return;
    _currentObject!.mainData!.finished.removeWhere((i) => _isSameItem(i, item));
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
    _dataGlobalNotifier.removeListener(loadMainData);
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

  // Item update action
  Future<void> updateItem(Item item);

  // Item movement actions
  Future<void> moveToFinished(Item item);
  Future<void> moveToTodo(Item item);
  Future<void> moveToHistory(Item item);

  MainObject? getCurrentMainData();

  // Deletion with Undo flow for To-Do list
  int? deleteTodoTemporarily(Item item);
  void undoDeleteTodo(Item item, int index);
  Future<void> confirmDeleteTodo(Item item);

  // Deletion with Undo flow for Finished list
  int? deleteFinishedTemporarily(Item item);
  void undoDeleteFinished(Item item, int index);
  Future<void> confirmDeleteFinished(Item item);

  // Permanent deletion from dialog
  Future<void> deleteItemPermanently(Item item, ItemListType listType);
}

abstract class MainViewModelOutputs {
  Stream<MainObject?> get outputMainData;
  Stream<Category> get outputSelectedCategory;
  Stream<SortOption> get outputSortOption;
}
