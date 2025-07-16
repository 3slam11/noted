import 'dart:async';
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

  DetailsViewModel(this._itemDetailsUseCase, this._recommendationsUsecase);

  final _itemDetailsStreamController = BehaviorSubject<Details>();
  final _recommendationsStreamController = BehaviorSubject<List<SearchItem>>();
  final _recommendationsStateStreamController = BehaviorSubject<FlowState>();

  @override
  void start() {}

  @override
  void dispose() {
    _itemDetailsStreamController.close();
    _recommendationsStreamController.close();
    _recommendationsStateStreamController.close();
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

  // Inputs
  @override
  Sink<Details> get inputItemDetails => _itemDetailsStreamController.sink;

  @override
  Sink<List<SearchItem>> get inputRecommendations =>
      _recommendationsStreamController.sink;

  @override
  Sink<FlowState> get inputRecommendationsState =>
      _recommendationsStateStreamController.sink;

  // Outputs
  @override
  Stream<Details> get outputItemDetails => _itemDetailsStreamController.stream;

  @override
  Stream<List<SearchItem>> get outputRecommendations =>
      _recommendationsStreamController.stream;

  @override
  Stream<FlowState> get outputRecommendationsState =>
      _recommendationsStateStreamController.stream;
}

abstract class DetailsViewModelInputs {
  Sink<Details> get inputItemDetails;
  Sink<List<SearchItem>> get inputRecommendations;
  Sink<FlowState> get inputRecommendationsState;

  Future<void> loadItemDetails(String id, Category category);
}

abstract class DetailsViewModelOutputs {
  Stream<Details> get outputItemDetails;
  Stream<List<SearchItem>> get outputRecommendations;
  Stream<FlowState> get outputRecommendationsState;
}
