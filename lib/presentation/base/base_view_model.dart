import 'dart:async';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    implements BaseViewModelOutpus {
  // vars and funcs we will use through any view model.

  final StreamController _inputStreamController = BehaviorSubject<FlowState>();

  @override
  Sink get inputState => _inputStreamController.sink;

  @override
  Stream<FlowState> get outputState =>
      _inputStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _inputStreamController.close();
  }
}

abstract class BaseViewModelInputs {
  void start(); // start the view model

  void dispose(); // deletes any left operation

  Sink get inputState;
}

abstract class BaseViewModelOutpus {
  Stream<FlowState> get outputState;
}
