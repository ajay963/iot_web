import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iot/colors.dart';

const Color kThemeShadeMagenta = Color(0xffEC0055);

class Themeing {
  static const Color primaryColor = Color(0xffEC0055);
  static ThemeData lightTheme = ThemeData(
    backgroundColor: kLtGrey,
    listTileTheme: ListTileThemeData(
      selectedColor: Colors.white.withOpacity(0.8),
      textColor: Colors.white.withOpacity(0.8),
    ),
    textTheme: TextTheme(
        displayLarge: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white),
        headlineMedium: TextStyle(
          fontFamily: GoogleFonts.roboto().fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kMdGrey),
        bodyLarge: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white10),
        bodyMedium: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: Colors.white.withOpacity(0.6)),
        bodySmall: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontSize: 16,
            height: 8,
            fontWeight: FontWeight.w700,
            color: kMdGrey),
        labelMedium: TextStyle(
          fontFamily: GoogleFonts.roboto().fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.orange.shade600,
        ),
        labelSmall: TextStyle(
          fontFamily: GoogleFonts.roboto().fontFamily,
          fontSize: 12,
          color: Colors.white.withOpacity(0.6),
        ),
        displaySmall: TextStyle(
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
            fontFeatures: const [
              FontFeature.superscripts(),
            ])),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
          fontFamily: GoogleFonts.roboto().fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primaryColor),
      bodyMedium: TextStyle(
          fontFamily: GoogleFonts.roboto().fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: Colors.white.withOpacity(0.6)),
      bodySmall: TextStyle(
          fontFamily: GoogleFonts.roboto().fontFamily,
          fontSize: 16,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.6)),
    ),
  );
}
