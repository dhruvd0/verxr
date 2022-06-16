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
      headline4: _defaultGoogleFontTextStyle().copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyText2: _defaultGoogleFontTextStyle()
          .copyWith(fontSize: 14, color: AppColors.darkGrey()),
      button: _defaultGoogleFontTextStyle()
          .copyWith(fontSize: 16, color: Colors.white),
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

  static Color primaryGreen() {
    return const Color(0xFF5BA092);
  }
}
