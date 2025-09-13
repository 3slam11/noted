import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  final ThemeManager _themeManager = instance<ThemeManager>();
  late Future<({FlexScheme scheme, String? fontFamily})> _themeFuture;

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_onThemeChanged);
    _themeFuture = _loadThemeAndFont();
  }

  Future<({FlexScheme scheme, String? fontFamily})> _loadThemeAndFont() async {
    final scheme = await _themeManager.getCurrentTheme();
    final fontFamily = await _themeManager.getCurrentFontFamily();
    return (scheme: scheme, fontFamily: fontFamily);
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {
        _themeFuture = _loadThemeAndFont();
      });
    }
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<({FlexScheme scheme, String? fontFamily})>(
      future: _themeFuture,
      builder: (context, snapshot) {
        final FlexScheme currentScheme =
            snapshot.data?.scheme ?? _themeManager.getMonthlyTheme();
        final String? currentFontFamily = snapshot.data?.fontFamily;

        return MaterialApp(
          title: t.appName,
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteGenerator.getRoute,
          initialRoute: RoutesManager.mainRoute,
          theme: getApplicationTheme(
            currentScheme,
            context,
            fontFamily: currentFontFamily,
          ),
        );
      },
    );
  }
}
