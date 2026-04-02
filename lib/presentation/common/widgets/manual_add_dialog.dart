import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:noted/domain/model/models.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/resources/values_manager.dart';

class ManualAddDialog extends StatefulWidget {
  final Function({
    required String title,
    required Category category,
    required ItemListType listType,
    String? description,
    String? posterUrl,
    List<String>? additionalImageUrls,
    String? releaseDate,
    List<String>? genres,
    String? publisher,
    List<String>? platforms,
  })
  onAdd;

  const ManualAddDialog({super.key, required this.onAdd});

  @override
  State<ManualAddDialog> createState() => _ManualAddDialogState();
}

class _ManualAddDialogState extends State<ManualAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _posterUrlController = TextEditingController();
  final _additionalImagesController = TextEditingController();
  final _genresController = TextEditingController();
  final _publisherController = TextEditingController();
  final _platformsController = TextEditingController();

  Category _selectedCategory = Category.movies;
  ItemListType _selectedListType = ItemListType.todo;

  String? _pickedPosterPath;
  final List<String> _pickedAdditionalImages = [];
  DateTime? _selectedReleaseDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _posterUrlController.dispose();
    _additionalImagesController.dispose();
    _genresController.dispose();
    _publisherController.dispose();
    _platformsController.dispose();
    super.dispose();
  }

  Future<void> _pickReleaseDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedReleaseDate ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 20),
    );
    if (picked != null) {
      setState(() => _selectedReleaseDate = picked);
    }
  }

  String? get _releaseDateDisplay {
    if (_selectedReleaseDate == null) return null;
    final d = _selectedReleaseDate!;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final additionalImages = _additionalImagesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      additionalImages.addAll(_pickedAdditionalImages);

      final genres = _genresController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final platforms = _platformsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      widget.onAdd(
        title: _titleController.text.trim(),
        category: _selectedCategory,
        listType: _selectedListType,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        posterUrl:
            _pickedPosterPath ??
            (_posterUrlController.text.trim().isNotEmpty
                ? _posterUrlController.text.trim()
                : null),
        additionalImageUrls: additionalImages.isNotEmpty
            ? additionalImages
            : null,
        releaseDate: _releaseDateDisplay,
        genres: genres.isNotEmpty ? genres : null,
        publisher: _publisherController.text.trim().isNotEmpty
            ? _publisherController.text.trim()
            : null,
        platforms: platforms.isNotEmpty ? platforms : null,
      );
      Navigator.of(context).pop();
    }
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required int animationDelay,
  }) {
    final theme = Theme.of(context);
    return Container(
          margin: const EdgeInsets.only(bottom: AppSize.s16),
          padding: const EdgeInsets.all(AppPadding.p16),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withAlpha(20),
            borderRadius: BorderRadius.circular(AppSize.s16),
            border: Border.all(
              color: theme.colorScheme.outline.withAlpha(30),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSize.s8),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.s16),
              ...children,
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: animationDelay.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s20),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        AppPadding.p24,
        AppPadding.p24,
        AppPadding.p24,
        AppPadding.p12,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
      actionsPadding: const EdgeInsets.all(AppPadding.p16),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.post_add_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSize.s12),
          Expanded(
            child: Text(
              t.home.addManualItem,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: AppPadding.p8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // BASIC INFO SECTION
                  _buildSection(
                    title: t.home.basicInformation,
                    icon: Icons.info_outline_rounded,
                    animationDelay: 0,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: t.home.titleHint,
                          prefixIcon: const Icon(Icons.title_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return t.home.titleRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSize.s16),
                      DropdownButtonFormField<Category>(
                        initialValue: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: t.statistics.category,
                          prefixIcon: const Icon(Icons.category_rounded),
                        ),
                        items: Category.values
                            .where((c) => c != Category.all)
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.localizedCategory()),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedCategory = val);
                          }
                        },
                      ),
                      const SizedBox(height: AppSize.s16),
                      DropdownButtonFormField<ItemListType>(
                        initialValue: _selectedListType,
                        decoration: InputDecoration(
                          labelText: t.home.selectList,
                          prefixIcon: const Icon(Icons.list_alt_rounded),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: ItemListType.todo,
                            child: Text(t.home.pending),
                          ),
                          DropdownMenuItem(
                            value: ItemListType.finished,
                            child: Text(t.home.finishedList),
                          ),
                          DropdownMenuItem(
                            value: ItemListType.saved,
                            child: Text(t.home.savedList),
                          ),
                          DropdownMenuItem(
                            value: ItemListType.history,
                            child: Text(t.settings.history),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedListType = val);
                          }
                        },
                      ),
                      const SizedBox(height: AppSize.s16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          labelText: t.home.descriptionOptional,
                          prefixIcon: const Icon(Icons.description_rounded),
                        ),
                      ),
                    ],
                  ),

                  // MEDIA SECTION
                  _buildSection(
                    title: t.home.media,
                    icon: Icons.perm_media_outlined,
                    animationDelay: 100,
                    children: [
                      TextFormField(
                        controller: _posterUrlController,
                        // Readonly when a local file is picked; editable for URL entry
                        readOnly: _pickedPosterPath != null,
                        decoration: InputDecoration(
                          labelText: t.home.imageUrlOptional,
                          // Upload icon makes it obvious this field can be filled from device
                          prefixIcon: const Icon(
                            Icons.add_photo_alternate_rounded,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _pickedPosterPath == null
                                  // Clearly communicates "upload from device"
                                  ? Icons.upload_rounded
                                  : Icons.clear_rounded,
                              color: theme.colorScheme.primary,
                            ),
                            tooltip: _pickedPosterPath == null
                                ? t.home.pickImage
                                : t.home.removeImage,
                            onPressed: () async {
                              if (_pickedPosterPath != null) {
                                setState(() {
                                  _pickedPosterPath = null;
                                  _posterUrlController.clear();
                                });
                              } else {
                                final result = await FilePicker.platform
                                    .pickFiles(type: FileType.image);
                                if (result != null &&
                                    result.files.single.path != null) {
                                  setState(() {
                                    _pickedPosterPath =
                                        result.files.single.path;
                                    _posterUrlController.text =
                                        result.files.single.name;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSize.s16),
                      TextFormField(
                        controller: _additionalImagesController,
                        decoration: InputDecoration(
                          labelText: t.home.additionalImagesOptional,
                          // Gallery-upload icon reinforces "pick multiple from device"
                          prefixIcon: const Icon(Icons.photo_library_rounded),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Folder-upload icon is unambiguous about device picking
                              Icons.drive_folder_upload_rounded,
                              color: theme.colorScheme.primary,
                            ),
                            tooltip: t.home.pickImage,
                            onPressed: () async {
                              final result = await FilePicker.platform
                                  .pickFiles(
                                    type: FileType.image,
                                    allowMultiple: true,
                                  );
                              if (result != null) {
                                setState(() {
                                  _pickedAdditionalImages.addAll(
                                    result.paths.whereType<String>(),
                                  );
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      if (_pickedAdditionalImages.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppPadding.p12),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: _pickedAdditionalImages
                                .map(
                                  (path) => Chip(
                                    label: Text(
                                      path.split(Platform.pathSeparator).last,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    deleteIconColor: theme.colorScheme.error,
                                    onDeleted: () {
                                      setState(() {
                                        _pickedAdditionalImages.remove(path);
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                    ],
                  ),

                  // ADDITIONAL DETAILS SECTION
                  _buildSection(
                    title: t.home.additionalDetails,
                    icon: Icons.more_horiz_rounded,
                    animationDelay: 200,
                    children: [
                      // Release date — tapping opens the native date picker
                      GestureDetector(
                        onTap: _pickReleaseDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: t.home.releaseDateOptional,
                              prefixIcon: const Icon(
                                Icons.calendar_today_rounded,
                              ),
                              suffixIcon: _selectedReleaseDate != null
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded),
                                      tooltip: t.home.removeImage,
                                      onPressed: () => setState(
                                        () => _selectedReleaseDate = null,
                                      ),
                                    )
                                  : null,
                              hintText: _releaseDateDisplay,
                            ),
                            controller: TextEditingController(
                              text: _releaseDateDisplay ?? '',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSize.s16),
                      TextFormField(
                        controller: _genresController,
                        decoration: InputDecoration(
                          labelText: t.home.genresOptional,
                          prefixIcon: const Icon(Icons.label_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: AppSize.s16),
                      TextFormField(
                        controller: _publisherController,
                        decoration: InputDecoration(
                          labelText: t.home.publisherOptional,
                          prefixIcon: const Icon(Icons.business_rounded),
                        ),
                      ),
                      if (_selectedCategory == Category.games) ...[
                        const SizedBox(height: AppSize.s16),
                        TextFormField(
                          controller: _platformsController,
                          decoration: InputDecoration(
                            labelText: t.home.platformsOptional,
                            prefixIcon: const Icon(Icons.gamepad_outlined),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(t.errorHandler.cancel),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.save_rounded, size: 18),
          label: Text(t.apiSettings.save),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
