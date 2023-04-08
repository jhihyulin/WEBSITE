import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_twitter/firebase_ui_oauth_twitter.dart';

String _redirectPage = '/profile';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key, String redirectPage = '/profile'}) : super(key: key) {
    _redirectPage = redirectPage;
  }
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  void _uploaduserinfo() {
    FirebaseAuth.instance.currentUser!.reload();
    User user = FirebaseAuth.instance.currentUser!;
    DocumentReference<Map<String, dynamic>> ref =
        FirebaseFirestore.instance.collection('user').doc(user.uid);
    List providerData = [];
    for (UserInfo userInfo in user.providerData) {
      providerData.add({
        'providerId': userInfo.providerId,
        'uid': userInfo.uid,
        'displayName': userInfo.displayName,
        'photoURL': userInfo.photoURL,
        'email': userInfo.email,
        'phoneNumber': userInfo.phoneNumber,
      });
    }
    // print(user.providerData);
    // print(providerData);
    ref
        .update({
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'uid': user.uid,
          'emailVerified': user.emailVerified,
          'phoneNumber': user.phoneNumber,
          'isAnonymous': user.isAnonymous,
          'isEmailVerified': user.emailVerified,
          'lastSignInTime':
              user.metadata.lastSignInTime?.millisecondsSinceEpoch,
          'providerData': providerData,
        })
        .then((value) => {print('User Data Updated')})
        .catchError((error) => {
              if (kDebugMode)
                {
                  print(
                      'Failed to update user data, will try to create: $error')
                },
              ref
                  .set({
                    'email': user.email,
                    'name': user.displayName,
                    'photoURL': user.photoURL,
                    'uid': user.uid,
                    'emailVerified': user.emailVerified,
                    'phoneNumber': user.phoneNumber,
                    'isAnonymous': user.isAnonymous,
                    'isEmailVerified': user.emailVerified,
                    'creationTime':
                        user.metadata.creationTime?.millisecondsSinceEpoch,
                    'lastSignInTime':
                        user.metadata.lastSignInTime?.microsecondsSinceEpoch,
                    'providerData': providerData,
                  })
                  .then((value) => {print('User Data Created')})
                  .catchError((error) => {
                        if (kDebugMode)
                          {print('Failed to set and update user data: $error')}
                      })
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _redirectPage == '/profile'
              ? const Text('Sign In')
              : const Text('Sign In to Continue'),
        ),
        body: SignInScreen(
          breakpoint: 700,
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
              _uploaduserinfo();
              if (!state.user!.emailVerified) {
                Navigator.pushNamed(context, '/verify-email');
              } else {
                Navigator.pushReplacementNamed(context, _redirectPage);
              }
            }),
          ],
        ));
  }
}
