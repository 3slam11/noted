import 'package:flutter/material.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';

class ItemActionsDialog extends StatelessWidget {
  final Item item;
  final ItemListType currentList;
  final VoidCallback? onMoveToTodo;
  final VoidCallback? onMoveToFinished;
  final VoidCallback? onMoveToHistory;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ItemActionsDialog({
    super.key,
    required this.item,
    required this.currentList,
    this.onMoveToTodo,
    this.onMoveToFinished,
    this.onMoveToHistory,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget buildAction(
      String title,
      IconData icon,
      VoidCallback? action,
      bool isEnabled,
    ) {
      return ListTile(
        leading: Icon(
          icon,
          color: isEnabled ? colorScheme.primary : colorScheme.outline,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isEnabled ? colorScheme.onSurface : colorScheme.outline,
          ),
        ),
        onTap: isEnabled
            ? () {
                Navigator.of(context).pop();
                action?.call();
              }
            : null,
        enabled: isEnabled,
      );
    }

    return AlertDialog(
      title: Text(
        item.title ?? t.home.itemActions,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildAction(t.home.editNotes, Icons.edit_note_rounded, onEdit, true),
          buildAction(
            t.home.moveToTodo,
            Icons.list_alt_rounded,
            onMoveToTodo,
            currentList != ItemListType.todo,
          ),
          buildAction(
            t.home.moveToFinished,
            Icons.check_circle_outline_rounded,
            onMoveToFinished,
            currentList != ItemListType.finished,
          ),
          buildAction(
            t.home.moveToHistory,
            Icons.history_rounded,
            onMoveToHistory,
            currentList != ItemListType.history,
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever_rounded,
              color: colorScheme.error,
            ),
            title: Text(
              t.home.delete,
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () {
              Navigator.of(context).pop();
              onDelete?.call();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.errorHandler.cancel),
        ),
      ],
    );
  }
}
