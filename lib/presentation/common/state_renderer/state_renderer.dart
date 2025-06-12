import 'package:flutter/material.dart';
import 'package:noted/app/constants.dart';
import 'package:noted/presentation/resources/font_manager.dart';
import 'package:noted/presentation/resources/style_manager.dart';
import 'package:noted/presentation/resources/values_manager.dart';

enum StateRendererType {
  popupLoadingState,
  popupErrorState,
  popupSuccessState,

  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,
}

class StateRenderer extends StatelessWidget {
  final StateRendererType stateRendererType;
  final String message;
  final String title;
  final String? actionButtonTitle;
  final VoidCallback? onActionPressed;

  const StateRenderer({
    super.key,
    required this.stateRendererType,
    required this.message,
    this.title = Constants.empty,
    this.actionButtonTitle,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (stateRendererType.name.startsWith('popup')) {
      return _buildPopupDialog(context);
    } else {
      return _buildFullScreenWidget(context);
    }
  }

  List<Widget> _buildCommonContent(BuildContext context) {
    return [
      getmedia(context),
      _getMessage(message),
      if (actionButtonTitle != null && onActionPressed != null)
        _getActionButtton(context, actionButtonTitle!, onActionPressed!),
    ];
  }

  Widget _buildPopupDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      elevation: AppSize.s1_5,
      child: Container(
        padding: EdgeInsets.all(AppPadding.p18),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s14),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: AppSize.s12),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildCommonContent(context),
        ),
      ),
    );
  }

  Widget _buildFullScreenWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildCommonContent(context),
      ),
    );
  }

  Widget getmedia(BuildContext context) {
    Widget mediatype;
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
      case StateRendererType.fullScreenLoadingState:
        mediatype = SizedBox(
          width: AppSize.s40,
          height: AppSize.s40,
          child: CircularProgressIndicator(
            strokeWidth: AppSize.s3,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
        break;
      case StateRendererType.popupErrorState:
      case StateRendererType.fullScreenErrorState:
        mediatype = Icon(
          Icons.error,
          size: AppSize.s60,
          color: Theme.of(context).colorScheme.primary,
        );
        break;
      case StateRendererType.popupSuccessState:
        mediatype = Icon(
          Icons.done,
          size: AppSize.s60,
          color: Theme.of(context).colorScheme.primary,
        );
        break;
      case StateRendererType.fullScreenEmptyState:
        mediatype = Icon(
          Icons.error,
          size: AppSize.s40,
          color: Theme.of(context).colorScheme.primary,
        );
        break;
    }

    return mediatype;
  }

  Widget _getMessage(String message) {
    if (message.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p18,
        vertical: AppPadding.p8,
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: getRegularStyle(color: Colors.black, fontSize: FontSize.s18),
      ),
    );
  }

  Widget _getActionButtton(
    BuildContext context,
    String buttonTitle,
    VoidCallback onPressedAction,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppPadding.p18,
        right: AppPadding.p18,
        top: AppPadding.p18,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressedAction,
          child: Text(
            buttonTitle,
            style: getRegularStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: FontSize.s18,
            ),
          ),
        ),
      ),
    );
  }
}
