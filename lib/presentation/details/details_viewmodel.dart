import 'dart:async';
import 'package:noted/app/app_events.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/usecases/details_usecase.dart';
import 'package:noted/domain/usecases/recommendations_usecase.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class DetailsViewModel extends BaseViewModel
    implements DetailsViewModelInputs, DetailsViewModelOutputs {
  final DetailsUsecase _itemDetailsUseCase;
  final RecommendationsUsecase _recommendationsUsecase;
  final DataGlobalNotifier _dataGlobalNotifier;

  DetailsViewModel(
    this._itemDetailsUseCase,
    this._recommendationsUsecase,
    this._dataGlobalNotifier,
  );

  final _itemDetailsStreamController = BehaviorSubject<Details>();
  final _recommendationsStreamController = BehaviorSubject<List<SearchItem>>();
  final _recommendationsStateStreamController = BehaviorSubject<FlowState>();
  final _localItemStreamController = BehaviorSubject<Item?>();

  @override
  void start() {}

  @override
  void dispose() {
    _itemDetailsStreamController.close();
    _recommendationsStreamController.close();
    _recommendationsStateStreamController.close();
    _localItemStreamController.close();
    super.dispose();
  }

  @override
  Future<void> loadItemDetails(String id, Category category) async {
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState),
    );

    (await _itemDetailsUseCase.execute(DetailsInput(id, category))).fold(
      (failure) {
        inputState.add(
          ErrorState(
            stateRendererType: StateRendererType.fullScreenErrorState,
            message: failure.message,
          ),
        );
      },
      (details) {
        inputState.add(ContentState());
        inputItemDetails.add(details);
        loadRecommendations(id, category);
        _loadLocalItemDetails(id, category);
      },
    );
  }

  Future<void> _loadLocalItemDetails(String id, Category category) async {
    (await _itemDetailsUseCase.getLocalItem(DetailsInput(id, category))).fold(
      (failure) {
        inputLocalItem.add(null);
      },
      (localItem) {
        inputLocalItem.add(localItem);
      },
    );
  }

  Future<void> loadRecommendations(String id, Category category) async {
    inputRecommendationsState.add(
      LoadingState(stateRendererType: StateRendererType.popupLoadingState),
    );

    (await _recommendationsUsecase.execute(DetailsInput(id, category))).fold(
      (failure) {
        inputRecommendationsState.add(
          ErrorState(
            stateRendererType: StateRendererType.popupErrorState,
            message: failure.message,
          ),
        );
      },
      (recommendations) {
        inputRecommendationsState.add(ContentState());
        inputRecommendations.add(recommendations);
      },
    );
  }

  @override
  Future<void> updateTracking({int? season, int? episode}) async {
    final currentItem = _localItemStreamController.valueOrNull;
    if (currentItem == null) return;

    final updatedItem = currentItem.copyWith(
      currentSeason: season,
      currentEpisode: episode,
    );

    (await _itemDetailsUseCase.updateItem(updatedItem)).fold(
      (failure) {
        inputState.add(
          ErrorState(
            stateRendererType: StateRendererType.popupErrorState,
            message: failure.message,
          ),
        );
      },
      (_) {
        inputLocalItem.add(updatedItem);
        _dataGlobalNotifier.notifyDataImported();
      },
    );
  }

  @override
  Future<void> addItemToList(ItemListType listType) async {
    final details = _itemDetailsStreamController.valueOrNull;
    if (details == null) return;

    final item = Item(
      details.id,
      details.title,
      details.category,
      details.imageUrls.isNotEmpty ? details.imageUrls.first : null,
      details.releaseDate,
      dateAdded: DateTime.now(),
    );

    final result = listType == ItemListType.todo
        ? await _itemDetailsUseCase.addToTodo(item)
        : await _itemDetailsUseCase.addToSaved(item);

    result.fold(
      (failure) {
        inputState.add(
          ErrorState(
            stateRendererType: StateRendererType.popupErrorState,
            message: failure.message,
          ),
        );
      },
      (_) {
        inputLocalItem.add(item);
        _dataGlobalNotifier.notifyDataImported();
      },
    );
  }

  @override
  Sink<Details> get inputItemDetails => _itemDetailsStreamController.sink;

  @override
  Sink<List<SearchItem>> get inputRecommendations =>
      _recommendationsStreamController.sink;

  @override
  Sink<FlowState> get inputRecommendationsState =>
      _recommendationsStateStreamController.sink;

  @override
  Sink<Item?> get inputLocalItem => _localItemStreamController.sink;

  @override
  Stream<Details> get outputItemDetails => _itemDetailsStreamController.stream;

  @override
  Stream<List<SearchItem>> get outputRecommendations =>
      _recommendationsStreamController.stream;

  @override
  Stream<FlowState> get outputRecommendationsState =>
      _recommendationsStateStreamController.stream;

  @override
  Stream<Item?> get outputLocalItem => _localItemStreamController.stream;
}

abstract class DetailsViewModelInputs {
  Sink<Details> get inputItemDetails;
  Sink<List<SearchItem>> get inputRecommendations;
  Sink<FlowState> get inputRecommendationsState;
  Sink<Item?> get inputLocalItem;

  Future<void> loadItemDetails(String id, Category category);
  Future<void> updateTracking({int? season, int? episode});
  Future<void> addItemToList(ItemListType listType);
}

abstract class DetailsViewModelOutputs {
  Stream<Details> get outputItemDetails;
  Stream<List<SearchItem>> get outputRecommendations;
  Stream<FlowState> get outputRecommendationsState;
  Stream<Item?> get outputLocalItem;
}
