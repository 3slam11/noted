import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/widgets/item_actions_dialog.dart';
import 'package:noted/presentation/details/details_view.dart';
import 'package:noted/presentation/resources/routes_manager.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final ItemListType? currentList;
  final bool showSeriesTracker;

  // UI Customization
  final Color? cardColor;
  final EdgeInsetsGeometry? margin;
  final Widget? customTrailing;

  // Swipe to dismiss callbacks (Nullable to disable swipe)
  final int? Function(Item)? onSwipeDismiss;
  final void Function(Item, int)? onUndoSwipe;
  final void Function(Item)? onConfirmSwipe;

  // Action callbacks
  final VoidCallback? onMoveToTodo;
  final VoidCallback? onMoveToFinished;
  final VoidCallback? onMoveToHistory;
  final VoidCallback? onMoveToSaved;
  final VoidCallback? onDeletePermanently;
  final Function(Item)? onEdit;

  const ItemTile({
    super.key,
    required this.item,
    this.currentList,
    this.showSeriesTracker = false,
    this.cardColor,
    this.margin,
    this.customTrailing,
    this.onSwipeDismiss,
    this.onUndoSwipe,
    this.onConfirmSwipe,
    this.onMoveToTodo,
    this.onMoveToFinished,
    this.onMoveToHistory,
    this.onMoveToSaved,
    this.onDeletePermanently,
    this.onEdit,
  });

  void _showItemActions(BuildContext context) {
    if (currentList == null) return;

    showDialog(
      context: context,
      builder: (_) => ItemActionsDialog(
        item: item,
        currentList: currentList!,
        onMoveToTodo: onMoveToTodo,
        onMoveToFinished: onMoveToFinished,
        onMoveToHistory: onMoveToHistory,
        onMoveToSaved: onMoveToSaved,
        onDelete: onDeletePermanently,
        onEdit: onEdit != null
            ? () {
                showDialog(
                  context: context,
                  builder: (_) => EditItemDialog(item: item, onSave: onEdit!),
                );
              }
            : null,
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
      case Category.anime:
        return Icons.animation_rounded;
      case Category.manga:
        return Icons.menu_book_rounded;
      default:
        return Icons.list_alt_outlined;
    }
  }

  Widget? _buildTrailingAction(BuildContext context) {
    if (customTrailing != null) return customTrailing;
    if (currentList == null || currentList == ItemListType.history) return null;

    IconData? icon;
    VoidCallback? action;

    if (currentList == ItemListType.todo) {
      icon = Icons.check_rounded;
      action = onMoveToFinished;
    } else if (currentList == ItemListType.finished) {
      icon = Icons.undo_rounded;
      action = onMoveToTodo;
    } else if (currentList == ItemListType.saved) {
      icon = Icons.playlist_add_rounded;
      action = onMoveToTodo;
    }

    if (icon == null || action == null) return null;

    return SizedBox(
      height: 105,
      child: Center(
        child: IconButton(
          icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          onPressed: action,
        ),
      ),
    );
  }

  // Card has NO border radius — the outer ClipRRect handles all rounding.
  // This prevents the Card's own anti-aliased corners from bleeding white
  // pixels over the red Dismissible background during swipe.
  Widget _buildCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: cardColor,
      shape: const RoundedRectangleBorder(), // No radius here
      clipBehavior: Clip.antiAlias,
      child: InkWell(
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
        onLongPress: currentList != null
            ? () => _showItemActions(context)
            : null,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Poster Image with subtle shadow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (item.posterUrl != null && item.posterUrl!.isNotEmpty)
                      ? (item.posterUrl!.startsWith('http')
                            ? CachedNetworkImage(
                                imageUrl: item.posterUrl!,
                                width: 70,
                                height: 105,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 70,
                                  height: 105,
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 70,
                                  height: 105,
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.broken_image_rounded,
                                    size: 30,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : Image.file(
                                File(item.posterUrl!),
                                width: 70,
                                height: 105,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 70,
                                      height: 105,
                                      color: theme
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      child: Icon(
                                        Icons.broken_image_rounded,
                                        size: 30,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                              ))
                      : Container(
                          width: 70,
                          height: 105,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            _getIconForCategory(item.category),
                            size: 30,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      item.title ?? 'Untitled',
                      style: const TextStyle(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    Text(
                      item.category?.localizedCategory() ?? 'Uncategorized',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.secondary,
                      ),
                    ),

                    // Series Tracker OR Release Date
                    if (showSeriesTracker &&
                        item.category == Category.series &&
                        item.currentSeason != null &&
                        item.currentEpisode != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          '${t.details.season} ${item.currentSeason} • ${t.details.episode} ${item.currentEpisode}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      )
                    else if (item.releaseDate != null &&
                        item.releaseDate!.isNotEmpty &&
                        currentList == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          '${item.releaseDate}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),

                    Builder(
                      builder: (context) {
                        final bool hasRating =
                            item.personalRating != null &&
                            item.personalRating! > 0;
                        final bool hasNotes =
                            item.personalNotes != null &&
                            item.personalNotes!.trim().isNotEmpty;

                        if (!hasRating && !hasNotes) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              if (hasRating)
                                RatingBarIndicator(
                                  rating: item.personalRating!,
                                  itemBuilder: (context, index) =>
                                      const Icon(Icons.star_rounded),
                                  itemCount: 5,
                                  itemSize: 18.0,
                                  direction: Axis.horizontal,
                                ),
                              if (hasRating && hasNotes)
                                const SizedBox(width: 8),
                              if (hasNotes)
                                Tooltip(
                                  message: t.home.yourNotes,
                                  child: Icon(
                                    Icons.notes_rounded,
                                    size: 18.0,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Action Button
              if (_buildTrailingAction(context) != null)
                _buildTrailingAction(context)!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueKey =
        'item-${currentList?.name ?? 'search'}-${item.id}-${item.category?.name}';

    final actualMargin =
        margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

    Widget content;

    if (onSwipeDismiss != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Dismissible(
          key: ValueKey(valueKey),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            final index = onSwipeDismiss!(item);
            if (index == null) return;

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text(
                      "'${item.title ?? 'Item'}' ${t.home.deleted}.",
                    ),
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    action: SnackBarAction(
                      label: t.home.undo,
                      onPressed: () => onUndoSwipe?.call(item, index),
                    ),
                  ),
                )
                .closed
                .then((reason) {
                  if (reason != SnackBarClosedReason.action) {
                    onConfirmSwipe?.call(item);
                  }
                });
          },
          background: Container(
            color: theme.colorScheme.error,
            alignment: Directionality.of(context) == TextDirection.rtl
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Icon(
              Icons.delete_outline_rounded,
              color: theme.colorScheme.onError,
              size: 28,
            ),
          ),
          child: _buildCard(context),
        ),
      );
    } else {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _buildCard(context),
      );
    }

    return Padding(padding: actualMargin, child: content);
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        t.home.editNotes,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.home.yourRating, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: t.home.notesHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
        FilledButton(
          onPressed: _handleSave,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(t.apiSettings.save),
        ),
      ],
    );
  }
}
