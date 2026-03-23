import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:noted/app/di.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/state_renderer/state_flow_handler.dart';
import 'package:noted/presentation/common/widgets/item_actions_dialog.dart';
import 'package:noted/presentation/details/details_view.dart';
import 'package:noted/presentation/saved/saved_viewmodel.dart';
import 'package:noted/presentation/resources/routes_manager.dart';
import 'package:noted/presentation/resources/values_manager.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  SavedViewState createState() => SavedViewState();
}

class SavedViewState extends State<SavedView> {
  late final SavedViewModel _viewModel = instance<SavedViewModel>();

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
    return StateFlowHandler(
      stream: _viewModel.outputState,
      retryAction: () {
        _viewModel.loadSavedItems();
      },
      contentBuilder: (context) => _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFilter(),
          const SizedBox(height: AppSize.s12),
          _buildSortControl(),
          const SizedBox(height: AppSize.s20),
          Expanded(child: _buildSavedListSection()),
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
            children: [
              // Sort Dropdown Chip
              Padding(
                padding: const EdgeInsets.only(right: AppPadding.p8),
                child: StreamBuilder<SortOption>(
                  stream: _viewModel.outputSortOption,
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
                          position: RelativeRect.fromLTRB(0, 0, 0, 0),
                          items: SortOption.values.map((option) {
                            return PopupMenuItem<SortOption>(
                              value: option,
                              child: Text(option.localizedName()),
                              onTap: () {
                                _viewModel.setSortOption(option);
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
              ...Category.values.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppPadding.p8),
                  child:
                      ChoiceChip(
                            label: Text(category.localizedCategory()),
                            selected: selectedCategory == category,
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

  Widget _buildSortControl() {
    return const SizedBox.shrink();
  }

  Widget _buildSavedListSection() {
    return StreamBuilder<List<Item>>(
      stream: _viewModel.outputSavedItems,
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
                      primary: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p8,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _buildSavedItemTile(
                          context,
                          item,
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

  void _showItemActions(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (_) => ItemActionsDialog(
        item: item,
        currentList: ItemListType.saved,
        onMoveToTodo: () => _viewModel.moveToTodo(item),
        onMoveToFinished: () => _viewModel.moveToFinished(item),
        onMoveToHistory: () => _viewModel.moveToHistory(item),
        onDelete: () => _viewModel.deleteSavedItem(item),
        onEdit: () => _showEditNotesDialog(context, item),
      ),
    );
  }

  void _showEditNotesDialog(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (_) => EditItemDialog(
        item: item,
        onSave: (updatedItem) {
          _viewModel.updateItem(updatedItem);
        },
      ),
    );
  }

  Widget _buildSavedItemTile(BuildContext context, Item item) {
    final valueKey = 'saved-item-${item.id}-${item.category?.name}';
    return Dismissible(
      key: ValueKey(valueKey),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        final index = _viewModel.deleteSavedItemTemporarily(item);
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
                  onPressed: () => _viewModel.undoDeleteSavedItem(item, index),
                ),
              ),
            )
            .closed
            .then((reason) {
              if (reason != SnackBarClosedReason.action) {
                _viewModel.confirmDeleteSavedItem(item);
              }
            });
      },
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p6,
        ),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(AppSize.s10),
        ),
        alignment: Directionality.of(context) == TextDirection.rtl
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 24),
      ),
      child: Card(
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
                ? CachedNetworkImage(
                    imageUrl: item.posterUrl!,
                    width: 55,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox(
                      width: 55,
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        _buildPlaceholderIcon(item.category, 55, 80),
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.category?.localizedCategory() ?? '',
                style: TextStyle(
                  fontSize: AppSize.s12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (_viewModel.showSeriesTracker &&
                  item.category == Category.series &&
                  item.currentSeason != null &&
                  item.currentEpisode != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    '${t.details.season} ${item.currentSeason} • ${t.details.episode} ${item.currentEpisode}',
                    style: TextStyle(
                      fontSize: AppSize.s12,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
          trailing: IconButton(
            icon: Icon(
              Icons.playlist_add_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              _viewModel.moveToTodo(item);
            },
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
          onLongPress: () => _showItemActions(context, item),
        ),
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
        color: Theme.of(context).colorScheme.secondary.withAlpha(25),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),
      child: Icon(
        _getIconForCategory(category),
        size: AppSize.s30,
        color: Theme.of(context).colorScheme.primary.withAlpha(180),
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
                  Icons.bookmark_border_rounded,
                  size: AppSize.s80,
                  color: Theme.of(context).colorScheme.primary.withAlpha(150),
                )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.5, 0.5))
                .then()
                .shake(duration: 500.ms, delay: 1000.ms),
            const SizedBox(height: AppSize.s20),
            Text(
                  t.home.noSaved,
                  style: TextStyle(
                    fontSize: AppSize.s18,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(180),
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms)
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
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
