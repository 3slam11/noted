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

  final HistoryUsecase _historyUsecase;
  final DataGlobalNotifier _dataGlobalNotifier;

  HistoryViewModel(this._historyUsecase, this._dataGlobalNotifier);

  @override
  void start() {
    loadHistoryItems();
  }

  @override
  Future<void> loadHistoryItems() async {
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    );

    (await _historyUsecase.execute(null)).fold(
      (failure) {
        inputState.add(
          ErrorState(
            stateRendererType: StateRendererType.fullScreenErrorState,
            message: failure.message,
          ),
        );
        _historyController.add([]);
      },
      (historyItems) {
        _historyController.add(historyItems);
        inputState.add(ContentState());
      },
    );
  }

  @override
  void setCategory(Category category) {
    _selectedCategoryController.add(category);
  }

  bool _isSameItem(Item a, Item b) => a.id == b.id && a.category == b.category;

  void _removeItemFromUI(Item item) {
    final currentItems = _historyController.valueOrNull ?? [];
    currentItems.removeWhere((i) => _isSameItem(i, item));
    _historyController.add(List.from(currentItems));
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
      currentItems.removeAt(index);
      _historyController.add(List.from(currentItems));
      return index;
    }
    return null;
  }

  @override
  void undoDeleteHistoryItem(Item item, int index) {
    final currentItems = _historyController.valueOrNull;
    if (currentItems == null) return;

    if (index >= 0 && index <= currentItems.length) {
      currentItems.insert(index, item);
      _historyController.add(List.from(currentItems));
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
      final currentItems = _historyController.valueOrNull ?? [];
      final index = currentItems.indexWhere((i) => _isSameItem(i, updatedItem));
      if (index != -1) {
        currentItems[index] = updatedItem;
        _historyController.add(List.from(currentItems));
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
    super.dispose();
  }

  @override
  Sink<Category> get inputSelectedCategory => _selectedCategoryController.sink;

  @override
  Stream<List<Item>> get outputHistoryItems => _historyController.stream;

  @override
  Stream<Category> get outputSelectedCategory =>
      _selectedCategoryController.stream;
}

abstract class HistoryViewModelInputs {
  Sink<Category> get inputSelectedCategory;
  void setCategory(Category category);
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
}
