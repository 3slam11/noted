import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:noted/app/di.dart';
import 'package:noted/app/functions.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/state_renderer/state_flow_handler.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:noted/presentation/details/view/details_view.dart';
import 'package:noted/presentation/main/viewModel/main_view_model.dart';
import 'package:noted/presentation/resources/routes_manager.dart';
import 'package:noted/presentation/resources/values_manager.dart';

enum ItemListType { todo, finished, history }

class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  final MainViewModel viewModel = instance<MainViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.start();
    monthChecker();
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

    final List<Item> allUnfinishedItemsFromLastMonth = List<Item>.from(
      currentMainData.mainData?.todos ?? [],
    );
    final List<Item> finishedItemsFromLastMonth = List<Item>.from(
      currentMainData.mainData?.finished ?? [],
    );

    for (final item in finishedItemsFromLastMonth) {
      await viewModel.moveToHistory(item);
    }

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

    viewModel.start();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: Text(t.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(RoutesManager.settingsRoute);
            },
          ),
        ],
      ),
      body: StateFlowHandler(
        stream: viewModel.outputState,
        retryAction: viewModel.start,
        contentBuilder: (context) => _getContentWidget(),
      ),
    );
  }

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryFilterWidget(
              viewModel: viewModel,
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
}

class CategoryFilterWidget extends StatelessWidget {
  final MainViewModel viewModel;
  const CategoryFilterWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Category>(
      stream: viewModel.outputSelectedCategory,
      builder: (context, snapshot) {
        final selectedCategory = snapshot.data ?? Category.all;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: Category.values.asMap().entries.map((entry) {
              final category = entry.value;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child:
                    ChoiceChip(
                          label: Text(category.localizedCategory()),
                          selected: selectedCategory == category,
                          onSelected: (selected) {
                            if (selected) {
                              viewModel.setCategory(category);
                            }
                          },
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
            }).toList(),
          ),
        );
      },
    );
  }
}

class TodoSectionWidget extends StatelessWidget {
  final MainViewModel viewModel;

  const TodoSectionWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (screenWidth < 600)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.home.titleSection,
                          style: const TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          t.months[DateTime.now().month - 1],
                          style: TextStyle(
                            fontSize: 25,
                            color: Theme.of(context).colorScheme.onSurface,
                            shadows: List.generate(
                              4,
                              (i) => Shadow(
                                blurRadius: 50,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          t.home.titleSection,
                          style: const TextStyle(fontSize: 25),
                        ),
                        Text(
                          t.months[DateTime.now().month - 1],
                          style: TextStyle(
                            fontSize: 25,
                            color: Theme.of(context).colorScheme.onSurface,
                            shadows: List.generate(
                              4,
                              (i) => Shadow(
                                blurRadius: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed(RoutesManager.searchRoute);
                      },
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                    .animate()
                    .scale(begin: const Offset(0.8, 0.8))
                    .then()
                    .shake(duration: 500.ms, delay: 2000.ms)
                    .then(delay: 3000.ms)
                    .shake(duration: 500.ms),
              ],
            ),
          ),
          const Divider()
              .animate()
              .fadeIn(duration: 400.ms, delay: 600.ms)
              .scaleX(begin: 0, end: 1),
          const SizedBox(height: 8),
          StreamBuilder<MainObject?>(
            stream: viewModel.outputMainData,
            builder: (context, mainDataSnapshot) {
              final allTodos = mainDataSnapshot.data?.mainData?.todos ?? [];

              return StreamBuilder<Category>(
                stream: viewModel.outputSelectedCategory,
                builder: (context, categorySnapshot) {
                  final selectedCategory =
                      categorySnapshot.data ?? Category.all;
                  final filteredTodos = allTodos.where((todo) {
                    if (selectedCategory == Category.all) return true;
                    return todo.category == selectedCategory;
                  }).toList();

                  if (filteredTodos.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return Column(
                    children: filteredTodos.asMap().entries.map((entry) {
                      final todo = entry.value;
                      return ItemTile(
                            item: todo,
                            isTodo: true,
                            viewModel: viewModel,
                          )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: 0.3, end: 0);
                    }).toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class FinishedSectionWidget extends StatelessWidget {
  final MainViewModel viewModel;

  const FinishedSectionWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.home.finishedList, style: const TextStyle(fontSize: 25)),
              ],
            ),
          ),
          const Divider()
              .animate()
              .fadeIn(duration: 400.ms, delay: 600.ms)
              .scaleX(begin: 0, end: 1),
          const SizedBox(height: 8),
          StreamBuilder<MainObject?>(
            stream: viewModel.outputMainData,
            builder: (context, mainDataSnapshot) {
              final allFinished =
                  mainDataSnapshot.data?.mainData?.finished ?? [];

              return StreamBuilder<Category>(
                stream: viewModel.outputSelectedCategory,
                builder: (context, categorySnapshot) {
                  final selectedCategory =
                      categorySnapshot.data ?? Category.all;
                  final filteredFinished = allFinished.where((item) {
                    if (selectedCategory == Category.all) return true;
                    return item.category == selectedCategory;
                  }).toList();

                  if (filteredFinished.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return Column(
                    children: filteredFinished.map((finished) {
                      return ItemTile(
                            item: finished,
                            isTodo: false,
                            viewModel: viewModel,
                          )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: -0.3, end: 0);
                    }).toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class ItemTile extends StatelessWidget {
  final Item item;
  final bool isTodo;
  final MainViewModel viewModel;

  const ItemTile({
    super.key,
    required this.item,
    required this.isTodo,
    required this.viewModel,
  });

  void _showItemActions(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ItemActionsDialog(
        item: item,
        currentList: isTodo ? ItemListType.todo : ItemListType.finished,
        onMoveToTodo: () => viewModel.moveToTodo(item),
        onMoveToFinished: () => viewModel.moveToFinished(item),
        onMoveToHistory: () => viewModel.moveToHistory(item),
        onDelete: () => viewModel.deleteItemPermanently(
          item,
          isTodo ? ItemListType.todo : ItemListType.finished,
        ),
        onEdit: () {
          showDialog(
            context: context,
            builder: (_) => EditItemDialog(
              item: item,
              onSave: (updatedItem) {
                viewModel.updateItem(updatedItem);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueKey =
        'item-${isTodo ? 'todo' : 'finished'}-${item.id}-${item.category?.name}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Dismissible(
        key: ValueKey(valueKey),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          int? index = isTodo
              ? viewModel.deleteTodoTemporarily(item)
              : viewModel.deleteFinishedTemporarily(item);

          if (index == null) return;

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  content: Text("'${item.title ?? 'Item'}' ${t.home.deleted}."),
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: t.home.undo,
                    onPressed: () {
                      if (isTodo) {
                        viewModel.undoDeleteTodo(item, index);
                      } else {
                        viewModel.undoDeleteFinished(item, index);
                      }
                    },
                  ),
                ),
              )
              .closed
              .then((reason) {
                if (reason != SnackBarClosedReason.action) {
                  if (isTodo) {
                    viewModel.confirmDeleteTodo(item);
                  } else {
                    viewModel.confirmDeleteFinished(item);
                  }
                }
              });
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Directionality.of(context) == TextDirection.rtl
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 24),
        ),
        child: Card(
          elevation: AppSize.s0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: (item.posterUrl != null && item.posterUrl!.isNotEmpty)
                  ? Image.network(
                      item.posterUrl!,
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 75,
                        color: Colors.grey,
                        child: const Icon(Icons.broken_image, size: 30),
                      ),
                    )
                  : Container(
                      width: 50,
                      height: 75,
                      color: Colors.grey,
                      child: const Icon(Icons.list_alt, size: 30),
                    ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title ?? 'Untitled',
                  style: const TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.personalRating != null && item.personalRating! > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: RatingBarIndicator(
                      rating: item.personalRating!,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      itemCount: 5,
                      itemSize: 16.0,
                      direction: Axis.horizontal,
                    ),
                  ),
              ],
            ),
            subtitle: Text(
              item.category?.localizedCategory() ?? 'Uncategorized',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.secondary,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isTodo ? Icons.check_rounded : Icons.undo_rounded,
                color: theme.colorScheme.primary,
              ),
              onPressed: () => isTodo
                  ? viewModel.moveToFinished(item)
                  : viewModel.moveToTodo(item),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                RoutesManager.detailsRoute,
                arguments: DetailsView(
                  id: item.id ?? '',
                  category: item.category ?? Category.all,
                ),
              );
            },
            onLongPress: () => _showItemActions(context),
          ),
        ),
      ),
    );
  }
}

Widget _buildEmptyState(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
    child: Center(
      child: Column(
        children: [
          Icon(
                Icons.list_alt,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              )
              .animate()
              .fadeIn(duration: 300.ms)
              .scale(begin: const Offset(0.5, 0.5))
              .then()
              .shake(duration: 500.ms, delay: 1000.ms)
              .then(delay: 2000.ms)
              .shake(duration: 500.ms),
          const SizedBox(height: 10),
          Text(t.home.emptySection, style: const TextStyle(fontSize: 15))
              .animate()
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .slideY(begin: 0.3, end: 0),
          const SizedBox(height: 30),
        ],
      ),
    ),
  );
}

class NewMonthDialog extends StatefulWidget {
  final List<Item> unfinishedItems;

  const NewMonthDialog({super.key, required this.unfinishedItems});

  @override
  State<NewMonthDialog> createState() => _NewMonthDialogState();
}

class _NewMonthDialogState extends State<NewMonthDialog> {
  final Set<String> selectedItemKeys = <String>{};
  bool selectAll = false;

  List<Item> getSelectedItems() {
    return widget.unfinishedItems
        .where(
          (item) =>
              selectedItemKeys.contains('${item.id}-${item.category?.name}'),
        )
        .toList();
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      if (selectAll) {
        selectedItemKeys.addAll(
          widget.unfinishedItems.map(
            (item) => '${item.id}-${item.category?.name}',
          ),
        );
      } else {
        selectedItemKeys.clear();
      }
    });
  }

  void _toggleItem(String itemKey, bool? value) {
    setState(() {
      if (value == true) {
        selectedItemKeys.add(itemKey);
        selectAll = selectedItemKeys.length == widget.unfinishedItems.length;
      } else {
        selectedItemKeys.remove(itemKey);
        selectAll = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasUnfinished = widget.unfinishedItems.isNotEmpty;

    return AlertDialog(
      title: Text(
        t.home.newMonthStarted,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: hasUnfinished
            ? MediaQuery.of(context).size.height * 0.5
            : MediaQuery.of(context).size.height * 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main description
            Text(
              t.home.description(month: t.months[DateTime.now().month - 1]),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            if (hasUnfinished) ...[
              Text(
                t.home.description2,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),

              // Select all checkbox
              InkWell(
                onTap: () => _toggleSelectAll(!selectAll),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Checkbox(value: selectAll, onChanged: _toggleSelectAll),
                      const SizedBox(width: 8),
                      Text(
                        t.home.selectAll,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),

              // Items list
              Expanded(
                child: ListView.separated(
                  itemCount: widget.unfinishedItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = widget.unfinishedItems[index];
                    final itemKey = '${item.id}-${item.category?.name}';
                    final isSelected = selectedItemKeys.contains(itemKey);

                    return Card(
                      color: colorScheme.primaryContainer.withAlpha(150),
                      child: CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) => _toggleItem(itemKey, value),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        title: Text(
                          item.title ?? '',
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: item.category?.localizedCategory() != null
                            ? Text(
                                item.category!.localizedCategory(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              )
                            : null,
                        secondary: _buildItemImage(item),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        t.home.congratulations,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.home.todosDone,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: hasUnfinished
          ? [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.done_all_rounded),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.of(
                            context,
                          ).pop(List<Item>.from(widget.unfinishedItems)),
                          label: Text(
                            t.home.addAll,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.check_box_rounded),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: selectedItemKeys.isEmpty
                              ? null
                              : () => Navigator.of(
                                  context,
                                ).pop(getSelectedItems()),
                          label: Text(t.home.keepSelected),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () => Navigator.of(context).pop(<Item>[]),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: Text(t.home.deleteAll),
                    ),
                  ),
                ],
              ),
            ]
          : [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.of(context).pop(<Item>[]),
                  child: Text(t.home.close),
                ),
              ),
            ],
    );
  }

  Widget _buildItemImage(Item item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 32,
        height: 48,
        child: item.posterUrl != null && item.posterUrl!.isNotEmpty
            ? Image.network(
                item.posterUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_outlined,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class ItemActionsDialog extends StatelessWidget {
  final Item item;
  final ItemListType currentList;
  final VoidCallback? onMoveToTodo;
  final VoidCallback? onMoveToFinished;
  final VoidCallback? onMoveToHistory;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ItemActionsDialog({
    super.key,
    required this.item,
    required this.currentList,
    this.onMoveToTodo,
    this.onMoveToFinished,
    this.onMoveToHistory,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget buildAction(
      String title,
      IconData icon,
      VoidCallback? action,
      bool isEnabled,
    ) {
      return ListTile(
        leading: Icon(
          icon,
          color: isEnabled ? colorScheme.primary : colorScheme.outline,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isEnabled ? colorScheme.onSurface : colorScheme.outline,
          ),
        ),
        onTap: isEnabled
            ? () {
                Navigator.of(context).pop();
                action?.call();
              }
            : null,
        enabled: isEnabled,
      );
    }

    return AlertDialog(
      title: Text(
        item.title ?? t.home.itemActions,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildAction(t.home.editNotes, Icons.edit_note_rounded, onEdit, true),
          buildAction(
            t.home.moveToTodo,
            Icons.list_alt_rounded,
            onMoveToTodo,
            currentList != ItemListType.todo,
          ),
          buildAction(
            t.home.moveToFinished,
            Icons.check_circle_outline_rounded,
            onMoveToFinished,
            currentList != ItemListType.finished,
          ),
          buildAction(
            t.home.moveToHistory,
            Icons.history_rounded,
            onMoveToHistory,
            currentList != ItemListType.history,
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever_rounded,
              color: colorScheme.error,
            ),
            title: Text(
              t.home.delete,
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () {
              Navigator.of(context).pop();
              onDelete?.call();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.errorHandler.cancel),
        ),
      ],
    );
  }
}

class EditItemDialog extends StatefulWidget {
  final Item item;
  final Function(Item updatedItem) onSave;

  const EditItemDialog({super.key, required this.item, required this.onSave});

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late double _currentRating;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.item.personalRating ?? 0.0;
    _notesController = TextEditingController(text: widget.item.personalNotes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final updatedItem = widget.item.copyWith(
      personalRating: _currentRating,
      personalNotes: _notesController.text.trim(),
    );
    widget.onSave(updatedItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(t.home.editNotes),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.home.yourRating, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Center(
              child: RatingBar.builder(
                initialRating: _currentRating,
                minRating: 0,
                glow: false,
                direction: Axis.horizontal,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(Icons.star),
                onRatingUpdate: (rating) {
                  setState(() {
                    _currentRating = rating;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(t.home.yourNotes, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: t.home.notesHint,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.errorHandler.cancel),
        ),
        ElevatedButton(onPressed: _handleSave, child: Text(t.apiSettings.save)),
      ],
    );
  }
}
