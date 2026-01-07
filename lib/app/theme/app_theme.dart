import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // PALETA "DARK FANTASY" (Cálida)
  static const Color primaryColor = Color(0xFFFFD700); // Oro Amarillo

  // El truco: No usar negro, usar un Marrón casi negro
  static const Color scaffoldBackground = Color(0xFF141210);

  // Color para las tarjetas y fondos secundarios (Marrón Bronce)
  static const Color surfaceColor = Color(0xFF25201B);

  static const Color textColor = Color(0xFFE0E0E0);

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: scaffoldBackground, // <--- Fondo Global Cálido

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      surface: scaffoldBackground,
      secondary: primaryColor,
    ),

    textTheme: TextTheme(
      headlineMedium: GoogleFonts.cinzel(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      titleMedium: GoogleFonts.cinzel(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        letterSpacing: 1.5,
      ),
      bodyMedium: GoogleFonts.lato(fontSize: 16, color: textColor),
    ),
  );
}
