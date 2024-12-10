import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF50644C);
  static const success = Color(0xFF208920);
  static const textBorder = Color(0xFF181D17);
  static const smallBtnBackground = Color(0xFFDDE5DB);
  static const fadedButton = Color(0xFFa4aea2);
  static const textFieldBorder = Color(0xFFDDE5DB);
  static const background = Color(0xffffffff);
  static const dividerColor = Color(0xffDDE5DB);
  static const successColor = Color(0xffCFEAC7);
  static const dashColor = Color(0xffDDE5DB);
  static const hintColor = Color(0xffE3E3DE);
  static const secondBackground = Color(0xff342F3F); //#
  static const Color primaryBaseColor = Color(0xFF50644C);
  static const Color deleteBtn = Color(0xffA93532);

  // Primary Swatch generated from the custom color
  static final MaterialColor primarySwatch =
      createMaterialColor(primaryBaseColor);

  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
