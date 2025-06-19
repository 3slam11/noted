import 'package:flutter/material.dart';
import 'package:noted/presentation/resources/font_manager.dart';

TextStyle getLightStyle({double? fontSize, Color? color}) {
  return TextStyle(
    fontWeight: FontWeightManager.light,
    fontSize: fontSize,
    color: color,
  );
}

TextStyle getRegularStyle({double? fontSize, Color? color}) {
  return TextStyle(
    fontWeight: FontWeightManager.regular,
    fontSize: fontSize,
    color: color,
  );
}

TextStyle getMediumStyle({double? fontSize, Color? color}) {
  return TextStyle(
    fontWeight: FontWeightManager.medium,
    fontSize: fontSize,
    color: color,
  );
}

TextStyle getSemiBoldStyle({double? fontSize, Color? color}) {
  return TextStyle(
    fontWeight: FontWeightManager.semiBold,
    fontSize: fontSize,
    color: color,
  );
}

TextStyle getBoldStyle({double? fontSize, Color? color}) {
  return TextStyle(
    fontWeight: FontWeightManager.bold,
    fontSize: fontSize,
    color: color,
  );
}
