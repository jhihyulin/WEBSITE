import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThemeProvider with ChangeNotifier {
  static const Color dThemeColor = Colors.blueGrey;
  static const int dThemeMode = 0; // 0: System 1: Light 2: Dark
  Color _themeColor = dThemeColor;
  int _themeMode = dThemeMode;

  User? _user;

  ThemeProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _user = user;
          Timer(const Duration(milliseconds: 100), () {
            FirebaseFirestore.instance
                .collection('user')
                .doc(user?.uid)
                .get()
                .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
              if (documentSnapshot.exists) {
                var data = documentSnapshot.data();
                if (data != null) {
                  var preferance = data['preferance'];
                  if (preferance != null) {
                    _themeColor = Color(preferance['themeColor'] ?? dThemeColor.value);
                    _themeMode = preferance['themeMode'] ?? dThemeMode;
                    notifyListeners();
                  }
                }
              }
            });
          });
      } else {
        _themeColor = dThemeColor;
        _themeMode = dThemeMode;
        user = null;
        notifyListeners();
      }
    });
  }

  Color get themeColor => _themeColor;

  Color get defaultThemeColor => dThemeColor;

  setThemeColor(Color themeColor) {
    _themeColor = themeColor;
    syncToFirebase();
    notifyListeners();
  }

  int get themeMode => _themeMode;

  int get defaultThemeMode => dThemeMode;

  setThemeMode(int themeMode) {
    _themeMode = themeMode;
    syncToFirebase();
    notifyListeners();
  }

  void syncToFirebase() {
    if (_user != null) {
      FirebaseFirestore.instance.collection('user').doc(_user!.uid).update({
        'preferance': {'themeColor': themeColor.value, 'themeMode': themeMode}
      }).then((value) {
        if (kDebugMode) {
          print('Theme Data Updated');
          print('Theme Color: $themeColor');
          print('Theme Mode: $themeMode');
        }
      });
    }
  }
}
