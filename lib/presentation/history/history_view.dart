import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noted/app/di.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/state_renderer/state_flow_handler.dart';
import 'package:noted/presentation/common/widgets/empty_state_widget.dart';
import 'package:noted/presentation/common/widgets/item_tile.dart';
import 'package:noted/presentation/history/history_view_model.dart';
import 'package:noted/presentation/resources/values_manager.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  HistoryViewState createState() => HistoryViewState();
}

class HistoryViewState extends State<HistoryView> {
  late final HistoryViewModel _viewModel = instance<HistoryViewModel>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel.start();
  }

  void toggleFilter() {
    _viewModel.toggleFilter();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // QOL: Scroll to top
  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StateFlowHandler(
      stream: _viewModel.outputState,
      retryAction: () {
        _viewModel.loadHistoryItems();
      },
      contentBuilder: (context) => _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return StreamBuilder<bool>(
      stream: _viewModel.outputShowFilterToggle,
      builder: (context, showToggleSnapshot) {
        final showToggle = showToggleSnapshot.data ?? true;
        return StreamBuilder<bool>(
          stream: _viewModel.outputIsFilterVisible,
          builder: (context, isVisibleSnapshot) {
            final isVisible = isVisibleSnapshot.data ?? true;
            final shouldShowFilter = !showToggle || isVisible;

            return Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: shouldShowFilter
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCategoryFilter(),
                              const SizedBox(height: AppSize.s20),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(child: _buildHistoryListSection()),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryFilter() {
    return StreamBuilder<Category>(
      stream: _viewModel.outputSelectedCategory,
      builder: (context, snapshot) {
        final selectedCategory = snapshot.data ?? Category.all;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: AppPadding.p8),
                child: StreamBuilder<bool>(
                  stream: _viewModel.outputIsAscending,
                  builder: (context, ascSnapshot) {
                    final isAscending = ascSnapshot.data ?? false;
                    return StreamBuilder<SortOption>(
                      stream: _viewModel.outputSortOption,
                      builder: (context, sortSnapshot) {
                        final selectedOption =
                            sortSnapshot.data ?? SortOption.dateAdded;
                        return PopupMenuButton<SortOption>(
                          initialValue: selectedOption,
                          onSelected: (option) {
                            _viewModel.setSortOption(option);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Theme.of(context).colorScheme.surface,
                          offset: const Offset(0, 40),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.sort_rounded,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  selectedOption.localizedName(),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  isAscending
                                      ? Icons.arrow_downward_rounded
                                      : Icons.arrow_upward_rounded,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                          itemBuilder: (context) =>
                              SortOption.values.map((option) {
                                final isSelected = option == selectedOption;
                                return PopupMenuItem<SortOption>(
                                  value: option,
                                  child: Row(
                                    children: [
                                      Text(
                                        option.localizedName(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: isSelected
                                                  ? Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                  : null,
                                            ),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 8),
                                        Icon(
                                          isAscending
                                              ? Icons.arrow_downward_rounded
                                              : Icons.arrow_upward_rounded,
                                          size: 16,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    );
                  },
                ),
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
              ...Category.values.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppPadding.p8),
                  child:
                      ChoiceChip(
                            label: Text(category.localizedCategory()),
                            selected: selectedCategory == category,
                            showCheckmark: false,
                            onSelected: (selected) {
                              if (selected) {
                                _viewModel.setCategory(category);
                              }
                            },
                            selectedColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelStyle: TextStyle(
                              color: selectedCategory == category
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: selectedCategory == category
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            checkmarkColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                          )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: -0.2, end: 0)
                          .then()
                          .animate(target: selectedCategory == category ? 1 : 0)
                          .scale(
                            begin: const Offset(1.0, 1.0),
                            end: const Offset(1.05, 1.05),
                            duration: 200.ms,
                          ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryListSection() {
    return StreamBuilder<List<Item>>(
      stream: _viewModel.outputHistoryItems,
      builder: (context, itemsSnapshot) {
        final allItems = itemsSnapshot.data;

        if (allItems == null &&
            itemsSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (allItems == null || allItems.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.history_edu_outlined,
            message: t.history.noHistory,
          );
        }
        return StreamBuilder<Category>(
          stream: _viewModel.outputSelectedCategory,
          builder: (context, categorySnapshot) {
            final selectedCategory = categorySnapshot.data ?? Category.all;

            final filteredItems = allItems.where((item) {
              if (selectedCategory == Category.all) return true;
              return item.category == selectedCategory;
            }).toList();

            if (filteredItems.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.history_edu_outlined,
                message: t.history.noHistory,
              );
            }

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppSize.s20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCategory.localizedCategory(),
                          style: TextStyle(
                            fontSize: AppSize.s20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${filteredItems.length} ${filteredItems.length == 1 ? t.history.item : t.history.items}',
                          style: TextStyle(
                            fontSize: AppSize.s16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(180),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary.withAlpha(128),
                    thickness: 1,
                    indent: AppPadding.p16,
                    endIndent: AppPadding.p16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      primary: false,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p8,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ItemTile(
                          item: item,
                          currentList: ItemListType.history,
                          showSeriesTracker: _viewModel.showSeriesTracker,
                          cardColor: Theme.of(context).colorScheme.onPrimary,
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p16,
                            vertical: AppPadding.p6,
                          ),
                          onSwipeDismiss:
                              _viewModel.deleteHistoryItemTemporarily,
                          onUndoSwipe: _viewModel.undoDeleteHistoryItem,
                          onConfirmSwipe: _viewModel.confirmDeleteHistoryItem,
                          onMoveToTodo: () => _viewModel.moveToTodo(item),
                          onMoveToFinished: () =>
                              _viewModel.moveToFinished(item),
                          onMoveToSaved: () => _viewModel.moveToSaved(item),
                          onDeletePermanently: () =>
                              _viewModel.deleteHistoryItem(item),
                          onEdit: (updatedItem) =>
                              _viewModel.updateItem(updatedItem),
                        ).animate().fadeIn(duration: 300.ms);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
