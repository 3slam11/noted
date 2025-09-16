import 'package:file_picker/file_picker.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:noted/app/di.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/resources/routes_manager.dart';
import 'package:noted/presentation/resources/theme_manager.dart';
import 'package:noted/presentation/resources/values_manager.dart';
import 'package:noted/presentation/settings/viewModel/settings_viewmodel.dart';

enum MonthRolloverBehavior { full, partial, manual }

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsViewModel viewModel = instance<SettingsViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.start();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: ListView(
        primary: true,
        children: [
          _buildLanguageSettings(context),
          const SizedBox(height: AppSize.s12),
          _buildThemeSettings(context),
          const SizedBox(height: AppSize.s12),
          _buildFontSettings(context),
          const SizedBox(height: AppSize.s12),
          _buildMonthRolloverSettings(context),
          const SizedBox(height: AppSize.s12),
          _buildSettingCard(
            context,
            title: t.settings.apiChange,
            icon: Icons.api,
            onTap: () {
              Navigator.pushNamed(context, RoutesManager.changeApiRoute);
            },
          ),
          const SizedBox(height: AppSize.s12),
          _buildSettingCard(
            context,
            title: t.settings.backupAndRestore,
            icon: Icons.backup,
            onTap: () {
              Navigator.pushNamed(context, RoutesManager.backupAndRestoreRoute);
            },
          ),
          const SizedBox(height: AppSize.s12),
          _buildSettingCard(
            context,
            title: t.settings.statistics,
            icon: Icons.bar_chart,
            onTap: () {
              Navigator.pushNamed(context, RoutesManager.statisticsRoute);
            },
          ),
          const SizedBox(height: AppSize.s12),
          _buildSettingCard(
            context,
            title: t.settings.about,
            icon: Icons.info_outline,
            onTap: () {
              Navigator.pushNamed(context, RoutesManager.aboutRoute);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthRolloverSettings(BuildContext context) {
    return StreamBuilder<MonthRolloverBehavior>(
      stream: viewModel.outputMonthRolloverBehavior,
      builder: (context, snapshot) {
        final behavior = snapshot.data ?? MonthRolloverBehavior.full;
        String subtitle;
        switch (behavior) {
          case MonthRolloverBehavior.full:
            subtitle = t.settings.rolloverFull;
            break;
          case MonthRolloverBehavior.partial:
            subtitle = t.settings.rolloverPartial;
            break;
          case MonthRolloverBehavior.manual:
            subtitle = t.settings.rolloverManual;
            break;
        }

        return _buildSettingCard(
          context,
          title: t.settings.monthRolloverBehavior,
          subtitle: subtitle,
          icon: Icons.calendar_month_outlined,
          onTap: () => _showMonthRolloverDialog(context),
        );
      },
    );
  }

  void _showMonthRolloverDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.settings.monthRolloverBehavior),
        content: StreamBuilder<MonthRolloverBehavior>(
          stream: viewModel.outputMonthRolloverBehavior,
          builder: (context, snapshot) {
            final currentBehavior = snapshot.data ?? MonthRolloverBehavior.full;
            return RadioGroup<MonthRolloverBehavior>(
              groupValue: currentBehavior,
              onChanged: (MonthRolloverBehavior? value) {
                if (value != null) {
                  viewModel.setMonthRolloverBehavior(value);
                  Navigator.pop(context);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<MonthRolloverBehavior>(
                    title: Text(t.settings.rolloverFull),
                    subtitle: Text(t.settings.rolloverFullDescription),
                    value: MonthRolloverBehavior.full,
                  ),
                  RadioListTile<MonthRolloverBehavior>(
                    title: Text(t.settings.rolloverPartial),
                    subtitle: Text(t.settings.rolloverPartialDescription),
                    value: MonthRolloverBehavior.partial,
                  ),
                  RadioListTile<MonthRolloverBehavior>(
                    title: Text(t.settings.rolloverManual),
                    subtitle: Text(t.settings.rolloverManualDescription),
                    value: MonthRolloverBehavior.manual,
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.errorHandler.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSettings(BuildContext context) {
    return StreamBuilder<String>(
      stream: viewModel.outputCurrentLanguage,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildSettingCard(
            context,
            title: t.settings.language,
            icon: Icons.language,
            onTap: () {},
          );
        }

        final currentLangCode = snapshot.data!;
        final currentLanguageName = getLanguageName(currentLangCode);

        return _buildSettingCard(
          context,
          title: t.settings.language,
          subtitle: currentLanguageName,
          icon: Icons.language,
          onTap: () => _showLanguageDialog(context),
        );
      },
    );
  }

  Widget _buildThemeSettings(BuildContext context) {
    return StreamBuilder<ThemeType>(
      stream: viewModel.outputCurrentThemeMode,
      builder: (context, snapshotThemeMode) {
        if (!snapshotThemeMode.hasData) {
          return _buildSettingCard(
            context,
            title: t.settings.theme,
            icon: Icons.palette,
            onTap: () {},
          );
        }

        final currentThemeMode = snapshotThemeMode.data!;
        String themeDescription = currentThemeMode == ThemeType.auto
            ? t.themeSettings.autoTheme
            : t.themeSettings.manualTheme;

        return _buildSettingCard(
          context,
          title: t.settings.theme,
          subtitle: themeDescription,
          icon: Icons.palette,
          onTap: () => _showThemeDialog(context),
        );
      },
    );
  }

  Widget _buildFontSettings(BuildContext context) {
    return StreamBuilder<FontType>(
      stream: viewModel.outputCurrentFontType,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final fontType = snapshot.data!;
        String subtitle;
        switch (fontType) {
          case FontType.appDefault:
            subtitle = t.settings.appDefaultFont;
            break;
          case FontType.systemDefault:
            subtitle = t.settings.systemFont;
            break;
          case FontType.custom:
            subtitle = t.settings.customFont;
            break;
        }

        return _buildSettingCard(
          context,
          title: t.settings.font,
          subtitle: subtitle,
          icon: Icons.font_download,
          onTap: () => _showFontDialog(context),
        );
      },
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p8,
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: AppSize.s28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppSize.s18,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: AppSize.s14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.primary,
          size: AppSize.s20,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          t.languageSettings.selectLanguage,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
          ),
        ),
        content: StreamBuilder<List<Locale>>(
          stream: viewModel.outputAvailableLanguages,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No languages available.');
            }

            final availableLanguages = snapshot.data!;

            return SizedBox(
              width: double.maxFinite,
              child: StreamBuilder<String>(
                stream: viewModel.outputCurrentLanguage,
                builder: (context, currentLangSnapshot) {
                  if (!currentLangSnapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final currentLangCode = currentLangSnapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableLanguages.length,
                    itemBuilder: (context, index) {
                      final locale = availableLanguages[index];
                      final isSelected = locale.languageCode == currentLangCode;

                      return ListTile(
                        title: Text(getLanguageName(locale.languageCode)),
                        onTap: () {
                          viewModel.setLanguage(locale.languageCode);
                          Navigator.pop(context);
                        },
                        trailing: isSelected
                            ? Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.errorHandler.cancel),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.themeSettings.themeSettings),
        content: SingleChildScrollView(
          child: StreamBuilder<ThemeType>(
            stream: viewModel.outputCurrentThemeMode,
            builder: (context, themeSnapshot) {
              if (!themeSnapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final currentThemeMode = themeSnapshot.data!;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: Text(t.themeSettings.autoTheme),
                    subtitle: Text(
                      t.themeSettings.autoThemeDescription,
                      style: const TextStyle(fontSize: 12),
                    ),
                    value: currentThemeMode == ThemeType.auto,
                    onChanged: (value) {
                      viewModel.setThemeMode(
                        value ? ThemeType.auto : ThemeType.manual,
                      );
                    },
                  ),
                  const Divider(),
                  if (currentThemeMode == ThemeType.manual) ...[
                    Text(
                      t.themeSettings.selectTheme,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<FlexScheme>(
                      stream: viewModel.outputCurrentManualTheme,
                      builder: (context, manualThemeSnapshot) {
                        if (!manualThemeSnapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final currentManualScheme = manualThemeSnapshot.data!;

                        return StreamBuilder<List<FlexScheme>>(
                          stream: viewModel.outputAvailableManualThemes,
                          builder: (context, availableThemesSnapshot) {
                            if (!availableThemesSnapshot.hasData ||
                                availableThemesSnapshot.data!.isEmpty) {
                              return const Text('No themes available.');
                            }

                            final availableThemes =
                                availableThemesSnapshot.data!;

                            return RadioGroup<FlexScheme>(
                              groupValue: currentManualScheme,
                              onChanged: (FlexScheme? value) {
                                if (value != null) {
                                  viewModel.setManualTheme(value);
                                }
                              },
                              child: Column(
                                children: availableThemes.map((scheme) {
                                  return RadioListTile<FlexScheme>(
                                    title: Text(scheme.name),
                                    value: scheme,
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.errorHandler.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.stateRenderer.ok),
          ),
        ],
      ),
    );
  }

  void _showFontDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FontSelectionDialog(viewModel: viewModel),
    );
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return t.languageSettings.en;
      case 'ar':
        return t.languageSettings.ar;
      default:
        return code;
    }
  }
}

class FontSelectionDialog extends StatefulWidget {
  final SettingsViewModel viewModel;
  const FontSelectionDialog({super.key, required this.viewModel});

  @override
  State<FontSelectionDialog> createState() => _FontSelectionDialogState();
}

class _FontSelectionDialogState extends State<FontSelectionDialog> {
  final TextEditingController _fontFamilyController = TextEditingController();

  @override
  void dispose() {
    _fontFamilyController.dispose();
    super.dispose();
  }

  void _pickAndSetFont() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ttf', 'otf'],
      dialogTitle: t.fontSettings.selectFontFile,
    );

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fontFamilyName = 'custom';

      if (fontFamilyName.isNotEmpty) {
        await widget.viewModel.setCustomFont(filePath, fontFamilyName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.fontSettings.title),
      content: StreamBuilder<FontType>(
        stream: widget.viewModel.outputCurrentFontType,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final currentType = snapshot.data!;

          return SingleChildScrollView(
            child: RadioGroup<FontType>(
              groupValue: currentType,
              onChanged: (FontType? value) async {
                if (value != null) {
                  await widget.viewModel.setFontType(value);
                  if (value == FontType.custom) {
                    final path = await widget.viewModel.appPrefs
                        .getCustomFontPath();
                    if (path.isEmpty) {
                      _pickAndSetFont();
                    }
                  }
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFontOption(
                    context: context,
                    title: t.settings.appDefaultFont,
                    fontType: FontType.appDefault,
                    currentType: currentType,
                  ),
                  _buildFontOption(
                    context: context,
                    title: t.settings.systemFont,
                    fontType: FontType.systemDefault,
                    currentType: currentType,
                  ),
                  _buildFontOption(
                    context: context,
                    title: t.settings.customFont,
                    fontType: FontType.custom,
                    currentType: currentType,
                  ),
                  if (currentType == FontType.custom) ...[
                    const SizedBox(height: 20),
                    _buildCustomFontDetails(context),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.home.close),
        ),
      ],
    );
  }

  Widget _buildFontOption({
    required BuildContext context,
    required String title,
    required FontType fontType,
    required FontType currentType,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = currentType == fontType;

    return InkWell(
      onTap: () {
        // The RadioGroup handles the onChanged callback,
        // but we can still provide tap feedback
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                ),
              ),
            ),
            Radio<FontType>(value: fontType, activeColor: colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomFontDetails(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StreamBuilder<String>(
      stream: widget.viewModel.outputCustomFontInfo,
      builder: (context, infoSnapshot) {
        final info = infoSnapshot.data ?? t.fontSettings.noCustomFont;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  t.settings.customFontDetails,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                info,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => widget.viewModel.clearCustomFont(),
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: Text(t.fontSettings.remove),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _pickAndSetFont,
                  icon: const Icon(Icons.upload_rounded, size: 18),
                  label: Text(t.fontSettings.change),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
