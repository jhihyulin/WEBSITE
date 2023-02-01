import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'SignIn.dart';
import 'Profile.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return SignInPage();
    } else {
      return ProfilePage();
    }
  }
}
