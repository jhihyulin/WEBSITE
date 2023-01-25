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
import 'pages/Contact.dart';
import 'pages/About.dart';

final WEBSITE_NAME = 'JHIHYU\'S WEBSITE';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  usePathUrlStrategy();
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
        '/about': (context) => AboutPage(),
        '/contact': (context) => ContactPage(),
        '/account': (context) => AccountPage(),
        '/profile': (context) => ProfilePage(),
        '/signin': (context) => SignInPage(),
        '/status': (context) => StatusPage(),
        '/shorturl': (context) => ShortURLPage(),
        '/longurl': (context) => LongURLPage(),
        '/vpn': (context) => VPNPage(),
        '/tool': (context) => BottomNavigationController(inputIndex: 1),
        '/home': (context) => BottomNavigationController(inputIndex: 0),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

int _currentIndex = 0;
class BottomNavigationController extends StatefulWidget {
  final int inputIndex;
  BottomNavigationController({Key? key, this.inputIndex = 0}) : super(key: key) {
    _currentIndex = inputIndex;
  }

  @override
  _BottomNavigationControllerState createState() =>
      _BottomNavigationControllerState();
}

class _BottomNavigationControllerState
    extends State<BottomNavigationController> {
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
                Navigator.of(context).pushNamed('/account');
              },
            ),
          )
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
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
        currentIndex: _currentIndex,
        onTap: _onItemClick,
      ),
    );
  }

  void _onItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
