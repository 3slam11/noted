import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:noted/app/app.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/app/di.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/resources/theme_manager.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  await initAppModule();
  final appPrefs = instance<AppPrefs>();

  // Load custom font if configured
  await _loadCustomFont(appPrefs);

  final savedLanguage = await appPrefs.getLanguage();
  LocaleSettings.setLocaleRaw(savedLanguage);

  runApp(TranslationProvider(child: const MyApp()));
}

Future<void> _loadCustomFont(AppPrefs appPrefs) async {
  try {
    final fontTypeIndex = await appPrefs.getFontType();
    if (fontTypeIndex >= FontType.values.length) return;
    final fontType = FontType.values[fontTypeIndex];

    if (fontType == FontType.custom) {
      final fontPath = await appPrefs.getCustomFontPath();
      final fontFamily = await appPrefs.getCustomFontFamilyName();

      if (fontPath.isNotEmpty &&
          fontFamily.isNotEmpty &&
          File(fontPath).existsSync()) {
        final fontLoader = FontLoader(fontFamily);
        fontLoader.addFont(
          File(
            fontPath,
          ).readAsBytes().then((bytes) => ByteData.view(bytes.buffer)),
        );
        await fontLoader.load();
        debugPrint("Custom font '$fontFamily' loaded from $fontPath");
      } else {
        debugPrint(
          "Custom font not found or info missing. Reverting to default.",
        );
        await appPrefs.setFontType(FontType.appDefault.index);
        await appPrefs.clearCustomFont();
      }
    }
  } catch (e) {
    debugPrint("Failed to load custom font: $e. Reverting to default.");
    await appPrefs.setFontType(FontType.appDefault.index);
    await appPrefs.clearCustomFont();
  }
}
