import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales professionnelles avec la nouvelle couleur #ca1b49
  static const Color _primaryColor = Color(
    0xFFCA1B49,
  ); // Nouvelle couleur principale
  static const Color _secondaryColor = Color(0xFFE91E63); // Rose plus clair
  static const Color _accentColor = Color(0xFFFF4081); // Rose accent
  static const Color _successColor = Color(0xFF00C851);
  static const Color _warningColor = Color(0xFFFFB300);
  static const Color _errorColor = Color(0xFFFF4444);

  // Couleurs neutres sophistiquées
  static const Color _neutral50 = Color(0xFFFAFBFC);
  static const Color _neutral100 = Color(0xFFF1F3F4);
  static const Color _neutral200 = Color(0xFFE8EAED);
  static const Color _neutral300 = Color(0xFFDADCE0);
  static const Color _neutral400 = Color(0xFFBDC1C6);
  static const Color _neutral500 = Color(0xFF9AA0A6);
  static const Color _neutral600 = Color(0xFF80868B);
  static const Color _neutral700 = Color(0xFF5F6368);
  static const Color _neutral800 = Color(0xFF3C4043);
  static const Color _neutral900 = Color(0xFF202124);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Schéma de couleurs professionnel
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _accentColor,
        surface: _neutral50,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _neutral900,
        onError: Colors.white,
      ),

      // AppBar élégant et moderne
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: _neutral900,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _neutral900,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: _neutral700, size: 24),
      ),

      // Cartes avec ombres subtiles et design moderne
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: _neutral200.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _neutral200, width: 1),
        ),
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Boutons élégants et modernes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: _primaryColor.withValues(alpha: 0.3),
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Boutons secondaires
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Boutons texte
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Champs de saisie élégants
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _neutral100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _neutral200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: const TextStyle(
          color: _neutral500,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: _neutral700,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Typographie professionnelle
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: _neutral900,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: _neutral900,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _neutral900,
          letterSpacing: -0.25,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _neutral900,
          letterSpacing: -0.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _neutral900,
          letterSpacing: -0.25,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _neutral900,
          letterSpacing: -0.25,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _neutral900,
          letterSpacing: 0.0,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _neutral900,
          letterSpacing: 0.0,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _neutral900,
          letterSpacing: 0.0,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _neutral800,
          letterSpacing: 0.0,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _neutral800,
          letterSpacing: 0.0,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _neutral600,
          letterSpacing: 0.0,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _neutral700,
          letterSpacing: 0.0,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _neutral700,
          letterSpacing: 0.0,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: _neutral600,
          letterSpacing: 0.0,
        ),
      ),

      // Icônes
      iconTheme: const IconThemeData(color: _neutral700, size: 24),

      // Diviseurs élégants
      dividerTheme: const DividerThemeData(
        color: _neutral200,
        thickness: 1,
        space: 1,
      ),

      // SnackBar moderne
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _neutral900,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),

      // Bottom Navigation Bar élégant
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: _primaryColor,
        unselectedItemColor: _neutral500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Floating Action Button moderne
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Chip élégants
      chipTheme: ChipThemeData(
        backgroundColor: _neutral100,
        selectedColor: _primaryColor.withValues(alpha: 0.1),
        labelStyle: const TextStyle(
          color: _neutral700,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: _neutral200, width: 1),
      ),

      // Popup Menu et Autocomplétion élégants
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white,
        elevation: 8,
        shadowColor: _neutral200.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          color: _neutral900,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Menu Dropdown élégant
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          elevation: WidgetStateProperty.all(8),
          shadowColor: WidgetStateProperty.all(
            _neutral200.withValues(alpha: 0.8),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),

      // Autocomplétion et Search Delegate
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStateProperty.all(_neutral100),
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: _neutral900,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        hintStyle: WidgetStateProperty.all(
          const TextStyle(
            color: _neutral500,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Schéma de couleurs sombre professionnel
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _accentColor,
        surface: _neutral800,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _neutral100,
        onError: Colors.white,
      ),

      // AppBar sombre élégant
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: _neutral100,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _neutral100,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: _neutral300, size: 24),
      ),

      // Cartes sombres avec bordures subtiles
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _neutral700, width: 1),
        ),
        color: _neutral800,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Boutons sombres
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: _primaryColor.withValues(alpha: 0.3),
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Boutons secondaires sombres
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Boutons texte sombres
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Champs de saisie sombres
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _neutral800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _neutral700, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: const TextStyle(
          color: _neutral500,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: _neutral300,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Typographie sombre
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: _neutral100,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: _neutral100,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _neutral100,
          letterSpacing: -0.25,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _neutral100,
          letterSpacing: -0.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _neutral100,
          letterSpacing: -0.25,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _neutral100,
          letterSpacing: -0.25,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _neutral100,
          letterSpacing: 0.0,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _neutral100,
          letterSpacing: 0.0,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _neutral100,
          letterSpacing: 0.0,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _neutral200,
          letterSpacing: 0.0,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _neutral200,
          letterSpacing: 0.0,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: _neutral400,
          letterSpacing: 0.0,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _neutral300,
          letterSpacing: 0.0,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _neutral300,
          letterSpacing: 0.0,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: _neutral400,
          letterSpacing: 0.0,
        ),
      ),

      // Icônes sombres
      iconTheme: const IconThemeData(color: _neutral300, size: 24),

      // Diviseurs sombres
      dividerTheme: const DividerThemeData(
        color: _neutral700,
        thickness: 1,
        space: 1,
      ),

      // SnackBar sombre
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _neutral100,
        contentTextStyle: const TextStyle(
          color: _neutral900,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),

      // Bottom Navigation Bar sombre
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _neutral800,
        selectedItemColor: _primaryColor,
        unselectedItemColor: _neutral500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Floating Action Button sombre
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Chip sombres
      chipTheme: ChipThemeData(
        backgroundColor: _neutral700,
        selectedColor: _primaryColor.withValues(alpha: 0.2),
        labelStyle: const TextStyle(
          color: _neutral200,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: _neutral600, width: 1),
      ),

      // Popup Menu et Autocomplétion sombres élégants
      popupMenuTheme: PopupMenuThemeData(
        color: _neutral800,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          color: _neutral100,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Menu Dropdown sombre élégant
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(_neutral800),
          elevation: WidgetStateProperty.all(8),
          shadowColor: WidgetStateProperty.all(
            Colors.black.withValues(alpha: 0.3),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),

      // Autocomplétion et Search Delegate sombres
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStateProperty.all(_neutral800),
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: _neutral100,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        hintStyle: WidgetStateProperty.all(
          const TextStyle(
            color: _neutral400,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
