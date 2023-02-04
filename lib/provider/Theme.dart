import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  Color _themeColor = Colors.blueGrey;
  ThemeMode _themeMode = ThemeMode.system;

  Color get themeColor => _themeColor;

  setThemeColor(Color themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}