import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noted/app/app_prefs.dart';
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

final AppPrefs prefs = instance<AppPrefs>();
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
    _checkFirstTime();
  }

  Future<void> monthChecker() async {
    if (await checkForNewMonth()) {
      if (!mounted) return;
      await handleNewMonth();
    }
  }

  Future<void> _checkFirstTime() async {
    if (!await prefs.getHasSeenDisclaimer()) {
      if (!mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const NoResponsibilityDialog(),
      );
      await prefs.setHasSeenDisclaimer(true);
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
            CategoryFilterWidget(viewModel: viewModel),
            const SizedBox(height: 20),
            TodoSectionWidget(viewModel: viewModel),
            const SizedBox(height: 8),
            FinishedSectionWidget(),
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
            children: Category.values.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category.localizedCategory()),
                  selected: selectedCategory == category,
                  onSelected: (selected) {
                    if (selected) {
                      viewModel.setCategory(category);
                    }
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  labelStyle: TextStyle(
                    color: selectedCategory == category
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: selectedCategory == category
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
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
                              blurRadius: 40,
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
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
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
                    children: filteredTodos
                        .map(
                          (todo) => buildItem(
                            context,
                            todo,
                            'todo-${todo.id}-${todo.category?.name}',
                            (direction) => viewModel.deleteTodo(todo),
                            () => viewModel.moveToFinished(todo),
                            RoutesManager.detailsRoute,
                            arguments: DetailsView(
                              id: todo.id!,
                              category: todo.category!,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
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
          ),
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
                    children: filteredFinished
                        .map(
                          (finished) => buildItem(
                            context,
                            finished,
                            'finished-${finished.id}-${finished.category?.name}',
                            (direction) => viewModel.deleteFinished(finished),
                            () => viewModel.moveToTodo(finished),
                            RoutesManager.detailsRoute,
                            arguments: DetailsView(
                              id: finished.id!,
                              category: finished.category!,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              );
            },
          ),
        ],
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
          ),
          const SizedBox(height: 10),
          Text(t.home.emptySection, style: const TextStyle(fontSize: 15)),
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
  String route, {
  Object? arguments,
}) {
  return Dismissible(
    key: ValueKey(value),
    direction: DismissDirection.startToEnd,
    onDismissed: onDismissed,
    background: Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    child: Card(
      elevation: AppSize.s0,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
          icon: Icon(
            Icons.undo_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: onIconPressed,
        ),
        onTap: () {
          Navigator.pushNamed(context, route, arguments: arguments);
        },
      ),
    ),
  );
}

class NoResponsibilityDialog extends StatelessWidget {
  const NoResponsibilityDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.disclaimer.title),
      content: Text(t.disclaimer.content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.disclaimer.acceptButton),
        ),
      ],
    );
  }
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

  @override
  void initState() {
    super.initState();
  }

  List<Item> getSelectedItems() {
    return widget.unfinishedItems
        .where(
          (item) =>
              selectedItemKeys.contains('${item.id}-${item.category?.name}'),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        t.home.newMonthStarted,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: widget.unfinishedItems.isEmpty
            ? MediaQuery.of(context).size.height * 0.3
            : MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.home.description(month: t.months[DateTime.now().month - 1]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            if (widget.unfinishedItems.isNotEmpty) Text(t.home.description2),
            const SizedBox(height: 16),
            if (widget.unfinishedItems.isNotEmpty) ...[
              Row(
                children: [
                  Checkbox(
                    value: selectAll,
                    onChanged: (value) {
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
                    },
                  ),
                  Text(t.home.selectAll),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.unfinishedItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.unfinishedItems[index];
                    final itemKey = '${item.id}-${item.category?.name}';
                    final isSelected = selectedItemKeys.contains(itemKey);

                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedItemKeys.add(itemKey);
                            if (selectedItemKeys.length ==
                                widget.unfinishedItems.length) {
                              selectAll = true;
                            }
                          } else {
                            selectedItemKeys.remove(itemKey);
                            selectAll = false;
                          }
                        });
                      },
                      title: Text(
                        item.title ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        item.category?.localizedCategory() ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      secondary: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child:
                            item.posterUrl != null && item.posterUrl!.isNotEmpty
                            ? Image.network(
                                item.posterUrl!,
                                width: 40,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 40,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 20,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                              )
                            : Container(
                                width: 40,
                                height: 60,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.list_alt,
                                  size: 20,
                                  color: Colors.grey[600],
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Expanded(
                // Ensure this part also takes available space
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 60,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        t.home.congratulations,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        t.home.todosDone,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (widget.unfinishedItems.isNotEmpty) ...[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(<Item>[]);
            },
            child: Text(
              t.home.deleteAll,
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(getSelectedItems());
            },
            child: Text(t.home.keepSelected),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pop(List<Item>.from(widget.unfinishedItems));
            },
            child: Text(
              t.home.addAll,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ] else ...[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(<Item>[]);
            },
            child: Text(
              t.home.close,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ],
    );
  }
}
