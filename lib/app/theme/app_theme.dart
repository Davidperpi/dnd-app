import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- PALETA EXACTA DEL DISEÑO HTML (Stitch) ---

  // Primary: #f4c025 (El oro vibrante)
  static const Color primary = Color(0xFFF4C025);

  // Primary Dim: #b58e18 (Oro apagado para bordes/textos secundarios)
  static const Color primaryDim = Color(0xFFB58E18);

  // Background Dark: #221e10 (Fondo principal, marrón muy profundo)
  static const Color backgroundDark = Color(0xFF221E10);

  // Surface Dark: #2c2716 (Para tarjetas/contenedores)
  static const Color surfaceDark = Color(0xFF2C2716);

  // Surface Darker: #181611 (Para Header/BottomNav)
  static const Color surfaceDarker = Color(0xFF181611);

  // Health Colors (Vital para la barra de vida)
  static const Color healthBg = Color(0xFF450A0A);
  static const Color healthFill = Color(0xFFDC2626);

  static const Color textHighEmphasis = Color(0xFFE0DACC); // Blanco hueso
  static const Color textMediumEmphasis = Color(0xFFA8A29E); // Gris cálido

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,

    // Definimos la familia de fuentes por defecto para TODA la app
    fontFamily: GoogleFonts.manrope().fontFamily,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primary,
      secondary: primaryDim,
      surface: surfaceDark, // El color de las tarjetas
      surfaceContainer: surfaceDarker, // Elementos de navegación
      onSurface: textHighEmphasis,
      error: healthFill,
      onError: textHighEmphasis,
    ),

    // Configuración de Textos (Mapeo a tus clases Tailwind)
    textTheme: TextTheme(
      // TAV (Nombre del PJ)
      headlineMedium: GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w800, // Extra Bold
        color: textHighEmphasis,
        letterSpacing: 1.0,
      ),
      // Títulos de secciones (ATRIBUTOS, COMPETENCIAS)
      titleLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis.withValues(alpha: 0.9),
        letterSpacing: 1.2, // tracking-widest
      ),
      // Subtítulos dorados (Paladín Nvl 5)
      titleMedium: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryDim,
        letterSpacing: 2.0, // tracking-[0.2em]
        height: 1.0,
      ),
      // Cuerpo general
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        color: textHighEmphasis,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Ajustes de componentes para que coincidan con el CSS
    iconTheme: const IconThemeData(color: primary),

    dividerTheme: DividerThemeData(
      color: primary.withValues(alpha: 0.2), // border-primary/20
      thickness: 1,
    ),
  );
}
