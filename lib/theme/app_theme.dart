import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primary),
        titleTextStyle: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      textTheme: GoogleFonts.dmSansTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(color: AppColors.textPrimary),
        displayMedium: GoogleFonts.playfairDisplay(color: AppColors.textPrimary),
        displaySmall: GoogleFonts.playfairDisplay(color: AppColors.textPrimary),
      ),
    );
  }
}
