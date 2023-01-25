import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'Tool.dart';
import 'pages/Account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_twitter/firebase_ui_oauth_twitter.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'pages/Profile.dart';
import 'pages/SignIn.dart';
import 'pages/Account.dart';
import 'pages/Status.dart';
import 'pages/VPN.dart';
import 'pages/ShortURL.dart';
import 'pages/LongURL.dart';

final WEBSITE_NAME = 'JHIHYU\'S WEBSITE';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseUIAuth.configureProviders([
  //   GoogleProvider(
  //       clientId:
  //           '897798864282-t574p0gmq20jeu9u04cbt8270k1vk4cc.apps.googleusercontent.com'),
  //   TwitterProvider(
  //     apiKey: 'ItobTrCpFOOvmSc6zufiMLxds',
  //     apiSecretKey: 'TWITTER_SECRET',
  //   ),
  //   FacebookProvider(clientId: '1230943830699268')
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.system;
    return MaterialApp(
      title: WEBSITE_NAME,
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Montserrat',
          colorScheme: const ColorScheme.light()),
      darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Montserrat',
          colorScheme: const ColorScheme.dark()),
      themeMode: themeMode,
      home: Scaffold(
        body: BottomNavigationController(),
      ),
      routes: {
        '/account': (context) => AccountPage(),
        '/profile': (context) => ProfilePage(),
        '/home': (context) => HomePage(),
        '/tool': (context) => ToolPage(),
        '/signin': (context) => SignInPage(),
        '/status': (context) => StatusPage(),
        '/shorturl': (context) => ShortURLPage(),
        '/longurl': (context) => LongURLPage(),
        '/vpn': (context) => VPNPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class BottomNavigationController extends StatefulWidget {
  BottomNavigationController() : super();

  @override
  _BottomNavigationControllerState createState() =>
      _BottomNavigationControllerState();
}

class _BottomNavigationControllerState
    extends State<BottomNavigationController> {
  //目前選擇頁索引值
  int _currentIndex = 0; //預設值
  final pages = [HomePage(), ToolPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: const EdgeInsets.all(5),
          child: Image.asset('assets/images/logo-64x64.png'),
        ),
        title: Text(WEBSITE_NAME),
        actions: [
          Container(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton.icon(
              icon: Builder(
                builder: (context) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(user.photoURL ?? ''),
                    );
                  } else {
                    return CircleAvatar(
                      child: Icon(Icons.person),
                    );
                  }
                },
              ),
              label: Builder(
                builder: (context) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    return Text(user.displayName ?? '');
                  } else {
                    return Text('Sign In');
                  }
                },
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AccountPage()));
              },
            ),
          )
        ],
      ),
      body: pages[_currentIndex], //目前選擇頁面(Widget
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.construction),
            label: 'Tool',
          ),
        ],
        currentIndex: _currentIndex, //目前選擇頁索引值
        onTap: _onItemClick,
      ),
    );
  }

  //BottomNavigationBar 按下處理事件，更新設定當下索引值
  void _onItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
