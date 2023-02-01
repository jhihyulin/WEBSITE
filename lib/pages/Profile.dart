import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_twitter/firebase_ui_oauth_twitter.dart';

import 'SignIn.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return SignInPage(redirectPage: '/profile');
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: ProfileScreen(
          providers: [
            EmailAuthProvider(),
            PhoneAuthProvider(),
            GoogleProvider(
                clientId:
                    '897798864282-t574p0gmq20jeu9u04cbt8270k1vk4cc.apps.googleusercontent.com'),
            TwitterProvider(
              apiKey: 'ItobTrCpFOOvmSc6zufiMLxds',
              apiSecretKey: 'TWITTER_SECRET',
            ),
            FacebookProvider(clientId: '1230943830699268')
          ],
          actions: [
            SignedOutAction((context) {
              Navigator.pushReplacementNamed(context, '/signin');
            }),
          ],
        ),
      );
    }
  }
}
