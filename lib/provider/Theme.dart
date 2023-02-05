import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  Color _themeColor = Colors.blueGrey;
  int _themeMode = 0;
  // 0: System 1: Light 2: Dark

  Color get themeColor => _themeColor;

  setThemeColor(Color themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }

  int get themeMode => _themeMode;

  setThemeMode(int themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}