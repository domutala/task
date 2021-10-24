import 'dart:math';
import 'package:flutter/material.dart';

class Colored {
  static Color primary = const Color.fromRGBO(150, 109, 232, 1);
  static Color light = const Color.fromRGBO(33, 33, 33, 1);
  static Color dark = Colors.white;
  static Color transparent = Colors.transparent;
  static Color success = Colors.green.shade400;
  static Brightness brightness = Brightness.light;

  static Color randomColor({double alpha = 1}) {
    // var brightness = SchedulerBinding.instance!.window.platformBrightness;
    // bool isDarkMode = brightness == Brightness.dark;

    // var brightness = MediaQuery.of(context).platformBrightness;
    // bool isDarkMode = brightness == Brightness.dark;

    var r = Random().nextInt(250);
    var g = Random().nextInt(250);
    var b = Random().nextInt(250);

    return Color.fromRGBO(r, g, b, alpha);
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static ThemeData get theme {
    Color primary = const Color.fromRGBO(150, 109, 232, 1);
    Color dark = const Color.fromRGBO(33, 33, 33, 1);
    Color light = Colors.white;

    return ThemeData(
      primaryColor: primary,
      primaryColorLight: light,
      primaryColorDark: dark,
      scaffoldBackgroundColor: light,
      brightness: Brightness.dark,
      indicatorColor: const Color(0xFF6553D9),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: dark),
        bodyText2: TextStyle(color: dark),
        headline5: TextStyle(color: dark, fontSize: 24),
        subtitle1: TextStyle(
          color: dark.withOpacity(.5),
          fontSize: 14,
          height: 1,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: primary,
        brightness: Brightness.dark,
      ),
    );
  }

  static ThemeData get themeDark {
    Color primary = const Color.fromRGBO(150, 109, 232, 1);
    Color dark = Colors.white;
    Color light = const Color.fromRGBO(33, 33, 33, 1);

    return ThemeData(
      primaryColor: primary,
      primaryColorLight: light,
      primaryColorDark: dark,
      scaffoldBackgroundColor: light,
      brightness: Brightness.light,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: dark),
        bodyText2: TextStyle(color: dark),
        headline5: TextStyle(color: dark, fontSize: 24),
        subtitle1: TextStyle(
          color: dark.withOpacity(.5),
          fontSize: 14,
          height: 1,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: primary,
      ),
    );
  }
}
