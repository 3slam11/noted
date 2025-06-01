import 'package:noted/app/constants.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

class LoadingState extends FlowState {
  final StateRendererType stateRendererType;
  final String message;

  LoadingState({required this.stateRendererType, String? message})
    : assert(
        stateRendererType == StateRendererType.popupLoadingState ||
            stateRendererType == StateRendererType.fullScreenLoadingState,
      ),
      message = message ?? t.stateRenderer.loading;

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

class ErrorState extends FlowState {
  final StateRendererType stateRendererType;
  final String message;

  ErrorState({required this.stateRendererType, required this.message})
    : assert(
        stateRendererType == StateRendererType.popupErrorState ||
            stateRendererType == StateRendererType.fullScreenErrorState,
      );

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => Constants.empty;

  @override
  StateRendererType getStateRendererType() {
    throw UnimplementedError();
  }
}

class SuccessState extends FlowState {
  final StateRendererType stateRendererType;
  final String message;

  SuccessState({required this.stateRendererType, required this.message})
    : assert(stateRendererType == StateRendererType.popupSuccessState);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

class EmptyState extends FlowState {
  final StateRendererType stateRendererType;
  final String message;

  EmptyState({required this.stateRendererType, required this.message})
    : assert(stateRendererType == StateRendererType.fullScreenEmptyState);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}
