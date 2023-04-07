import 'package:shared_preferences/shared_preferences.dart';
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
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        _user = user;
        // receive Firestore realtime data
        final docRef =
            FirebaseFirestore.instance.collection('user').doc(_user!.uid);
        docRef.snapshots().listen((event) {
          if (kDebugMode) {
            print('Remote Firestore Data Changed');
          }
          if (event.exists) {
            var data = event.data();
            if (data != null) {
              var preferance = data['preferance'];
              if (preferance != null) {
                dealData(preferance['themeMode'], preferance['themeColor']);
              }
            }
          }
        }, onError: (e) {
          if (kDebugMode) {
            print('Remote Firestore Data Changed Error: $e');
          }
        });
      } else {
        _user = null;
        dealData(null, null);
      }
    });
  }

  void dealData(int? firebaseThemeMode, int? firebaseThemeColor) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? cookieThemeColor = prefs.getInt('themeColor');
    int? cookieThemeMode = prefs.getInt('themeMode');
    int? targetFirebaseThemeColor = firebaseThemeColor ?? cookieThemeColor;
    int? targetFirebaseThemeMode = firebaseThemeMode ?? cookieThemeMode;
    _themeColor = Color(targetFirebaseThemeColor ?? dThemeColor.value);
    _themeMode = targetFirebaseThemeMode ?? dThemeMode;
    notifyListeners();
  }

  Color get themeColor => _themeColor;

  Color get defaultThemeColor => dThemeColor;

  setThemeColor(Color themeColor) async {
    _themeColor = themeColor;
    syncToFirebase(_themeMode, _themeColor);
    setData('themeColor', themeColor.value);
    notifyListeners();
  }

  int get themeMode => _themeMode;

  int get defaultThemeMode => dThemeMode;

  setThemeMode(int themeMode) async {
    _themeMode = themeMode;
    syncToFirebase(_themeMode, _themeColor);
    setData('themeMode', themeMode);
    notifyListeners();
  }

  void syncToFirebase(int themeMode, Color themeColor) async {
    if (_user != null) {
      FirebaseFirestore.instance.collection('user').doc(_user!.uid).update({
        'preferance': {'themeColor': themeColor.value, 'themeMode': themeMode}
      }).then((value) {
        if (kDebugMode) {
          print('Theme Data Synced to Firebase');
          print('Theme Color: $themeColor');
          print('Theme Mode: $themeMode');
        }
      });
    }
  }

  void setData(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    prefs.setInt(key, value);
    if (kDebugMode) {
      print('Saved with: key: $key, value: $value');
    }
  }
}
