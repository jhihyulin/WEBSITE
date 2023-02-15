import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThemeProvider with ChangeNotifier {
  static const Color defaultColor = Colors.blueGrey;
  static const int defaultMode = 0; // 0: System 1: Light 2: Dark
  Color _themeColor = defaultColor;
  int _themeMode = defaultMode;

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
        _themeColor = defaultColor;
        _themeMode = defaultMode;
        user = null;
        notifyListeners();
      }
    });
  }

  Color get themeColor => _themeColor;

  Color get defaultThemeColor => defaultColor;

  setThemeColor(Color themeColor) {
    _themeColor = themeColor;
    syncToFirebase();
    notifyListeners();
  }

  int get themeMode => _themeMode;

  int get defaultThemeMode => defaultMode;

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
