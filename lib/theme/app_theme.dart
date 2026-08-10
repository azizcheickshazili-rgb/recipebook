import 'package:flutter/material.dart';

/// Palette "marché d'épices" : vert basilic profond en couleur de marque,
/// rehaussé d'un accent piment, sur des fonds chaleureux (ivoire / charbon).
/// Choisie pour éviter le duo orange-crème par défaut et donner à
/// RecipeBook une identité propre, ancrée dans l'univers culinaire.
class AppTheme {
  static const Color _basil = Color(0xFF2F6F4F);
  static const Color _chili = Color(0xFFD2452C);
  static const Color _ivory = Color(0xFFFBF6EC);
  static const Color _charcoal = Color(0xFF1C1A16);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _basil,
      brightness: Brightness.light,
    ).copyWith(
      secondary: _chili,
      surface: _ivory,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: _ivory,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _ivory,
        foregroundColor: _charcoal,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
      ),
      chipTheme: ChipThemeData(
        selectedColor: _basil.withOpacity(0.18),
        side: BorderSide(color: _basil.withOpacity(0.3)),
      ),
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: _basil,
      brightness: Brightness.dark,
    ).copyWith(
      secondary: const Color(0xFFE8785F),
      surface: _charcoal,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: _charcoal,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _charcoal,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
      ),
    );
  }
}
