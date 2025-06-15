import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

final MainViewModel viewModel = instance<MainViewModel>();

class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
    viewModel.start();
    monthChecker();
  }

  Future<void> monthChecker() async {
    if (await checkForNewMonth()) {
      if (!mounted) return;
      await handleNewMonth();
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
          await viewModel.deleteTodo(oldItem);
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 50,
        centerTitle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: Text(
          t.appName,
          style: TextStyle(
            fontSize: 23,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(RoutesManager.settingsRoute);
              viewModel.start();
            },
          ),
        ],
      ),
      body: StateFlowHandler(
        stream: viewModel.outputState,
        retryAction: () {
          viewModel.start();
        },
        contentBuilder: (context) => _getContentWidget(viewModel),
      ),
    );
  }

  Widget _getContentWidget(MainViewModel viewModel) {
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
            FinishedSectionWidget().animate().fadeIn(duration: 500.ms),
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
                          selectedColor: Theme.of(context).colorScheme.primary,
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
                if (screenWidth < 500)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.home.titleSection,
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
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
                  )
                else
                  Row(
                    children: [
                      Text(
                        t.home.titleSection,
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
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
                ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await Navigator.of(
                          context,
                        ).pushNamed(RoutesManager.searchRoute);
                        viewModel.start();
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
          Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              )
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
                      return buildItem(
                            context,
                            todo,
                            'todo-${todo.id}-${todo.category?.name}',
                            (direction) => viewModel.deleteTodo(todo),
                            () => viewModel.moveToFinished(todo),
                            Icons.check_rounded,
                            RoutesManager.detailsRoute,
                            arguments: DetailsView(
                              id: todo.id!,
                              category: todo.category!,
                            ),
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
  const FinishedSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                Text(
                  t.home.finishedList,
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              )
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
                    children: filteredFinished.asMap().entries.map((entry) {
                      final finished = entry.value;
                      return buildItem(
                            context,
                            finished,
                            'finished-${finished.id}-${finished.category?.name}',
                            (direction) => viewModel.deleteFinished(finished),
                            () => viewModel.moveToTodo(finished),
                            Icons.undo_rounded,
                            RoutesManager.detailsRoute,
                            arguments: DetailsView(
                              id: finished.id!,
                              category: finished.category!,
                            ),
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

Widget buildItem(
  BuildContext context,
  Item item,
  String value,
  Function(DismissDirection) onDismissed,
  VoidCallback onIconPressed,
  IconData icon,
  String route, {
  Object? arguments,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    child: Dismissible(
      key: ValueKey(value),
      direction: DismissDirection.startToEnd,
      onDismissed: onDismissed,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: item.posterUrl != null && item.posterUrl!.isNotEmpty
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
          title: Text(item.title ?? 'Untitled', style: TextStyle(fontSize: 16)),
          subtitle: Text(
            item.category!.localizedCategory(),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          trailing: IconButton(
            icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
            onPressed: onIconPressed,
          ),
          onTap: () {
            Navigator.pushNamed(context, route, arguments: arguments);
          },
        ),
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
                      elevation: 0,
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.6,
                      ),
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
              // Success state
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
              TextButton(
                onPressed: () => Navigator.of(context).pop(<Item>[]),
                child: Text(
                  t.home.deleteAll,
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
              TextButton(
                onPressed: selectedItemKeys.isEmpty
                    ? null
                    : () => Navigator.of(context).pop(getSelectedItems()),
                child: Text(t.home.keepSelected),
              ),
              FilledButton(
                onPressed: () => Navigator.of(
                  context,
                ).pop(List<Item>.from(widget.unfinishedItems)),
                child: Text(t.home.addAll),
              ),
            ]
          : [
              FilledButton(
                onPressed: () => Navigator.of(context).pop(<Item>[]),
                child: Text(t.home.close),
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
