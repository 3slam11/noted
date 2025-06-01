import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/app/di.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/resources/routes_manager.dart';
import 'package:noted/presentation/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPrefs appPrefs = instance<AppPrefs>();
  final ThemeManager themeManager = instance<ThemeManager>();

  @override
  void initState() {
    super.initState();
    themeManager.addListener(onThemeChanged);
  }

  void onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    themeManager.removeListener(onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FlexScheme>(
      future: themeManager.getCurrentTheme(),
      builder: (context, snapshot) {
        FlexScheme currentScheme;
        currentScheme = snapshot.data!;

        return MaterialApp(
          title: t.appName,
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteGenerator.getRoute,
          initialRoute: RoutesManager.mainRoute,
          theme: getApplicationTheme(currentScheme, context),
        );
      },
    );
  }
}
