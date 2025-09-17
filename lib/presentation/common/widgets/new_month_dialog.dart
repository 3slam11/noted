import 'package:flutter/material.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';

class NewMonthDialog extends StatefulWidget {
  final List<Item> unfinishedItems;

  const NewMonthDialog({super.key, required this.unfinishedItems});

  @override
  State<NewMonthDialog> createState() => _NewMonthDialogState();
}

class _NewMonthDialogState extends State<NewMonthDialog> {
  final Set<String> selectedItemKeys = <String>{};
  bool selectAll = false;

  List<Item> getSelectedItems() {
    return widget.unfinishedItems
        .where(
          (item) =>
              selectedItemKeys.contains('${item.id}-${item.category?.name}'),
        )
        .toList();
  }

  void _toggleSelectAll(bool? value) {
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
  }

  void _toggleItem(String itemKey, bool? value) {
    setState(() {
      if (value == true) {
        selectedItemKeys.add(itemKey);
        selectAll = selectedItemKeys.length == widget.unfinishedItems.length;
      } else {
        selectedItemKeys.remove(itemKey);
        selectAll = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasUnfinished = widget.unfinishedItems.isNotEmpty;

    return AlertDialog(
      title: Text(
        t.home.newMonthStarted,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: hasUnfinished
            ? MediaQuery.of(context).size.height * 0.5
            : MediaQuery.of(context).size.height * 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main description
            Text(
              t.home.description(month: t.months[DateTime.now().month - 1]),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            if (hasUnfinished) ...[
              Text(
                t.home.description2,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),

              // Select all checkbox
              InkWell(
                onTap: () => _toggleSelectAll(!selectAll),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Checkbox(value: selectAll, onChanged: _toggleSelectAll),
                      const SizedBox(width: 8),
                      Text(
                        t.home.selectAll,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),

              // Items list
              Expanded(
                child: ListView.separated(
                  itemCount: widget.unfinishedItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = widget.unfinishedItems[index];
                    final itemKey = '${item.id}-${item.category?.name}';
                    final isSelected = selectedItemKeys.contains(itemKey);

                    return Card(
                      color: colorScheme.primaryContainer.withAlpha(150),
                      child: CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) => _toggleItem(itemKey, value),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        title: Text(
                          item.title ?? '',
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: item.category?.localizedCategory() != null
                            ? Text(
                                item.category!.localizedCategory(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              )
                            : null,
                        secondary: _buildItemImage(item),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        t.home.congratulations,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.home.todosDone,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: hasUnfinished
          ? [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.done_all_rounded),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.of(
                            context,
                          ).pop(List<Item>.from(widget.unfinishedItems)),
                          label: Text(
                            t.home.addAll,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.check_box_rounded),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: selectedItemKeys.isEmpty
                              ? null
                              : () => Navigator.of(
                                  context,
                                ).pop(getSelectedItems()),
                          label: Text(t.home.keepSelected),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () => Navigator.of(context).pop(<Item>[]),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: Text(t.home.deleteAll),
                    ),
                  ),
                ],
              ),
            ]
          : [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.of(context).pop(<Item>[]),
                  child: Text(t.home.close),
                ),
              ),
            ],
    );
  }

  Widget _buildItemImage(Item item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 32,
        height: 48,
        child: item.posterUrl != null && item.posterUrl!.isNotEmpty
            ? Image.network(
                item.posterUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_outlined,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
