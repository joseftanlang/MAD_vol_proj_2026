import 'package:flutter/material.dart';
// Use provider version: ^6.1.2
// Use shared_preferences: ^2.3.2
class AccessibilityProvider extends ChangeNotifier {

  static TextTheme textVariations = TextTheme(
    bodyMedium: TextStyle(
      fontSize: 16,
    ),
    titleMedium: TextStyle(
      fontSize: 16+4,
      fontWeight: FontWeight.bold
    ),
    headlineMedium: TextStyle(
      fontSize: 16+8,
      fontWeight: FontWeight.bold
    ),
  );
  // ThemeMode currentContrast = ThemeMode.dark;
  ThemeMode _darkMode = ThemeMode.dark;
  ThemeMode get darkMode => _darkMode;
  // Function to change app contrast!!
  void changeContrast(ThemeMode changedValue) {
    _darkMode = changedValue;
    notifyListeners();
  }
}