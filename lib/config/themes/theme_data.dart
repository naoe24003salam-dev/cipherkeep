import 'package:flutter/material.dart';

/// Available theme options for CipherKeep
enum AppTheme {
  cyberpunk,
  ocean,
  forest,
  sunset,
  minimal,
}

/// Extension to get theme data from enum
extension AppThemeExtension on AppTheme {
  ThemeData get themeData {
    switch (this) {
      case AppTheme.cyberpunk:
        return _CyberpunkTheme.theme;
      case AppTheme.ocean:
        return _OceanTheme.theme;
      case AppTheme.forest:
        return _ForestTheme.theme;
      case AppTheme.sunset:
        return _SunsetTheme.theme;
      case AppTheme.minimal:
        return _MinimalTheme.theme;
    }
  }

  String get displayName {
    switch (this) {
      case AppTheme.cyberpunk:
        return 'Cyberpunk';
      case AppTheme.ocean:
        return 'Ocean';
      case AppTheme.forest:
        return 'Forest';
      case AppTheme.sunset:
        return 'Sunset';
      case AppTheme.minimal:
        return 'Minimal';
    }
  }
}

/// Base theme configuration for consistent styling
class _BaseThemeConfig {
  static TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
  );

  static CardThemeData cardTheme(Color surface) => CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surface,
      );

  static AppBarTheme appBarTheme(Color surface, Color onSurface) => AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: surface,
        foregroundColor: onSurface,
        iconTheme: IconThemeData(color: onSurface),
      );

  static InputDecorationTheme inputTheme(Color primary, Color surface) =>
      InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      );

  static ElevatedButtonThemeData elevatedButtonTheme(Color primary) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
      );

  static FloatingActionButtonThemeData fabTheme(Color primary) =>
      FloatingActionButtonThemeData(
        backgroundColor: primary,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
}

/// Cyberpunk Theme - Neon green/purple on black
class _CyberpunkTheme {
  static const Color _primary = Color(0xFF00FF41); // Matrix green
  static const Color _secondary = Color(0xFFBF00FF); // Cyber purple
  static const Color _background = Color(0xFF0A0E27);
  static const Color _surface = Color(0xFF1A1F3A);
  static const Color _error = Color(0xFFFF3366);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: _primary,
          secondary: _secondary,
          surface: _surface,
          error: _error,
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        ),
        textTheme: _BaseThemeConfig.textTheme,
        cardTheme: _BaseThemeConfig.cardTheme(_surface),
        appBarTheme: _BaseThemeConfig.appBarTheme(_background, Colors.white),
        inputDecorationTheme: _BaseThemeConfig.inputTheme(_primary, _surface),
        elevatedButtonTheme: _BaseThemeConfig.elevatedButtonTheme(_primary),
        floatingActionButtonTheme: _BaseThemeConfig.fabTheme(_primary),
        scaffoldBackgroundColor: _background,
      );
}

/// Ocean Theme - Deep blue/cyan gradients
class _OceanTheme {
  static const Color _primary = Color(0xFF00B4D8); // Ocean cyan
  static const Color _secondary = Color(0xFF0077B6); // Deep blue
  static const Color _background = Color(0xFF03045E);
  static const Color _surface = Color(0xFF023E8A);
  static const Color _error = Color(0xFFFF006E);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: _primary,
          secondary: _secondary,
          surface: _surface,
          error: _error,
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        ),
        textTheme: _BaseThemeConfig.textTheme,
        cardTheme: _BaseThemeConfig.cardTheme(_surface),
        appBarTheme: _BaseThemeConfig.appBarTheme(_background, Colors.white),
        inputDecorationTheme: _BaseThemeConfig.inputTheme(_primary, _surface),
        elevatedButtonTheme: _BaseThemeConfig.elevatedButtonTheme(_primary),
        floatingActionButtonTheme: _BaseThemeConfig.fabTheme(_primary),
        scaffoldBackgroundColor: _background,
      );
}

/// Forest Theme - Emerald green/earth tones
class _ForestTheme {
  static const Color _primary = Color(0xFF10B981); // Emerald green
  static const Color _secondary = Color(0xFF059669); // Forest green
  static const Color _background = Color(0xFF064E3B);
  static const Color _surface = Color(0xFF065F46);
  static const Color _error = Color(0xFFEF4444);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: _primary,
          secondary: _secondary,
          surface: _surface,
          error: _error,
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        ),
        textTheme: _BaseThemeConfig.textTheme,
        cardTheme: _BaseThemeConfig.cardTheme(_surface),
        appBarTheme: _BaseThemeConfig.appBarTheme(_background, Colors.white),
        inputDecorationTheme: _BaseThemeConfig.inputTheme(_primary, _surface),
        elevatedButtonTheme: _BaseThemeConfig.elevatedButtonTheme(_primary),
        floatingActionButtonTheme: _BaseThemeConfig.fabTheme(_primary),
        scaffoldBackgroundColor: _background,
      );
}

/// Sunset Theme - Orange/pink gradients
class _SunsetTheme {
  static const Color _primary = Color(0xFFFF6B35); // Sunset orange
  static const Color _secondary = Color(0xFFE91E63); // Pink
  static const Color _background = Color(0xFF4A1942);
  static const Color _surface = Color(0xFF6A2C70);
  static const Color _error = Color(0xFFDC2626);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: _primary,
          secondary: _secondary,
          surface: _surface,
          error: _error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        ),
        textTheme: _BaseThemeConfig.textTheme,
        cardTheme: _BaseThemeConfig.cardTheme(_surface),
        appBarTheme: _BaseThemeConfig.appBarTheme(_background, Colors.white),
        inputDecorationTheme: _BaseThemeConfig.inputTheme(_primary, _surface),
        elevatedButtonTheme: _BaseThemeConfig.elevatedButtonTheme(_primary),
        floatingActionButtonTheme: _BaseThemeConfig.fabTheme(_primary),
        scaffoldBackgroundColor: _background,
      );
}

/// Minimal Theme - Clean black/white/grey
class _MinimalTheme {
  static const Color _primary = Color(0xFFFFFFFF); // White
  static const Color _secondary = Color(0xFF9CA3AF); // Grey
  static const Color _background = Color(0xFF000000);
  static const Color _surface = Color(0xFF1F2937);
  static const Color _error = Color(0xFFEF4444);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: _primary,
          secondary: _secondary,
          surface: _surface,
          error: _error,
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        ),
        textTheme: _BaseThemeConfig.textTheme,
        cardTheme: _BaseThemeConfig.cardTheme(_surface),
        appBarTheme: _BaseThemeConfig.appBarTheme(_background, Colors.white),
        inputDecorationTheme: _BaseThemeConfig.inputTheme(_primary, _surface),
        elevatedButtonTheme: _BaseThemeConfig.elevatedButtonTheme(_primary),
        floatingActionButtonTheme: _BaseThemeConfig.fabTheme(_primary),
        scaffoldBackgroundColor: _background,
      );
}
