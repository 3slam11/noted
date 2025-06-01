import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:noted/app/di.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/resources/routes_manager.dart';
import 'package:noted/presentation/resources/theme_manager.dart';
import 'package:noted/presentation/resources/values_manager.dart';
import 'package:noted/presentation/settings/viewModel/settings_viewmodel.dart';

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
          t.settings.settings,
          style: TextStyle(
            fontSize: 23,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: ListView(
          children: [
            _buildLanguageSettings(context),
            const SizedBox(height: AppSize.s12),
            _buildThemeSettings(context),
            const SizedBox(height: AppSize.s12),
            _buildSettingCard(
              context,
              title: t.settings.history,
              icon: Icons.history,
              onTap: () {
                Navigator.pushNamed(context, RoutesManager.historyRoute);
              },
            ),
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
                Navigator.pushNamed(
                  context,
                  RoutesManager.backupAndRestoreRoute,
                );
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

  Widget _buildSettingCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: AppSize.s0,
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
              return const Text("No languages available.");
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
                  // Auto theme toggle
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

                  // Manual theme selection
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
                              return const Text("No themes available.");
                            }

                            final availableThemes =
                                availableThemesSnapshot.data!;

                            return Column(
                              children: availableThemes.map((scheme) {
                                return RadioListTile<FlexScheme>(
                                  title: Text(scheme.name),
                                  value: scheme,
                                  groupValue: currentManualScheme,
                                  onChanged: (value) {
                                    if (value != null) {
                                      viewModel.setManualTheme(value);
                                    }
                                  },
                                );
                              }).toList(),
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
