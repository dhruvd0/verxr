import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle _defaultGoogleFontTextStyle() {
  return GoogleFonts.rubik().copyWith(color: Colors.black);
}

ThemeData lightThemeData() {
  return ThemeData(
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      headline1: _defaultGoogleFontTextStyle().copyWith(fontSize: 40),
      headline3: _defaultGoogleFontTextStyle().copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      headline4: _defaultGoogleFontTextStyle().copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyText2: _defaultGoogleFontTextStyle().copyWith(
        fontSize: 14,
        color: AppColors.darkGrey(),
        fontWeight: FontWeight.normal,
      ),
      button: _defaultGoogleFontTextStyle().copyWith(
        fontSize: 16,
        color: Colors.white,
      ),
      caption: _defaultGoogleFontTextStyle().copyWith(
        fontSize: 14,
        color: AppColors.darkGrey(),
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

ThemeData getTheme(BuildContext context) {
  return Theme.of(context);
}

TextTheme getTextTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

class AppColors {
  static Color darkGrey() {
    return const Color(0xFF78746D);
  }

  static Color lightGray() {
    return const Color(0xFFBEBAB3);
  }

  static Color primaryGreen() {
    return const Color(0xFF5BA092);
  }
}
