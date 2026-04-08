import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:noted/app/app_events.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/base/base_view_model.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer.dart';
import 'package:noted/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:noted/presentation/resources/theme_manager.dart';
import 'package:noted/presentation/settings/settings_view.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class SettingsViewModel extends BaseViewModel
    implements SettingsViewModelInputs, SettingsViewModelOutputs {
  final AppPrefs appPrefs;
  final ThemeManager themeManager;
  final DataGlobalNotifier dataGlobalNotifier;

  final _currentLanguageStreamController = BehaviorSubject<String>();
  final _currentThemeModeStreamController = BehaviorSubject<ThemeType>();
  final _currentManualThemeStreamController = BehaviorSubject<FlexScheme>();
  final _availableLanguagesStreamController = BehaviorSubject<List<Locale>>();
  final _availableManualThemesStreamController =
      BehaviorSubject<List<FlexScheme>>();
  final _currentFontTypeController = BehaviorSubject<FontType>();
  final _customFontInfoController = BehaviorSubject<String>();
  final _monthRolloverBehaviorController =
      BehaviorSubject<MonthRolloverBehavior>();
  final _showSeriesTrackerController = BehaviorSubject<bool>();
  final _showFilterToggleController = BehaviorSubject<bool>();

  SettingsViewModel(this.appPrefs, this.themeManager, this.dataGlobalNotifier);

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
    _currentFontTypeController.close();
    _customFontInfoController.close();
    _monthRolloverBehaviorController.close();
    _showSeriesTrackerController.close();
    _showFilterToggleController.close();
    super.dispose();
  }

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
    }

    // Font
    final fontTypeIndex = await appPrefs.getFontType();
    final fontType = FontType.values[fontTypeIndex];
    inputCurrentFontType.add(fontType);

    if (fontType == FontType.custom) {
      final path = await appPrefs.getCustomFontPath();
      final name = await appPrefs.getCustomFontFamilyName();
      if (path.isNotEmpty && name.isNotEmpty) {
        final fileName = path.split(Platform.pathSeparator).last;
        inputCustomFontInfo.add(fileName);
      } else {
        inputCustomFontInfo.add(t.fontSettings.noCustomFont);
      }
    }

    // Month Rollover
    final behaviorIndex = await appPrefs.getMonthRolloverBehavior();
    inputMonthRolloverBehavior.add(MonthRolloverBehavior.values[behaviorIndex]);

    // Show Series Tracker
    final showTracker = await appPrefs.getShowSeriesTracker();
    inputShowSeriesTracker.add(showTracker);

    // Show Filter Toggle
    final showFilterToggle = await appPrefs.getShowFilterToggle();
    inputShowFilterToggle.add(showFilterToggle);
  }

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
  Sink<FontType> get inputCurrentFontType => _currentFontTypeController.sink;

  @override
  Sink<String> get inputCustomFontInfo => _customFontInfoController.sink;

  @override
  Sink<MonthRolloverBehavior> get inputMonthRolloverBehavior =>
      _monthRolloverBehaviorController.sink;

  @override
  Sink<bool> get inputShowSeriesTracker => _showSeriesTrackerController.sink;

  @override
  Sink<bool> get inputShowFilterToggle => _showFilterToggleController.sink;

  @override
  Future<void> setLanguage(String languageCode) async {
    await appPrefs.setLanguage(languageCode);
    LocaleSettings.setLocaleRaw(languageCode);
    inputCurrentLanguage.add(languageCode);
  }

  @override
  Future<void> setThemeMode(ThemeType mode) async {
    await appPrefs.setThemeMode(mode.index);
    themeManager.notifyThemeChange();
    inputCurrentThemeMode.add(mode);
  }

  @override
  Future<void> setManualTheme(FlexScheme scheme) async {
    await themeManager.setManualTheme(scheme);
    inputCurrentManualTheme.add(scheme);
    if (_currentThemeModeStreamController.valueOrNull != ThemeType.manual) {
      inputCurrentThemeMode.add(ThemeType.manual);
    }
  }

  @override
  Future<void> setFontType(FontType type) async {
    await appPrefs.setFontType(type.index);
    inputCurrentFontType.add(type);
    themeManager.notifyThemeChange();
  }

  @override
  Future<void> setCustomFont(String filePath, String fontFamilyName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final newPath = p.join(appDir.path, 'fonts', p.basename(filePath));
      final newFile = File(newPath);
      if (!await newFile.parent.exists()) {
        await newFile.parent.create(recursive: true);
      }
      await File(filePath).copy(newPath);

      await appPrefs.setCustomFontPath(newPath);
      await appPrefs.setCustomFontFamilyName(fontFamilyName);
      await appPrefs.setFontType(FontType.custom.index);

      final fontLoader = FontLoader(fontFamilyName);
      fontLoader.addFont(
        newFile.readAsBytes().then((bytes) => ByteData.view(bytes.buffer)),
      );
      await fontLoader.load();
      debugPrint("Custom font '$fontFamilyName' loaded dynamically.");

      inputCurrentFontType.add(FontType.custom);
      final fileName = newPath.split(Platform.pathSeparator).last;
      inputCustomFontInfo.add('$fontFamilyName ($fileName)');
      themeManager.notifyThemeChange();
    } catch (e) {
      inputState.add(
        ErrorState(
          stateRendererType: StateRendererType.popupErrorState,
          message: "Failed to load font. ${e.toString()}",
        ),
      );
    }
  }

  @override
  Future<void> clearCustomFont() async {
    await appPrefs.clearCustomFont();
    await setFontType(FontType.appDefault);
    inputCustomFontInfo.add(t.fontSettings.noCustomFont);
  }

  @override
  Future<void> setMonthRolloverBehavior(MonthRolloverBehavior behavior) async {
    await appPrefs.setMonthRolloverBehavior(behavior.index);
    inputMonthRolloverBehavior.add(behavior);
  }

  @override
  Future<void> setShowSeriesTracker(bool show) async {
    await appPrefs.setShowSeriesTracker(show);
    inputShowSeriesTracker.add(show);
    dataGlobalNotifier.notifyDataImported();
  }

  @override
  Future<void> setShowFilterToggle(bool show) async {
    await appPrefs.setShowFilterToggle(show);
    inputShowFilterToggle.add(show);
    dataGlobalNotifier.notifyDataImported();
  }

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

  @override
  Stream<FontType> get outputCurrentFontType =>
      _currentFontTypeController.stream;

  @override
  Stream<String> get outputCustomFontInfo => _customFontInfoController.stream;

  @override
  Stream<MonthRolloverBehavior> get outputMonthRolloverBehavior =>
      _monthRolloverBehaviorController.stream;

  @override
  Stream<bool> get outputShowSeriesTracker =>
      _showSeriesTrackerController.stream;

  @override
  Stream<bool> get outputShowFilterToggle => _showFilterToggleController.stream;
}

abstract class SettingsViewModelInputs {
  Sink<String> get inputCurrentLanguage;
  Sink<ThemeType> get inputCurrentThemeMode;
  Sink<FlexScheme> get inputCurrentManualTheme;
  Sink<FontType> get inputCurrentFontType;
  Sink<String> get inputCustomFontInfo;
  Sink<MonthRolloverBehavior> get inputMonthRolloverBehavior;
  Sink<bool> get inputShowSeriesTracker;
  Sink<bool> get inputShowFilterToggle;

  Future<void> setLanguage(String languageCode);
  Future<void> setThemeMode(ThemeType mode);
  Future<void> setManualTheme(FlexScheme scheme);
  Future<void> setFontType(FontType type);
  Future<void> setCustomFont(String filePath, String fontFamilyName);
  Future<void> clearCustomFont();
  Future<void> setMonthRolloverBehavior(MonthRolloverBehavior behavior);
  Future<void> setShowSeriesTracker(bool show);
  Future<void> setShowFilterToggle(bool show);
}

abstract class SettingsViewModelOutputs {
  Stream<String> get outputCurrentLanguage;
  Stream<ThemeType> get outputCurrentThemeMode;
  Stream<FlexScheme> get outputCurrentManualTheme;
  Stream<List<Locale>> get outputAvailableLanguages;
  Stream<List<FlexScheme>> get outputAvailableManualThemes;
  Stream<FontType> get outputCurrentFontType;
  Stream<String> get outputCustomFontInfo;
  Stream<MonthRolloverBehavior> get outputMonthRolloverBehavior;
  Stream<bool> get outputShowSeriesTracker;
  Stream<bool> get outputShowFilterToggle;
}
