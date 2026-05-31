import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.voidNavy,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.holoCyan,
        secondary: AppColors.ariseGold,
        surface: AppColors.slateSurface,
        error: AppColors.hpCrimson,
        onPrimary: AppColors.black,
        onSecondary: AppColors.black,
        onSurface: AppColors.pureWhite,
        onError: AppColors.pureWhite,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          color: AppColors.holoCyan,
          fontWeight: FontWeight.w800,
          letterSpacing: 6,
        ),
        displayMedium: GoogleFonts.orbitron(
          color: AppColors.holoCyan,
          fontWeight: FontWeight.w700,
          letterSpacing: 4,
        ),
        displaySmall: GoogleFonts.orbitron(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        headlineLarge: GoogleFonts.orbitron(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        headlineMedium: GoogleFonts.orbitron(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        headlineSmall: GoogleFonts.inter(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.inter(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.inter(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.shareTechMono(
          color: AppColors.mutedAsh,
          letterSpacing: 1,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.systemSilver,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.systemSilver,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.shareTechMono(
          color: AppColors.mutedAsh,
          fontSize: 10,
          letterSpacing: 1,
        ),
        labelLarge: GoogleFonts.orbitron(
          color: AppColors.holoCyan,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
        labelMedium: GoogleFonts.jetBrainsMono(
          color: AppColors.mutedAsh,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          color: AppColors.mutedAsh,
          fontWeight: FontWeight.w500,
          fontSize: 9,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.slateSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.holoCyan, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0x3300E5FF),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.holoCyan, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.hpCrimson, width: 1),
        ),
        labelStyle: GoogleFonts.inter(color: AppColors.systemSilver),
        hintStyle: GoogleFonts.inter(color: AppColors.mutedAsh),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.holoCyan,
          foregroundColor: AppColors.black,
          textStyle: GoogleFonts.orbitron(
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.voidNavy,
        selectedItemColor: AppColors.holoCyan,
        unselectedItemColor: AppColors.mutedAsh,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.slateSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0x0DFFFFFF),
        thickness: 1,
      ),
    );
  }
}
