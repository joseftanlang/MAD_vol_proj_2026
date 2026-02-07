import 'package:flutter/material.dart';
// Use provider version: ^6.1.2
// Use shared_preferences: ^2.3.2
class AccessibilityProvider extends ChangeNotifier {
  
  TextTheme _textVariations = TextTheme(
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
  TextTheme get textVariations => _textVariations;
  void changeFontSize(double changedValue) {
    _textVariations = TextTheme(
        bodyMedium: TextStyle(
        fontSize: 16*changedValue,
      ),
      titleMedium: TextStyle(
        fontSize: (16+4)*changedValue,
        fontWeight: FontWeight.bold
      ),
      headlineMedium: TextStyle(
        fontSize: (16+8)*changedValue,
        fontWeight: FontWeight.bold
      ),
    );
    notifyListeners();
  }
  // ThemeMode currentContrast = ThemeMode.dark;
  ThemeMode _darkMode = ThemeMode.light;
  ThemeMode get darkMode => _darkMode;
  // Function to change app contrast!!
  void changeContrast(ThemeMode changedValue) {
    _darkMode = changedValue;
    notifyListeners();
  }
}