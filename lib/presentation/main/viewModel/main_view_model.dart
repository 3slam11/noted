import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:noted/app/app_events.dart';
import 'package:noted/data/network/failure.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/usecases/main_usecase.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class MainViewModel extends BaseViewModel
    implements MainViewModelInputs, MainViewModelOutputs {
  // Dependencies
  final MainUsecase _mainUsecase;
  final DataGlobalNotifier _dataGlobalNotifier;

  // Stream controllers
  final BehaviorSubject<MainObject?> _mainDataController =
      BehaviorSubject<MainObject?>();
  final BehaviorSubject<Category> _selectedCategoryController =
      BehaviorSubject<Category>.seeded(Category.all);

  // State
  MainObject? _currentObject;

  MainViewModel(this._mainUsecase, this._dataGlobalNotifier) {
    _dataGlobalNotifier.addListener(loadMainData);
  }

  // Getters for current state
  MainObject? get currentObject => _currentObject;
  bool get hasData => _currentObject?.mainData != null;

  @override
  void start() {
    loadMainData();
  }

  // Private methods
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
        final currentObject = mainObject;
        _mainDataController.add(currentObject);
        inputState.add(ContentState());
      },
    );
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
    Future<Either<Failure, void>> Function() operation,
    void Function() onSuccess,
  ) async {
    final result = await operation();
    result.fold(_handlePopupError, (_) {
      if (hasData) {
        operation();
        inputMainData.add(_currentObject);
      } else {
        loadMainData();
      }
    });
  }

  // Public interface methods
  @override
  void setCategory(Category category) {
    _selectedCategoryController.add(category);
  }

  @override
  Future<void> moveToFinished(Item item) async {
    await _performItemOperation(
      () => _mainUsecase.moveToFinished(item),
      () => _moveItemToFinished(item),
    );
  }

  @override
  Future<void> moveToTodo(Item item) async {
    await _performItemOperation(
      () => _mainUsecase.moveToTodo(item),
      () => _moveItemToTodo(item),
    );
  }

  @override
  Future<void> deleteTodo(Item item) async {
    await _performItemOperation(
      () => _mainUsecase.deleteTodo(item),
      () => loadMainData(),
    );
  }

  @override
  Future<void> deleteFinished(Item item) async {
    await _performItemOperation(
      () => _mainUsecase.deleteFinished(item),
      () => loadMainData(),
    );
  }

  @override
  Future<void> moveToHistory(Item item) async {
    await _performItemOperation(
      () => _mainUsecase.moveToHistory(item),
      () => _removeFromBothLists(item),
    );
  }

  // Local state manipulation methods
  void _moveItemToFinished(Item item) {
    final todos = _currentObject!.mainData!.todos;
    final finished = _currentObject!.mainData!.finished;

    todos.removeWhere((i) => _isSameItem(i, item));
    finished.add(item);
  }

  void _moveItemToTodo(Item item) {
    final todos = _currentObject!.mainData!.todos;
    final finished = _currentObject!.mainData!.finished;

    finished.removeWhere((i) => _isSameItem(i, item));
    todos.add(item);
  }

  void _removeFromBothLists(Item item) {
    final mainData = _currentObject!.mainData!;
    mainData.todos.removeWhere((i) => _isSameItem(i, item));
    mainData.finished.removeWhere((i) => _isSameItem(i, item));
  }

  bool _isSameItem(Item a, Item b) {
    return a.id == b.id && a.category == b.category;
  }

  @override
  MainObject? getCurrentMainData() => _currentObject;

  // Resource management
  @override
  void dispose() {
    _mainDataController.close();
    _selectedCategoryController.close();
    super.dispose();
  }

  // Stream interfaces
  @override
  Sink<MainObject?> get inputMainData => _mainDataController.sink;

  @override
  Sink<Category> get inputSelectedCategory => _selectedCategoryController.sink;

  @override
  Stream<MainObject?> get outputMainData => _mainDataController.stream;

  @override
  Stream<Category> get outputSelectedCategory =>
      _selectedCategoryController.stream;
}

// Interfaces remain the same but with better documentation
abstract class MainViewModelInputs {
  /// Input stream for main data updates
  Sink<MainObject?> get inputMainData;

  /// Input stream for category selection
  Sink<Category> get inputSelectedCategory;

  /// Set the active category filter
  void setCategory(Category category);

  /// Move an item from todo to finished list
  Future<void> moveToFinished(Item item);

  /// Move an item from finished to todo list
  Future<void> moveToTodo(Item item);

  /// Delete an item from todo list
  Future<void> deleteTodo(Item item);

  /// Delete an item from finished list
  Future<void> deleteFinished(Item item);

  /// Move an item to history (remove from both lists)
  Future<void> moveToHistory(Item item);

  /// Get current main data snapshot
  MainObject? getCurrentMainData();
}

abstract class MainViewModelOutputs {
  /// Stream of main data updates
  Stream<MainObject?> get outputMainData;

  /// Stream of selected category updates
  Stream<Category> get outputSelectedCategory;
}
