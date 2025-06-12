import 'package:flutter/material.dart';
import 'package:noted/app/di.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/state_renderer/state_flow_handler.dart';
import 'package:noted/presentation/details/view/details_view.dart';
import 'package:noted/presentation/history/viewModel/history_view_model.dart';
import 'package:noted/presentation/resources/routes_manager.dart';
import 'package:noted/presentation/resources/values_manager.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  HistoryViewState createState() => HistoryViewState();
}

class HistoryViewState extends State<HistoryView> {
  late final HistoryViewModel _viewModel = instance<HistoryViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.start();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        toolbarHeight: 50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: Text(
          t.history.history,
          style: TextStyle(
            fontSize: 23,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: StateFlowHandler(
        stream: _viewModel.outputState,
        retryAction: () {
          _viewModel.loadHistoryItems();
        },
        contentBuilder: (context) => _getContentWidget(),
      ),
    );
  }

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFilter(),
          const SizedBox(height: AppSize.s20),
          Expanded(child: _buildHistoryListSection()),
        ],
      ),
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
            children: Category.values.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: AppPadding.p8),
                child: ChoiceChip(
                  label: Text(category.localizedCategory()),
                  selected: selectedCategory == category,
                  onSelected: (selected) {
                    if (selected) {
                      _viewModel.setCategory(category);
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
                  checkmarkColor: Theme.of(context).colorScheme.surface,
                ),
              );
            }).toList(),
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
          return _buildEmptyState(context);
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
              return _buildEmptyState(context);
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
                            ).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                    thickness: 1,
                    indent: AppPadding.p16,
                    endIndent: AppPadding.p16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p8,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _buildHistoryItemTile(context, item);
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

  Widget _buildHistoryItemTile(BuildContext context, Item item) {
    return Card(
      elevation: AppSize.s0,
      color: Theme.of(context).colorScheme.onPrimary,
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.s8),
          child: item.posterUrl != null && item.posterUrl!.isNotEmpty
              ? Image.network(
                  item.posterUrl!,
                  width: 55,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholderIcon(item.category, 55, 80),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 55,
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                )
              : _buildPlaceholderIcon(item.category, 55, 80),
        ),
        title: Text(
          item.title ?? '',
          style: TextStyle(
            fontSize: AppSize.s16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          item.category?.localizedCategory() ?? '',
          style: TextStyle(
            fontSize: AppSize.s12,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        onTap: () {
          if (item.id != null && item.category != null) {
            Navigator.pushNamed(
              context,
              RoutesManager.detailsRoute,
              arguments: DetailsView(id: item.id!, category: item.category!),
            );
          }
        },
      ),
    );
  }

  Widget _buildPlaceholderIcon(
    Category? category,
    double width,
    double height,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),
      child: Icon(
        _getIconForCategory(category),
        size: AppSize.s30,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
      ),
    );
  }

  IconData _getIconForCategory(Category? category) {
    switch (category) {
      case Category.movies:
        return Icons.movie_creation_outlined;
      case Category.series:
        return Icons.tv_outlined;
      case Category.books:
        return Icons.book_outlined;
      case Category.games:
        return Icons.sports_esports_outlined;
      default:
        return Icons.list_alt_outlined;
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_edu_outlined,
              size: AppSize.s80,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: AppSize.s20),
            Text(
              t.history.noHistory,
              style: TextStyle(
                fontSize: AppSize.s18,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
