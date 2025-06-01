// presentation/history/viewModel/history_viewmodel.dart
import 'dart:async';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/usecases/history_usecase.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class HistoryViewModel extends BaseViewModel
    implements HistoryViewModelInputs, HistoryViewModelOutputs {
  final BehaviorSubject<List<Item>> historyController =
      BehaviorSubject<List<Item>>();

  final BehaviorSubject<Category> selectedCategoryController =
      BehaviorSubject<Category>.seeded(Category.all);

  final BehaviorSubject<List<Item>> historyFilteredController =
      BehaviorSubject<List<Item>>();

  final HistoryUsecase historyUsecase;
  HistoryViewModel(this.historyUsecase);

  @override
  void start() {
    loadHistoryItems();
  }

  @override
  Future<void> loadHistoryItems() async {
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    );

    (await historyUsecase.execute(null)).fold(
      (failure) {
        inputState.add(
          ErrorState(
            stateRendererType: StateRendererType.fullScreenErrorState,
            message: failure.message,
          ),
        );
        historyController.add([]);
      },
      (historyObject) {
        final historyItems = historyObject;
        historyController.add(historyItems);
        inputState.add(ContentState());
      },
    );
  }

  @override
  void setCategory(Category category) {
    selectedCategoryController.add(category);
  }

  @override
  void dispose() {
    historyController.close();
    selectedCategoryController.close();
    historyFilteredController.close();
    super.dispose();
  }

  // --- Inputs ---
  @override
  Sink<Category> get inputSelectedCategory => selectedCategoryController.sink;

  // --- Outputs ---
  @override
  Stream<List<Item>> get outputHistoryItems => historyController.stream;

  @override
  Stream<Category> get outputSelectedCategory =>
      selectedCategoryController.stream;
}

abstract class HistoryViewModelInputs {
  Sink<Category> get inputSelectedCategory;
  void setCategory(Category category);
  Future<void> loadHistoryItems();
}

abstract class HistoryViewModelOutputs {
  Stream<List<Item>> get outputHistoryItems;
  Stream<Category> get outputSelectedCategory;
}
