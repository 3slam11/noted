import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/presentation/resources/font_manager.dart';
import 'package:noted/presentation/resources/style_manager.dart';
import 'package:noted/presentation/resources/values_manager.dart';

enum ThemeType { auto, manual }

enum FontType { appDefault, systemDefault, custom }

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

  Future<String?> getCurrentFontFamily() async {
    final fontTypeIndex = await appPrefs.getFontType();
    final fontType = FontType.values[fontTypeIndex];

    switch (fontType) {
      case FontType.appDefault:
        return FontConstants.fontFamily;
      case FontType.systemDefault:
        return null;
      case FontType.custom:
        final familyName = await appPrefs.getCustomFontFamilyName();
        return familyName.isNotEmpty ? familyName : FontConstants.fontFamily;
    }
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

ThemeData getApplicationTheme(
  FlexScheme scheme,
  BuildContext context, {
  String? fontFamily,
}) {
  final baseTheme = FlexThemeData.light(
    scheme: scheme,
    subThemesData: const FlexSubThemesData(
      elevatedButtonSchemeColor: SchemeColor.primary,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      cardElevation: AppSize.s0,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedBorderIsColored: false,
      inputDecoratorRadius: AppSize.s8,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    fontFamily: fontFamily,
  );

  return baseTheme.copyWith(
    textTheme: baseTheme.textTheme.copyWith(
      displayLarge: getSemiBoldStyle(
        fontSize: FontSize.s16,
        color: baseTheme.colorScheme.primary,
      ).copyWith(fontFamily: fontFamily),
      titleMedium: getMediumStyle(
        fontSize: FontSize.s16,
        color: baseTheme.colorScheme.primary,
      ).copyWith(fontFamily: fontFamily),
      bodyLarge: getRegularStyle(
        color: baseTheme.colorScheme.onSurface,
      ).copyWith(fontFamily: fontFamily),
      bodySmall: getRegularStyle(
        color: baseTheme.colorScheme.onSurfaceVariant,
      ).copyWith(fontFamily: fontFamily),
    ),

    // card theme
    cardTheme: baseTheme.cardTheme.copyWith(
      color: baseTheme.colorScheme.primaryContainer,
      shadowColor: baseTheme.colorScheme.shadow,
      margin: EdgeInsets.zero,
      elevation: AppSize.s0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    // app bar theme
    appBarTheme: baseTheme.appBarTheme.copyWith(
      backgroundColor: baseTheme.colorScheme.primary,
      elevation: AppSize.s0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSize.s30),
          bottomRight: Radius.circular(AppSize.s30),
        ),
      ),
      titleTextStyle: getRegularStyle(
        fontSize: FontSize.s22,
        color: baseTheme.colorScheme.onPrimary,
      ).copyWith(fontFamily: fontFamily),
      iconTheme: IconThemeData(color: baseTheme.colorScheme.onPrimary),
      actionsIconTheme: IconThemeData(color: baseTheme.colorScheme.onPrimary),
    ),

    // elevatedButtonTheme:
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(
          fontSize: FontSize.s17,
          color: baseTheme.colorScheme.onPrimary,
        ).copyWith(fontFamily: fontFamily),
        backgroundColor: baseTheme.colorScheme.primary,
        foregroundColor: baseTheme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
      ),
    ),

    // input decoration theme
    inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
      contentPadding: const EdgeInsets.all(AppPadding.p8),
      hintStyle: getRegularStyle(
        fontSize: FontSize.s14,
        color: baseTheme.colorScheme.onSurfaceVariant,
      ).copyWith(fontFamily: fontFamily),

      // label style
      labelStyle: getMediumStyle(
        fontSize: FontSize.s14,
        color: baseTheme.colorScheme.primary,
      ).copyWith(fontFamily: fontFamily),

      // error style
      errorStyle: getRegularStyle(
        color: baseTheme.colorScheme.error,
      ).copyWith(fontFamily: fontFamily),

      // enabled border style
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorScheme.of(context).outline,
          width: AppSize.s1_5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
      ),

      // focused border style
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: baseTheme.colorScheme.primary,
          width: AppSize.s1_5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
      ),

      // error border style
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: baseTheme.colorScheme.error,
          width: AppSize.s1_5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
      ),

      // focused error border style
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: baseTheme.colorScheme.primary,
          width: AppSize.s1_5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8)),
      ),
    ),

    // icon theme
    iconTheme: baseTheme.iconTheme.copyWith(
      color: baseTheme.colorScheme.primary,
    ),

    // divider theme
    dividerTheme: baseTheme.dividerTheme.copyWith(
      color: baseTheme.colorScheme.primary,
      thickness: AppSize.s1,
      indent: AppSize.s20,
      endIndent: AppSize.s20,
    ),

    // chip theme
    chipTheme: baseTheme.chipTheme.copyWith(
      backgroundColor: baseTheme.colorScheme.primaryContainer,
      side: BorderSide(
        width: AppSize.s0,
        color: baseTheme.colorScheme.primaryContainer,
      ),
      elevation: AppSize.s0,
      selectedColor: baseTheme.colorScheme.primary,
    ),
  );
}
