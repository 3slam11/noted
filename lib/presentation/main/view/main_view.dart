import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/app/di.dart';
import 'package:noted/app/functions.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/state_renderer/state_flow_handler.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:noted/presentation/common/widgets/category_filter_widget.dart';
import 'package:noted/presentation/common/widgets/finished_section_widget.dart';
import 'package:noted/presentation/common/widgets/new_month_dialog.dart';
import 'package:noted/presentation/common/widgets/todo_section_widget.dart';
import 'package:noted/presentation/main/viewModel/main_view_model.dart';
import 'package:noted/presentation/settings/view/settings_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  final MainViewModel viewModel = instance<MainViewModel>();
  final AppPrefs appPrefs = instance<AppPrefs>();

  @override
  void initState() {
    super.initState();
    viewModel.start();
    WidgetsBinding.instance.addPostFrameCallback((_) => monthChecker());
  }

  Future<void> timeBackwards(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            t.home.timeWrong,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
            maxLines: 2,
          ),
          content: Text(
            t.home.timeWrongDescription,
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(t.home.continueAnyway),
            ),
          ],
        );
      },
    );
  }

  Future<void> monthChecker() async {
    final monthCheckResult = await checkForNewMonth();

    if (!mounted) return;

    switch (monthCheckResult) {
      case 1:
        break;
      case 2:
        await timeBackwards(context);
        break;
      case 3:
        await handleNewMonth();
        break;
    }
  }

  Future<void> handleNewMonth() async {
    // Ensure data is loaded before proceeding
    if (viewModel.getCurrentMainData() == null) {
      final completer = Completer<void>();
      final subscription = viewModel.outputState.listen((state) {
        if (state is ContentState || state is ErrorState) {
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
      });
      viewModel.start();
      await completer.future;
      subscription.cancel();
    }

    final currentMainData = viewModel.getCurrentMainData();
    if (currentMainData == null || currentMainData.mainData == null) {
      debugPrint('Error: Main data not available for new month handling.');
      viewModel.start();
      return;
    }

    final behaviorIndex = await appPrefs.getMonthRolloverBehavior();
    final behavior = MonthRolloverBehavior.values[behaviorIndex];

    final List<Item> finishedItemsFromLastMonth = List<Item>.from(
      currentMainData.mainData?.finished ?? [],
    );

    // Move finished items to history for both full and partial rollover
    for (final item in finishedItemsFromLastMonth) {
      await viewModel.moveToHistory(item);
    }

    // Handle to-do items based on the selected behavior
    if (behavior == MonthRolloverBehavior.full) {
      final List<Item> allUnfinishedItemsFromLastMonth = List<Item>.from(
        currentMainData.mainData?.todos ?? [],
      );

      if (!mounted) return;
      final List<Item>? itemsToKeepForNewMonth = await showDialog<List<Item>>(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            NewMonthDialog(unfinishedItems: allUnfinishedItemsFromLastMonth),
      );

      if (itemsToKeepForNewMonth != null) {
        final Set<String> idsToKeep = itemsToKeepForNewMonth
            .map((item) => '${item.id}-${item.category?.name}')
            .toSet();

        for (final oldItem in allUnfinishedItemsFromLastMonth) {
          final oldItemKey = '${oldItem.id}-${oldItem.category?.name}';
          if (!idsToKeep.contains(oldItemKey)) {
            await viewModel.confirmDeleteTodo(oldItem);
          }
        }
      }
    }
    // For partial rollover, we do nothing with the to-do list.

    viewModel.start();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StateFlowHandler(
      stream: viewModel.outputState,
      retryAction: viewModel.start,
      contentBuilder: (context) => _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterAndSortControls(
              context,
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 20),
            TodoSectionWidget(
              viewModel: viewModel,
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: 8),
            FinishedSectionWidget(
              viewModel: viewModel,
            ).animate().fadeIn(duration: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterAndSortControls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [CategoryFilterWidget(viewModel: viewModel)],
    );
  }
}
