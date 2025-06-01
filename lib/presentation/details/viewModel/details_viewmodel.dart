import 'dart:async';
import 'package:noted/domain/model/models.dart';
import 'package:noted/domain/usecases/details_usecase.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class DetailsViewModel extends BaseViewModel
    implements DetailsViewModelInputs, DetailsViewModelOutputs {
  final DetailsUsecase _itemDetailsUseCase;

  DetailsViewModel(this._itemDetailsUseCase);

  final StreamController<Details> _itemDetailsStreamController =
      BehaviorSubject<Details>();

  @override
  void start() {}

  @override
  void dispose() {
    _itemDetailsStreamController.close();
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
      },
    );
  }

  // Inputs
  @override
  Sink<Details> get inputItemDetails => _itemDetailsStreamController.sink;

  // Outputs
  @override
  Stream<Details> get outputItemDetails => _itemDetailsStreamController.stream;
}

abstract class DetailsViewModelInputs {
  Sink<Details> get inputItemDetails;

  Future<void> loadItemDetails(String id, Category category);
}

abstract class DetailsViewModelOutputs {
  Stream<Details> get outputItemDetails;
}
