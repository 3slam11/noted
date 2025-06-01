import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';

typedef ContentWidgetBuilder = Widget Function(BuildContext context);
typedef RetryAction = void Function();

class StateFlowHandler extends StatefulWidget {
  final Stream<FlowState> stream;
  final ContentWidgetBuilder contentBuilder;
  final RetryAction? retryAction;
  final Widget? initialWidget;
  final String? retryButtonTitle;
  final String? popupDismissButtonTitle;

  const StateFlowHandler({
    super.key,
    required this.stream,
    required this.contentBuilder,
    this.retryAction,
    this.initialWidget,
    this.retryButtonTitle,
    this.popupDismissButtonTitle,
  });

  @override
  State<StateFlowHandler> createState() => _StateFlowHandlerState();
}

class _StateFlowHandlerState extends State<StateFlowHandler> {
  StreamSubscription<FlowState>? _subscription;
  FlowState? _currentState;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant StateFlowHandler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stream != oldWidget.stream) {
      _subscription?.cancel();
      _currentState = null;
      _error = null;
      _subscribe();
    }
  }

  void _subscribe() {
    _subscription = widget.stream.listen(
      _handleStateChange,
      onError: _handleError,
    );
  }

  void _handleStateChange(FlowState state) {
    if (!mounted) return;

    if (_isPopupState(state)) {
      _showDialog(state);
      return;
    }

    setState(() {
      _currentState = state;
      _error = null;
    });
  }

  void _handleError(Object error) {
    if (!mounted) return;

    setState(() {
      _error = error;
      _currentState = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Handle errors
    if (_error != null) {
      return _buildErrorState(_error.toString());
    }

    return _buildWidgetForState(_currentState);
  }

  Widget _buildWidgetForState(FlowState? state) {
    if (state == null || state is ContentState) {
      return state == null && widget.initialWidget != null
          ? widget.initialWidget!
          : widget.contentBuilder(context);
    }

    return _buildStateRenderer(state);
  }

  Widget _buildStateRenderer(FlowState state) {
    final stateType = _getStateRendererType(state);
    final message = _getStateMessage(state);

    if (state is LoadingState) {
      return StateRenderer(stateRendererType: stateType, message: message);
    }

    return StateRenderer(
      stateRendererType: stateType,
      message: message,
      actionButtonTitle: widget.retryButtonTitle ?? t.stateRenderer.retry,
      onActionPressed: widget.retryAction,
    );
  }

  Widget _buildErrorState(String error) {
    return StateRenderer(
      stateRendererType: StateRendererType.fullScreenErrorState,
      message: error,
      actionButtonTitle: widget.retryButtonTitle ?? t.stateRenderer.retry,
      onActionPressed: widget.retryAction,
    );
  }

  Future<void> _showDialog(FlowState state) async {
    if (!mounted) return;

    final stateType = _getStateRendererType(state);
    final message = _getStateMessage(state);
    final isLoading = stateType == StateRendererType.popupLoadingState;

    await showDialog<void>(
      context: context,
      barrierDismissible: !isLoading,
      useRootNavigator: true,
      builder:
          (context) => PopScope(
            canPop: !isLoading,
            child: StateRenderer(
              stateRendererType: stateType,
              message: message,
              actionButtonTitle:
                  isLoading
                      ? null
                      : (widget.popupDismissButtonTitle ?? t.stateRenderer.ok),
              onActionPressed:
                  isLoading ? null : () => Navigator.of(context).pop(),
            ),
          ),
    );
  }

  bool _isPopupState(FlowState? state) {
    if (state == null || state is ContentState) return false;

    final stateType = _getStateRendererType(state);
    return stateType.name.toLowerCase().startsWith('popup');
  }

  StateRendererType _getStateRendererType(FlowState state) {
    try {
      return state.getStateRendererType();
    } catch (e) {
      debugPrint("StateFlowHandler: Error getting state renderer type: $e");
      return StateRendererType.fullScreenErrorState;
    }
  }

  String _getStateMessage(FlowState state) {
    try {
      return state.getMessage();
    } catch (e) {
      debugPrint("StateFlowHandler: Error getting state message: $e");
      return 'An error occurred';
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
