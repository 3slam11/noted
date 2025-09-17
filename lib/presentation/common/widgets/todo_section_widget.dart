import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/widgets/empty_state_widget.dart';
import 'package:noted/presentation/common/widgets/item_tile.dart';
import 'package:noted/presentation/main/viewModel/main_view_model.dart';


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
                    return const EmptyStateWidget();
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
