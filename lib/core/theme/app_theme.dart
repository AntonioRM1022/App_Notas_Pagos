import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors based on the provided image (Luminous App)
  static const Color backgroundDark = Color(0xFF10141D); // Deep dark background
  static const Color surfaceDark = Color(0xFF1A2234); // Slightly lighter for cards
  
  static const Color accentPink = Color(0xFFE94057);
  static const Color accentTeal = Color(0xFF00E676); // Used in countdown and 'En X meses'
  static const Color accentPurple = Color(0xFF8A2BE2);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8E9BB0); // Grayish blue text

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: accentPink,
      
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.inter(color: textPrimary),
        bodyMedium: GoogleFonts.inter(color: textSecondary),
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: false,
      ),
      
      cardTheme: CardThemeData(
        color: surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: accentTeal, // The selected item in image has a teal glow
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      
      colorScheme: const ColorScheme.dark(
        primary: accentPink,
        secondary: accentTeal,
        surface: surfaceDark,
        background: backgroundDark,
      ).copyWith(background: backgroundDark),
    );
  }
}
