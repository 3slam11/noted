import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/presentation/main/viewModel/main_view_model.dart';

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
            children: [
              // Sort Dropdown Chip
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: StreamBuilder<SortOption>(
                  stream: viewModel.outputSortOption,
                  builder: (context, sortSnapshot) {
                    final selectedOption =
                        sortSnapshot.data ?? SortOption.dateAddedNewest;
                    return ChoiceChip(
                      label: Row(
                        children: [
                          Icon(
                            Icons.sort_rounded,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(selectedOption.localizedName()),
                        ],
                      ),
                      selected: false,
                      onSelected: (selected) {
                        showMenu(
                          context: context,
                          position: const RelativeRect.fromLTRB(0, 0, 0, 0),
                          items: SortOption.values.map((option) {
                            return PopupMenuItem<SortOption>(
                              value: option,
                              child: Text(option.localizedName()),
                              onTap: () {
                                viewModel.setSortOption(option);
                              },
                            );
                          }).toList(),
                        );
                      },
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  },
                ),
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
              // Category Chips
              ...Category.values.asMap().entries.map((entry) {
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
              }),
            ],
          ),
        );
      },
    );
  }
}
