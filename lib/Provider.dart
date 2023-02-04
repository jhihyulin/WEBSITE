import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppInfoProvider with ChangeNotifier {
  Color _themeColor = Colors.blueGrey;
  ThemeMode _themeMode = ThemeMode.system;

  Color get themeColor => _themeColor;

  setThemeColor(Color themeColor) {
    _themeColor = themeColor as Color;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}