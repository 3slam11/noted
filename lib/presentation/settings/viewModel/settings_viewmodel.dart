import 'dart:async';
import 'dart:ui';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/gen/strings.g.dart'; // For AppLocale and LocaleSettings
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/resources/theme_manager.dart';
import 'package:rxdart/rxdart.dart';

class SettingsViewModel extends BaseViewModel
    implements SettingsViewModelInputs, SettingsViewModelOutputs {
  final AppPrefs appPrefs;
  final ThemeManager themeManager;

  // --- Output Streams ---
  final _currentLanguageStreamController = BehaviorSubject<String>();
  final _currentThemeModeStreamController = BehaviorSubject<ThemeType>();
  final _currentManualThemeStreamController = BehaviorSubject<FlexScheme>();
  final _availableLanguagesStreamController = BehaviorSubject<List<Locale>>();
  final _availableManualThemesStreamController =
      BehaviorSubject<List<FlexScheme>>();

  // --- Constructor ---
  SettingsViewModel(this.appPrefs, this.themeManager);

  // --- BaseViewModel Overrides ---
  @override
  void start() {
    _loadAppSettings();
    _availableLanguagesStreamController.add(AppLocaleUtils.supportedLocales);
    _availableManualThemesStreamController.add(
      ThemeManager.monthlySchemes.values.toList(),
    );
  }

  @override
  void dispose() {
    _currentLanguageStreamController.close();
    _currentThemeModeStreamController.close();
    _currentManualThemeStreamController.close();
    _availableLanguagesStreamController.close();
    _availableManualThemesStreamController.close();
    super.dispose();
  }

  // --- Private Helper Methods ---
  Future<void> _loadAppSettings() async {
    // Language
    final language = await appPrefs.getLanguage();
    inputCurrentLanguage.add(language);

    // Theme Mode
    final themeModeIndex = await appPrefs.getThemeMode();
    final themeMode = ThemeType.values[themeModeIndex];
    inputCurrentThemeMode.add(themeMode);

    // Manual Theme
    final manualThemeIndex = await appPrefs.getManualTheme();
    if (manualThemeIndex >= 0 &&
        manualThemeIndex < ThemeManager.monthlySchemes.values.length) {
      inputCurrentManualTheme.add(
        ThemeManager.monthlySchemes.values.elementAt(manualThemeIndex),
      );
    } else {
      inputCurrentManualTheme.add(
        ThemeManager.monthlySchemes.values.first,
      ); // Default
    }
  }

  // --- Inputs Implementation ---
  @override
  Sink<String> get inputCurrentLanguage =>
      _currentLanguageStreamController.sink;

  @override
  Sink<ThemeType> get inputCurrentThemeMode =>
      _currentThemeModeStreamController.sink;

  @override
  Sink<FlexScheme> get inputCurrentManualTheme =>
      _currentManualThemeStreamController.sink;

  @override
  Future<void> setLanguage(String languageCode) async {
    await appPrefs.setLanguage(languageCode);
    LocaleSettings.setLocaleRaw(languageCode); // Update slang's active locale
    inputCurrentLanguage.add(languageCode);
    // MyApp will rebuild due to LocaleProvider, and other widgets will get new translations.
  }

  @override
  Future<void> setThemeMode(ThemeType mode) async {
    if (mode == ThemeType.auto) {
      await themeManager.setAutoTheme(); // This will notify listeners
    } else {
      // mode == tm.ThemeMode.manual
      // Set the preference for manual mode. ThemeManager will notify.
      // The currently selected manual theme (or default) will be used.
      await appPrefs.setThemeMode(ThemeType.manual.index);
      themeManager.notifyThemeChange();
    }
    inputCurrentThemeMode.add(mode);
  }

  @override
  Future<void> setManualTheme(FlexScheme scheme) async {
    await themeManager.setManualTheme(
      scheme,
    ); // This sets mode to manual and notifies
    inputCurrentManualTheme.add(scheme);
    // Ensure theme mode stream also reflects manual
    if (_currentThemeModeStreamController.valueOrNull != ThemeType.manual) {
      inputCurrentThemeMode.add(ThemeType.manual);
    }
  }

  // --- Outputs Implementation ---
  @override
  Stream<String> get outputCurrentLanguage =>
      _currentLanguageStreamController.stream;

  @override
  Stream<ThemeType> get outputCurrentThemeMode =>
      _currentThemeModeStreamController.stream;

  @override
  Stream<FlexScheme> get outputCurrentManualTheme =>
      _currentManualThemeStreamController.stream;

  @override
  Stream<List<Locale>> get outputAvailableLanguages =>
      _availableLanguagesStreamController.stream;

  @override
  Stream<List<FlexScheme>> get outputAvailableManualThemes =>
      _availableManualThemesStreamController.stream;
}

// --- Abstract Interfaces ---
abstract class SettingsViewModelInputs {
  Sink<String> get inputCurrentLanguage;
  Sink<ThemeType> get inputCurrentThemeMode;
  Sink<FlexScheme> get inputCurrentManualTheme;

  Future<void> setLanguage(String languageCode);
  Future<void> setThemeMode(ThemeType mode);
  Future<void> setManualTheme(FlexScheme scheme);
}

abstract class SettingsViewModelOutputs {
  Stream<String> get outputCurrentLanguage;
  Stream<ThemeType> get outputCurrentThemeMode;
  Stream<FlexScheme> get outputCurrentManualTheme;
  Stream<List<Locale>> get outputAvailableLanguages;
  Stream<List<FlexScheme>> get outputAvailableManualThemes;
}
