
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFF070B18);
  static const Color surface = Color(0xFF111A2E);
  static const Color primary = Color(0xFF38BDF8);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color textPrimary = Color(0xFFF3F6FF);
  static const Color textSecondary = Color(0xFF9AA8C0);

  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('app_theme_mode');

    mode.value = savedTheme == 'light'
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  static Future<void> setMode(ThemeMode newMode) async {
    mode.value = newMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'app_theme_mode',
      newMode == ThemeMode.light ? 'light' : 'dark',
    );
  }

  static Color pageBackground(BuildContext context) =>
    Theme.of(context).scaffoldBackgroundColor;

static Color cardBackground(BuildContext context) =>
    Theme.of(context).colorScheme.surface;

static Color mainText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface;

static Color secondaryText(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF9AA8C0)
        : const Color(0xFF64748B);

static Color borderColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF28344D)
        : const Color(0xFFDCE3EF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onPrimary: Color(0xFF07111F),
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      fontFamily: 'Arial',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        prefixIconColor: primary,
        hintStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF28344D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: const Color(0xFF07111F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF4F7FC),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0284C7),
        secondary: Color(0xFF7C3AED),
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: Color(0xFF172033),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF4F7FC),
        foregroundColor: Color(0xFF172033),
        elevation: 0,
      ),
      fontFamily: 'Arial',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        prefixIconColor: const Color(0xFF0284C7),
        hintStyle: const TextStyle(color: Color(0xFF77839A)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFDCE3EF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFDCE3EF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF0284C7),
            width: 1.5,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
