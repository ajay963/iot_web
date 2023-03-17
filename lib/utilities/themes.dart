import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

const Color kThemeShadeMagenta = Color(0xffEC0055);

class Themeing extends ChangeNotifier {
  static const Color primaryColor = Color(0xffEC0055);
  static const Color themeColor = Color(0xffFF924C);

  static ThemeData lightTheme = ThemeData(
      textTheme: TextTheme(
    displayLarge: TextStyle(
        fontFamily: GoogleFonts.nunito().fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: CustomColors.blackShade1),
    displayMedium: TextStyle(
        fontFamily: GoogleFonts.nunito().fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: CustomColors.greyShade2),
    headlineMedium: TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: CustomColors.blackShade2,
    ),
    headlineSmall: TextStyle(
        fontFamily: GoogleFonts.nunito().fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: kMdGrey),
    bodyLarge: TextStyle(
        fontFamily: GoogleFonts.nunito().fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.white10),
    bodyMedium: TextStyle(
        fontFamily: GoogleFonts.nunito().fontFamily,
        fontSize: 16,
        letterSpacing: 1.5,
        color: CustomColors.greyShade3),
    bodySmall: TextStyle(
        fontFamily: GoogleFonts.nunito().fontFamily,
        fontSize: 16,
        height: 8,
        fontWeight: FontWeight.w700,
        color: kMdGrey),
    labelMedium: TextStyle(
      fontFamily: GoogleFonts.nunito().fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.orange.shade600,
    ),
    labelSmall: TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontSize: 12,
      color: Colors.white.withOpacity(0.6),
    ),
  ));

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontFamily: GoogleFonts.comfortaa().fontFamily,
          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: Colors.white),
      displayMedium: TextStyle(
          fontFamily: GoogleFonts.nunito().fontFamily,
          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: Colors.white),
      displaySmall: TextStyle(
          fontFamily: GoogleFonts.rowdies().fontFamily,
          fontSize: 36,
          letterSpacing: 1.5,
          color: Colors.white),
      bodyLarge: TextStyle(
          fontFamily: GoogleFonts.nunito().fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: kLtGrey),
      bodyMedium: TextStyle(
          fontFamily: GoogleFonts.nunito().fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: kTxtWhite),
      bodySmall: TextStyle(
          fontFamily: GoogleFonts.nunito().fontFamily,
          fontSize: 16,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w500,
          color: kLtGrey),
      labelLarge: TextStyle(
          fontFamily: GoogleFonts.nunito().fontFamily,
          fontSize: 24,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
          color: themeColor),
      labelMedium: TextStyle(
          fontFamily: GoogleFonts.nunito().fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: kTxtWhite),
      labelSmall: TextStyle(
          fontFamily: GoogleFonts.nunito().fontFamily,
          fontSize: 12,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
          color: kLtGrey),
    ),
  );
}
