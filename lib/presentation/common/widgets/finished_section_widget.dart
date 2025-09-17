import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/widgets/empty_state_widget.dart';
import 'package:noted/presentation/common/widgets/item_tile.dart';
import 'package:noted/presentation/main/viewModel/main_view_model.dart';


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
                    return const EmptyStateWidget();
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
