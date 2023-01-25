import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_twitter/firebase_ui_oauth_twitter.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: SignInScreen(
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
            AuthStateChangeAction<SignedIn>((context, state) {
              if (!state.user!.emailVerified) {
                Navigator.pushNamed(context, '/verify-email');
              } else {
                Navigator.pushReplacementNamed(context, '/profile');
              }
            }),
          ],
        ));
  }
}