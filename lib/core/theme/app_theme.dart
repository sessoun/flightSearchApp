import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF0D80F2),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Plus Jakarta Sans',
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: const Color(0xFF21234C),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF21234C),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF21234C),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF21234C),
        ),
      ),
    ),
    useMaterial3: true,
  );
}