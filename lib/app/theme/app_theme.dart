import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- PALETA "VOID" (Estilo Moderno/Stitch Dark) ---

  // Primary: El Oro vibrante (Se mantiene igual)
  static const Color primary = Color(0xFFF4C025);
  static const Color primaryDim = Color(0xFFB58E18);

  // --- NUEVOS FONDOS NEUTROS ---

  // Nivel 1: Fondo Global (Negro Obsidiana - Header)
  static const Color backgroundBlack = Color(0xFF121212);

  // Nivel 2: Fondo Pestañas (Gris Carbón - Body)
  static const Color backgroundGrey = Color(0xFF181818);

  // Nivel 3: Tarjetas/Cajas (Gris Acero - Stats)
  static const Color surfaceCard = Color(0xFF252525);

  // Textos
  static const Color textHighEmphasis = Color(0xFFE0DACC); // Blanco hueso
  static const Color textMediumEmphasis = Color(0xFFA8A29E); // Gris cálido

  // Health
  static const Color healthFill = Color(0xFFDC2626);

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Aquí definimos el color de fondo principal de la pantalla
    scaffoldBackgroundColor: backgroundBlack,

    fontFamily: GoogleFonts.manrope().fontFamily,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primary,
      secondary: primaryDim,

      // Mapeamos nuestros colores personalizados al esquema estándar
      surface: backgroundGrey, // El color de las pestañas
      surfaceContainer: surfaceCard, // El color de las cajitas de stats
      onSurface: textHighEmphasis,
      error: healthFill,
    ),

    // Textos (igual que tenías)
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
        color: textHighEmphasis.withValues(alpha: 0.9),
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
      color: Colors.white.withValues(alpha: 0.1),
      thickness: 1,
    ),
  );
}
