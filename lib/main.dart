import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:noted/app/app.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/app/di.dart';
import 'package:noted/gen/strings.g.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  await initAppModule();
  final appPrefs = instance<AppPrefs>();
  final savedLanguage = await appPrefs.getLanguage();
  LocaleSettings.setLocaleRaw(savedLanguage);

  runApp(TranslationProvider(child: MyApp()));
}
