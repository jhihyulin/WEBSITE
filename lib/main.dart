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
import 'package:firebase_app_check/firebase_app_check.dart';
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

Map<String, Widget Function(BuildContext)> _routes = {
  '/account': (BuildContext context) => AccountPage(),
  '/profile': (BuildContext context) => ProfilePage(),
  '/signin': (BuildContext context) => SignInPage(),
  '/status': (BuildContext context) => StatusPage(),
  '/vpn': (BuildContext context) => VPNPage(),
  '/shorturl': (BuildContext context) => ShortURLPage(),
  '/longurl': (BuildContext context) => LongURLPage(),
  '/contact': (BuildContext context) => ContactPage(),
  '/about': (BuildContext context) => AboutPage(),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6LcPhjgkAAAAAAUtPybk3GHCkYZTxDd6w4kVOiQJ',
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
      routes: _routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

int _currentIndex = 0;

class BottomNavigationController extends StatefulWidget {
  final int inputIndex;
  BottomNavigationController({Key? key, this.inputIndex = 0})
      : super(key: key) {
    _currentIndex = inputIndex;
  }

  @override
  _BottomNavigationControllerState createState() =>
      _BottomNavigationControllerState();
}

class _BottomNavigationControllerState
    extends State<BottomNavigationController> {
  Widget _displayPhoto = Icon(Icons.login);
  Widget _dispayText = Text('Sign In');

  void initState() {
    super.initState();
    _FirebasAuthEvent();
  }

  void _FirebasAuthEvent() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        setState(() {
          _displayPhoto = Icon(Icons.login);
          _dispayText = Text('Sign In');
        });
      } else {
        print('User is signed in!');
        setState(() {
          _displayPhoto = user.photoURL == null
              ? Icon(Icons.person)
              : CircleAvatar(backgroundImage: NetworkImage(user.photoURL!));
          _dispayText = user.displayName == null
              ? user.email == null
                  ? user.phoneNumber == null
                      ? Text('Unknown')
                      : Text(user.phoneNumber!)
                  : Text(user.email!)
              : Text(user.displayName!);
        });
      }
    });
  }

  final List<Widget> pages = [HomePage(), ToolPage()];

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
              icon: _displayPhoto,
              label: _dispayText,
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
