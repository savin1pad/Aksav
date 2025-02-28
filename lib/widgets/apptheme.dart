import 'package:flutter/material.dart';

class AppTheme {
  // Space theme colors
  static const deepSpace = Color(0xFF0A0E21);
  static const cosmicBlue = Color(0xFF1F2566);
  static const starWhite = Color(0xFFF8F8FF);
  static const nebulaPurple = Color(0xFF9370DB);
  static const galaxyBlue = Color(0xFF1BFFFF);
  static const blackHole = Color(0xFF000000);

  // Gradients
  static const spaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      deepSpace,
      Color(0xFF121833),
    ],
  );

  static const cosmicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      cosmicBlue,
      galaxyBlue,
    ],
  );

  // Text styles
  static const headerStyle = TextStyle(
    color: starWhite,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  static const bodyStyle = TextStyle(
    color: starWhite,
    fontSize: 16.0,
  );

  static const captionStyle = TextStyle(
    color: Color(0xFFB0B0C0),
    fontSize: 12.0,
  );

  // ThemeData
  static ThemeData get darkSpaceTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: deepSpace,
      primaryColor: cosmicBlue,
      colorScheme: const ColorScheme.dark(
        primary: galaxyBlue,
        secondary: nebulaPurple,
        surface: deepSpace,
        background: deepSpace,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: deepSpace,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: cosmicBlue.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
