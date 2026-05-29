import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get heading1 => GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading2 => GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.dmSans(
        fontSize: 16,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
        fontSize: 14,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.dmSans(
        fontSize: 12,
        color: AppColors.textGrey,
      );
}
