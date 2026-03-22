import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/common/widgets/item_actions_dialog.dart';
import 'package:noted/presentation/details/details_view.dart';
import 'package:noted/presentation/main/main_view_model.dart';
import 'package:noted/presentation/resources/routes_manager.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final ItemListType currentList;
  final MainViewModel viewModel;

  const ItemTile({
    super.key,
    required this.item,
    required this.currentList,
    required this.viewModel,
  });

  void _showItemActions(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ItemActionsDialog(
        item: item,
        currentList: currentList,
        onMoveToTodo: () => viewModel.moveToTodo(item),
        onMoveToFinished: () => viewModel.moveToFinished(item),
        onMoveToHistory: () => viewModel.moveToHistory(item),
        onMoveToSaved: () => viewModel.moveToSaved(item),
        onDelete: () => viewModel.deleteItemPermanently(item, currentList),
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
        'item-${currentList.name}-${item.id}-${item.category?.name}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Dismissible(
        key: ValueKey(valueKey),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          int? index;
          if (currentList == ItemListType.todo) {
            index = viewModel.deleteTodoTemporarily(item);
          } else if (currentList == ItemListType.finished) {
            index = viewModel.deleteFinishedTemporarily(item);
          } else if (currentList == ItemListType.saved) {
            index = viewModel.deleteSavedTemporarily(item);
          }

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
                      if (currentList == ItemListType.todo) {
                        viewModel.undoDeleteTodo(item, index!);
                      } else if (currentList == ItemListType.finished) {
                        viewModel.undoDeleteFinished(item, index!);
                      } else if (currentList == ItemListType.saved) {
                        viewModel.undoDeleteSaved(item, index!);
                      }
                    },
                  ),
                ),
              )
              .closed
              .then((reason) {
                if (reason != SnackBarClosedReason.action) {
                  if (currentList == ItemListType.todo) {
                    viewModel.confirmDeleteTodo(item);
                  } else if (currentList == ItemListType.finished) {
                    viewModel.confirmDeleteFinished(item);
                  } else if (currentList == ItemListType.saved) {
                    viewModel.confirmDeleteSaved(item);
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
                  maxLines: 2,
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category?.localizedCategory() ?? 'Uncategorized',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                if (viewModel.showSeriesTracker &&
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                currentList == ItemListType.todo
                    ? Icons.check_rounded
                    : currentList == ItemListType.finished
                    ? Icons.undo_rounded
                    : Icons.playlist_add_rounded,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                if (currentList == ItemListType.todo) {
                  viewModel.moveToFinished(item);
                } else if (currentList == ItemListType.finished) {
                  viewModel.moveToTodo(item);
                } else if (currentList == ItemListType.saved) {
                  viewModel.moveToTodo(item);
                }
              },
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
