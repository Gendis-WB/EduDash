import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 1. Definisikan Warna Inti Kita
  static const Color primaryColor = Color(0xFF6366F1); // Modern Soft Indigo
  static const Color backgroundLight = Color(0xFFFAFAFA); // Minimalist White
  static const Color backgroundDark = Color(0xFF111827); // Modern Dark Slate

  // 2. Tema Terang (Light Mode)
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundLight,
    // Masukkan Plus Jakarta Sans ke seluruh aplikasi!
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.light().textTheme,
    ),
  );

  // 3. Tema Gelap (Dark Mode)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: backgroundDark,
    // Plus Jakarta Sans untuk versi gelap
    textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
  );
}
