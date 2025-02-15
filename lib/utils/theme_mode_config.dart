import 'package:flutter/material.dart';
import 'palette.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeModeConfig {
  static final ThemeData _lightMode = ThemeData(
    fontFamily: GoogleFonts.manrope().fontFamily,
    scaffoldBackgroundColor: Palette.white,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.light,
      primary: Primary.darkGreen1,
      secondary: Secondary.grey2,
      surface: Primary.black1,
      onSurface: Secondary.lightGrey3,
      primaryContainer: Secondary.lightGrey1,
      onPrimaryContainer: Secondary.lightGrey3,
      secondaryContainer: const Color(0xffd8dbe5)
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        height: 1.3,
        fontSize: 24,
        color: Primary.black1,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        height: 1.4,
        fontSize: 14,
        color: Primary.darkGreen1,
      ),
      bodyLarge: TextStyle(
        height: 1.3,
        fontSize: 20,
        color: Primary.black1,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        height: 1.6,
        fontSize: 14,
        color: Secondary.grey1
      ),
      labelMedium: TextStyle(
        height: 1.3,
        fontSize: 14,
        color: Primary.black1,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        height: 1.8,
        fontSize: 12,
        color: Secondary.grey1,
      ),
    ),
  );

  static final ThemeData _darkMode = ThemeData(
    fontFamily: GoogleFonts.manrope().fontFamily,
    scaffoldBackgroundColor: Support.dBlack1,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.dark,
      primary: Palette.white,
      secondary: Primary.black1,
      surface: Palette.white,
      onSurface: Support.dBlack2,
      primaryContainer: Support.dBlack2,
      onPrimaryContainer: Support.dBlack3,
      secondaryContainer:const Color(0xff292c2a)
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        height: 1.3,
        fontSize: 24,
        color: Palette.white,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        height: 1.4,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Primary.darkGreen1,
      ),
      bodyLarge: TextStyle(
        height: 1.3,
        fontSize: 20,
        color: Palette.white,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        height: 1.6,
        fontSize: 14,
        color: Secondary.grey1
      ),
      labelMedium: TextStyle(
        height: 1.3,
        fontSize: 14,
        color: Palette.white,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: TextStyle(
        height: 1.8,
        fontSize: 12,
        color: Secondary.grey1,
      ),
    ),
  );

  static ThemeData themeModeConfig({required isDark}) {
    return (isDark ? _darkMode : _lightMode).copyWith(
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        toolbarHeight: 75,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}