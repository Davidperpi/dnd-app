import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- "VOID" PALETTE (Modern/Stitch Dark Style) ---

  // Primary: Vibrant Gold
  static const Color primary = Color(0xFFF4C025);
  static const Color primaryDim = Color(0xFFB58E18);

  // --- NEUTRAL BACKGROUNDS ---

  // Level 1: Global background (Obsidian Black)
  static const Color globalBackground = Color(0xFF121212);

  // Level 2: Background for tab views (Charcoal Gray)
  static const Color tabsBackground = Color(0xFF181818);

  // Level 3: Background for cards and containers (Steel Gray)
  static const Color cardBackground = Color(0xFF252525);

  // --- UI-SPECIFIC COLORS ---

  // Texts
  static const Color textHighEmphasis = Color(0xFFE0DACC); // Off-white
  static const Color textMediumEmphasis = Color(0xFFA8A29E); // Warm gray

  // Health bars
  static const Color healthFill = Color(0xFFDC2626);

  // --- THEME DEFINITION ---

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Main background color for scaffolds
    scaffoldBackgroundColor: globalBackground,

    fontFamily: GoogleFonts.manrope().fontFamily,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primary,
      secondary: primaryDim,

      // Map our custom colors to the standard color scheme
      surface: tabsBackground,       // Used for tab views, bottom nav bars, etc.
      surfaceContainer: cardBackground, // Used for cards, dialogs, etc.
      onSurface: textHighEmphasis, // Text color on top of surface colors
      error: healthFill,
    ),

    textTheme: TextTheme(
      headlineMedium: GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: textHighEmphasis,
        letterSpacing: 1.0,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis.withOpacity(0.9),
        letterSpacing: 1.2,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryDim,
        letterSpacing: 2.0,
        height: 1.0,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        color: textHighEmphasis,
        fontWeight: FontWeight.w500,
      ),
    ),

    iconTheme: const IconThemeData(color: primary),
    dividerTheme: DividerThemeData(
      color: Colors.white.withOpacity(0.1),
      thickness: 1,
    ),
  );
}
