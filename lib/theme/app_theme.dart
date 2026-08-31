import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF66BB6A);
  static const Color backgroundColor = Color(0xFFF4F9F4);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFE53935);
  static const Color textDark = Color(0xFF1B1B1B);
  static const Color textGrey = Color(0xFF757575);

  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: GoogleFonts.poppinsTextTheme(),

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      primary: primaryGreen,
      secondary: accentOrange,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorRed),
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
    ),
  );

  static Color statusColor(String status) {
    switch (status) {
      case "Pending":
        return const Color(0xFFFFA726);
      case "Ready":
        return const Color(0xFF42A5F5);
      case "Collected":
        return const Color(0xFF66BB6A);
      default:
        return Colors.grey;
    }
  }
}