import 'package:flutter/material.dart';

/// AppTheme centralizes the visual design system for the DSA Learning App.
/// Keeping colors and styles in one place makes it easy to update the look
/// of the entire app without editing individual screens.
class AppTheme {
  // Brand & Surface Colors
  static const Color primaryPurple = Color(0xFF6C47FF); // Main brand color
  static const Color softPurple = Color(0xFFEDE8FF);    // Subtle highlights & backgrounds
  static const Color backgroundLight = Color(0xFFF8F9FC); // Very light grey canvas
  static const Color textDark = Color(0xFF1F2937);      // High-contrast readable headings
  static const Color textGrey = Color(0xFF6B7280);      // Secondary descriptions & subtitles

  /// Returns the main light theme used by MaterialApp.
  static ThemeData get lightTheme {
    return ThemeData(
      // Enables Material 3 design components (modern cards, navigation bar, etc.)
      useMaterial3: true,

      // Default background color for every Scaffold in the app
      scaffoldBackgroundColor: backgroundLight,

      // Generates a harmonious palette based on our primary purple
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        primary: primaryPurple,
        secondary: softPurple,
        surface: Colors.white,
      ),

      // Global styling for top AppBars across all screens
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0, // Removes default shadow for a clean, minimal look
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textDark),
      ),

      // Global styling for Card widgets (rounded corners + subtle border)
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),

      // Global styling for primary action buttons (e.g., Submit Answer, Continue)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}