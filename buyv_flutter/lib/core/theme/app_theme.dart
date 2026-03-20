import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// BuyV Design System — matches KMP color palette:
/// Primary Orange: #F4A032 | Secondary Blue: #0B649B
/// Text Blue: #114B7F | Success Green: #34BE9D
/// Error Red: #E46962 | Background: #F5F5F5
abstract class AppColors {
  // ── Brand ─────────────────────────────────────────────────────────
  static const primary = Color(0xFFF4A032);
  static const primaryDark = Color(0xFFD4881A);
  static const primaryLight = Color(0xFFFFBF5E);

  static const secondary = Color(0xFF0B649B);
  static const secondaryLight = Color(0xFF3D8AC4);

  // ── Text ──────────────────────────────────────────────────────────
  static const textDark = Color(0xFF114B7F);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const textHint = Color(0xFF9CA3AF);

  // ── Status ────────────────────────────────────────────────────────
  static const success = Color(0xFF34BE9D);
  static const error = Color(0xFFE46962);
  static const warning = Color(0xFFFBBF24);
  static const info = Color(0xFF3B82F6);

  // ── Background ────────────────────────────────────────────────────
  static const background = Color(0xFFF5F5F5);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF0F4F8);
  static const border = Color(0xFFE5E7EB);

  // ── Dark (Video Player / Reels background) ────────────────────────
  static const darkBackground = Color(0xFF0A0A0A);
  static const darkSurface = Color(0xFF1C1C1E);
  static const darkText = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFFAAAAAA);

  // ── Social ────────────────────────────────────────────────────────
  static const liked = Color(0xFFE46962);
  static const bookmarked = Color(0xFFF4A032);
}

/// BuyV Theme — Material 3
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          error: AppColors.error,
          surface: AppColors.surface,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.interTextTheme().copyWith(
          displayLarge: GoogleFonts.inter(
              fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          displayMedium: GoogleFonts.inter(
              fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          titleLarge: GoogleFonts.inter(
              fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          titleMedium: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          bodyLarge: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
          bodyMedium: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
          bodySmall: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textHint),
          labelLarge: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          hintStyle: GoogleFonts.inter(color: AppColors.textHint, fontSize: 14),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.border,
          thickness: 0.5,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:
              GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        ),
      );
}
