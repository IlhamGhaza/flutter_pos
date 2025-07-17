import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class ThemeManager {
  static const String _themeKey = 'app_theme_mode';

  // Default theme is system
  static const AppThemeMode _defaultTheme = AppThemeMode.system;

  // Save theme mode to SharedPreferences
  static Future<void> setThemeMode(AppThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode.name);
  }

  // Get theme mode from SharedPreferences
  static Future<AppThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);

    if (themeString == null) {
      // Set default theme if none exists
      await setThemeMode(_defaultTheme);
      return _defaultTheme;
    }

    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == themeString,
      orElse: () => _defaultTheme,
    );
  }

  // Get the actual theme mode for Flutter (system resolves to light/dark)
  static Future<AppThemeMode> getResolvedThemeMode() async {
    final themeMode = await getThemeMode();

    if (themeMode == AppThemeMode.system) {
      // Check system brightness
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark
          ? AppThemeMode.dark
          : AppThemeMode.light;
    }

    return themeMode;
  }

  // Check if current theme is dark
  static Future<bool> isDarkMode() async {
    final resolvedTheme = await getResolvedThemeMode();
    return resolvedTheme == AppThemeMode.dark;
  }
}
