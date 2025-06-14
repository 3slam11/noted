import 'package:noted/app/constants.dart';
import 'package:noted/presentation/resources/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String languagePref = 'LANGUAGE_PREF';
const String loggedInPref = 'IS_LOGGED_IN_PREF';
const String themeModePref = 'THEME_MODE_PREF';
const String manualThemePref = 'MANUAL_THEME_PREF';
const String hasSeenDisclaimer = 'HAS_SEEN_DISCLAIMER';
const String lastOpenedMonth = 'LAST_OPENED_MONTH';
const String customRawgApiKeyPref = 'CUSTOM_RAWG_API_KEY';
const String customTmdbApiKeyPref = 'CUSTOM_TMDB_API_KEY';
const String customBooksApiKeyPref = 'CUSTOM_BOOKS_API_KEY';

class AppPrefs {
  final SharedPreferences sharedPreferences;

  AppPrefs(this.sharedPreferences);

  Future<String> getLanguage() async {
    String? language =
        sharedPreferences.getString(languagePref) ?? Constants.language;

    return language;
  }

  Future<void> setLanguage(String languageCode) async {
    await sharedPreferences.setString(languagePref, languageCode);
  }

  Future<void> setIsLoggedIn() async {
    await sharedPreferences.setBool(loggedInPref, true);
  }

  Future<bool> getIsLoggedIn() async {
    return sharedPreferences.getBool(loggedInPref) ?? false;
  }

  Future<void> logout() async {
    await sharedPreferences.setBool(loggedInPref, false);
  }

  Future<void> setHasSeenDisclaimer(bool viewed) async {
    await sharedPreferences.setBool(hasSeenDisclaimer, viewed);
  }

  Future<bool> getHasSeenDisclaimer() async {
    return sharedPreferences.getBool(hasSeenDisclaimer) ?? false;
  }

  Future<void> setThemeMode(int mode) async {
    await sharedPreferences.setInt(themeModePref, mode);
  }

  Future<int> getThemeMode() async {
    return sharedPreferences.getInt(themeModePref) ?? ThemeType.auto.index;
  }

  Future<void> setManualTheme(int index) async {
    await sharedPreferences.setInt(manualThemePref, index);
  }

  Future<int> getManualTheme() async {
    return sharedPreferences.getInt(manualThemePref) ?? 0;
  }

  Future<void> setLastOpenedMonth(int month) async {
    await sharedPreferences.setInt(lastOpenedMonth, month);
  }

  Future<int?> getLastOpenedMonth() async {
    return sharedPreferences.getInt(lastOpenedMonth);
  }

  Future<String> getCustomRawgApiKey() async {
    return sharedPreferences.getString(customRawgApiKeyPref) ?? '';
  }

  Future<void> setCustomRawgApiKey(String key) async {
    await sharedPreferences.setString(customRawgApiKeyPref, key);
  }

  Future<void> removeCustomRawgApiKey() async {
    await sharedPreferences.remove(customRawgApiKeyPref);
  }

  Future<String> getCustomTmdbApiKey() async {
    return sharedPreferences.getString(customTmdbApiKeyPref) ?? '';
  }

  Future<void> setCustomTmdbApiKey(String key) async {
    await sharedPreferences.setString(customTmdbApiKeyPref, key);
  }

  Future<void> removeCustomTmdbApiKey() async {
    await sharedPreferences.remove(customTmdbApiKeyPref);
  }

  Future<String> getCustomBooksApiKey() async {
    return sharedPreferences.getString(customBooksApiKeyPref) ?? '';
  }

  Future<void> setCustomBooksApiKey(String key) async {
    await sharedPreferences.setString(customBooksApiKeyPref, key);
  }

  Future<void> removeCustomBooksApiKey() async {
    await sharedPreferences.remove(customBooksApiKeyPref);
  }
}
