import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.backgroundLight,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: AppColors.textPrimaryLight,
        onSurface: AppColors.textPrimaryLight,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
        displayMedium: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.bold),
        titleLarge: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(color: AppColors.textPrimaryLight),
        bodyMedium: const TextStyle(color: AppColors.textSecondaryLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 2,
        shadowColor: AppColors.textSecondaryLight.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
        titleTextStyle: TextStyle(color: AppColors.textPrimaryLight, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: AppColors.textPrimaryDark,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: const TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
        displayMedium: const TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold),
        titleLarge: const TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(color: AppColors.textPrimaryDark),
        bodyMedium: const TextStyle(color: AppColors.textSecondaryDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: TextStyle(color: AppColors.textPrimaryDark, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
