import 'package:flutter/material.dart';

/// App theme inspired by GitHub's dark mode with custom touches
class AppTheme {
  // Colors - GitHub inspired with custom accent
  static const Color primaryDark = Color(0xFF0D1117);
  static const Color secondaryDark = Color(0xFF161B22);
  static const Color tertiaryDark = Color(0xFF21262D);
  static const Color borderColor = Color(0xFF30363D);

  // Contribution colors (GitHub green palette)
  static const Color contributionNone = Color(0xFF161B22);
  static const Color contributionLow = Color(0xFF0E4429);
  static const Color contributionMedium = Color(0xFF006D32);
  static const Color contributionHigh = Color(0xFF26A641);
  static const Color contributionVeryHigh = Color(0xFF39D353);

  // Accent colors
  static const Color accentBlue = Color(0xFF58A6FF);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentOrange = Color(0xFFFF9500);
  static const Color accentGreen = Color(0xFF39D353);

  // Text colors
  static const Color textPrimary = Color(0xFFC9D1D9);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textTertiary = Color(0xFF6E7681);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryDark,
    primaryColor: accentBlue,
    colorScheme: const ColorScheme.dark(
      primary: accentBlue,
      secondary: accentPurple,
      surface: secondaryDark,
      background: primaryDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: secondaryDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderColor, width: 1),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textSecondary),
      bodySmall: TextStyle(color: textTertiary),
    ),
    iconTheme: const IconThemeData(color: textSecondary),
    dividerColor: borderColor,
  );

  // Get contribution color based on count
  static Color getContributionColor(int count) {
    if (count == 0) return contributionNone;
    if (count <= 3) return contributionLow;
    if (count <= 6) return contributionMedium;
    if (count <= 9) return contributionHigh;
    return contributionVeryHigh;
  }
}
