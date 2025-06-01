import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/presentation/resources/font_manager.dart';
import 'package:noted/presentation/resources/style_manager.dart';
import 'package:noted/presentation/resources/values_manager.dart';

enum ThemeType { auto, manual }

class ThemeManager extends ChangeNotifier {
  final AppPrefs appPrefs;

  static const Map<int, FlexScheme> monthlySchemes = {
    1: FlexScheme.redM3,
    2: FlexScheme.pinkM3,
    3: FlexScheme.purpleM3,
    4: FlexScheme.indigoM3,
    5: FlexScheme.blueM3,
    6: FlexScheme.cyanM3,
    7: FlexScheme.tealM3,
    8: FlexScheme.orangeM3,
    9: FlexScheme.limeM3,
    10: FlexScheme.yellowM3,
    11: FlexScheme.greenM3,
    12: FlexScheme.deepOrangeM3,
  };

  ThemeManager(this.appPrefs);

  Future<FlexScheme> getCurrentTheme() async {
    final isManualMode =
        await appPrefs.getThemeMode() == ThemeType.manual.index;

    if (isManualMode) {
      final manualThemeIndex = await appPrefs.getManualTheme();
      if (manualThemeIndex >= 0 &&
          manualThemeIndex < monthlySchemes.values.length) {
        return monthlySchemes.values.elementAt(manualThemeIndex);
      }
    }
    return getMonthlyTheme();
  }

  FlexScheme getMonthlyTheme() {
    final currentMonth = DateTime.now().month;
    return monthlySchemes[currentMonth] ?? monthlySchemes.values.first;
  }

  Future<void> setManualTheme(FlexScheme scheme) async {
    await appPrefs.setManualTheme(
      monthlySchemes.values.toList().indexOf(scheme),
    );
    await appPrefs.setThemeMode(ThemeType.manual.index);
    notifyListeners();
  }

  Future<void> setAutoTheme() async {
    await appPrefs.setThemeMode(ThemeType.auto.index);
    notifyListeners();
  }

  void notifyThemeChange() {
    notifyListeners();
  }
}

ThemeData getApplicationTheme(FlexScheme scheme, BuildContext context) {
  final baseTheme = FlexThemeData.light(
    scheme: scheme,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      elevatedButtonSchemeColor: SchemeColor.primary,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      cardElevation: AppSize.s4,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedBorderIsColored: false,
      inputDecoratorRadius: AppSize.s8,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    fontFamily: 'El Messiri',
  );

  // card theme
  return baseTheme.copyWith(
    cardTheme: baseTheme.cardTheme.copyWith(
      color: baseTheme.colorScheme.primaryContainer,
      shadowColor: baseTheme.colorScheme.shadow,
      elevation: AppSize.s4,
    ),

    // app bar theme
    appBarTheme: baseTheme.appBarTheme.copyWith(
      color: baseTheme.colorScheme.primary,
      elevation: AppSize.s4,
      titleTextStyle: getRegularStyle(
        fontSize: FontSize.s16,
        color: baseTheme.colorScheme.onPrimary,
      ),
    ),

    // elevatedButtonTheme:
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(
          fontSize: FontSize.s17,
          color: baseTheme.colorScheme.onPrimary,
        ),
        backgroundColor: baseTheme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),

    // text theme
    textTheme: baseTheme.textTheme.copyWith(
      displayLarge: getSemiBoldStyle(
        fontSize: FontSize.s16,
        color: baseTheme.colorScheme.primary,
      ),
      titleMedium: getMediumStyle(
        fontSize: FontSize.s16,
        color: baseTheme.colorScheme.primary,
      ),
      bodyLarge: getRegularStyle(color: baseTheme.colorScheme.onSurface),
      bodySmall: getRegularStyle(color: baseTheme.colorScheme.onSurfaceVariant),
    ),

    // decoration theme
    inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
      contentPadding: EdgeInsets.all(AppPadding.p8),
      hintStyle: getRegularStyle(
        fontSize: FontSize.s14,
        color: baseTheme.colorScheme.onSurfaceVariant,
      ),

      // label style
      labelStyle: getMediumStyle(
        fontSize: FontSize.s14,
        color: baseTheme.colorScheme.primary,
      ),

      // error style
      errorStyle: getRegularStyle(color: baseTheme.colorScheme.error),

      // enabled border style
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorScheme.of(context).outline,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
      ),

      // focused border style
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: baseTheme.colorScheme.primary,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
      ),

      // error border style
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: baseTheme.colorScheme.error,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
      ),

      // focused error border style
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: baseTheme.colorScheme.primary,
          width: AppSize.s1_5,
        ),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8)),
      ),
    ),
  );
}
