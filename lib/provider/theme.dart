import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThemeProvider with ChangeNotifier {
  static const Color DefaultThemeColor = Colors.blueGrey;
  static const int DefaultThemeMode = 0;
  Color _themeColor = DefaultThemeColor;
  int _themeMode = 0; // 0: System 1: Light 2: Dark

  User? user;

  ThemeProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        this.user = user;
        FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get()
            .then((value) => {
                  _themeColor = Color(value['preferance']['themeColor']),
                  _themeMode = value['preferance']['themeMode'],
                  notifyListeners()
                });
      } else {
        _themeColor = DefaultThemeColor;
        _themeMode = DefaultThemeMode;
        user = null;
        notifyListeners();
      }
    });
  }

  Color get themeColor => _themeColor;

  Color get defaultThemeColor => DefaultThemeColor;

  setThemeColor(Color themeColor) {
    _themeColor = themeColor;
    syncToFirebase();
    notifyListeners();
  }

  int get themeMode => _themeMode;

  int get defaultThemeMode => DefaultThemeMode;

  setThemeMode(int themeMode) {
    _themeMode = themeMode;
    syncToFirebase();
    notifyListeners();
  }

  void syncToFirebase() {
    if (user != null) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .update({'preferance': {
            'themeColor': themeColor.value,
            'themeMode': themeMode
          }});
    }
  }
}
