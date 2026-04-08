import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/presentation/main/main_view_model.dart';

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
                child: StreamBuilder<bool>(
                  stream: viewModel.outputIsAscending,
                  builder: (context, ascSnapshot) {
                    final isAscending = ascSnapshot.data ?? false;
                    return StreamBuilder<SortOption>(
                      stream: viewModel.outputSortOption,
                      builder: (context, sortSnapshot) {
                        final selectedOption =
                            sortSnapshot.data ?? SortOption.dateAdded;
                        return PopupMenuButton<SortOption>(
                          initialValue: selectedOption,
                          onSelected: (option) {
                            viewModel.setSortOption(option);
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
              // Category Chips
              ...Category.values.asMap().entries.map((entry) {
                final category = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child:
                      ChoiceChip(
                            label: Text(category.localizedCategory()),
                            selected: selectedCategory == category,
                            showCheckmark: false,
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
