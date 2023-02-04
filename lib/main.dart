import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';

import 'Home.dart';
import 'provider/Theme.dart';
import 'Tool.dart';
import 'Setting.dart';
import 'FirebaseOptions.dart';
import 'pages/Profile.dart';
import 'pages/SignIn.dart';
import 'pages/Status.dart';
import 'pages/VPN.dart';
import 'pages/ShortURL.dart';
import 'pages/LongURL.dart';
import 'pages/Contact.dart';
import 'pages/About.dart';
import 'pages/BMI.dart';

final WEBSITE_NAME = 'JHIHYU\'S WEBSITE';
final DesktopModeWidth = 640;

Map<String, Widget Function(BuildContext)> _routes = {
  '/profile': (BuildContext context) => ProfilePage(),
  '/signin': (BuildContext context) => SignInPage(),
  '/status': (BuildContext context) => StatusPage(),
  '/vpn': (BuildContext context) => VPNPage(),
  '/shorturl': (BuildContext context) => ShortURLPage(),
  '/longurl': (BuildContext context) => LongURLPage(),
  '/contact': (BuildContext context) => ContactPage(),
  '/about': (BuildContext context) => AboutPage(),
  '/bmi': (BuildContext context) => BMIPage(),
  '/home': (BuildContext context) => NavigationController(inputIndex: 0),
  '/tool': (BuildContext context) => NavigationController(inputIndex: 1),
  '/setting': (BuildContext context) => NavigationController(inputIndex: 2),
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(),
          ),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            Color _themeColor = themeProvider.themeColor;
            ThemeMode _themeMode = themeProvider.themeMode;
            return MaterialApp(
              title: WEBSITE_NAME,
              theme: ThemeData(
                useMaterial3: true,
                fontFamily: 'Montserrat',
                brightness: Brightness.light,
                colorSchemeSeed: _themeColor
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                fontFamily: 'Montserrat',
                brightness: Brightness.dark,
                colorSchemeSeed: _themeColor
              ),
              themeMode: _themeMode,
              home: Scaffold(
                body: NavigationController(),
              ),
              routes: _routes,
              debugShowCheckedModeBanner: false,
            );
          },
        ));
  }
}

int _currentIndex = 0;

class NavigationController extends StatefulWidget {
  final int inputIndex;
  NavigationController({Key? key, this.inputIndex = 0}) : super(key: key) {
    _currentIndex = inputIndex;
  }

  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
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

  final List<Widget> pages = [HomePage(), ToolPage(), SettingPage()];
  final List pagesRoute = ['home', '/tool', '/setting'];

  bool _extended = false;

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
                if (FirebaseAuth.instance.currentUser == null)
                  Navigator.pushNamed(context, '/signin');
                else
                  Navigator.pushNamed(context, '/profile');
              },
            ),
          )
        ],
      ),
      body: MediaQuery.of(context).size.width < DesktopModeWidth
          ? IndexedStack(index: _currentIndex, children: pages)
          : Row(
              children: [
                SafeArea(
                  child: IntrinsicWidth(
                    child: NavigationRail(
                      labelType: NavigationRailLabelType.none,
                      selectedIndex: _currentIndex,
                      // Not working>>>
                      // leading: GestureDetector(
                      //   onTap: () {
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) => AlertDialog(
                      //         title: Text('Change Color'),
                      //         content: SingleChildScrollView(
                      //           child: ColorPicker(
                      //             pickerColor: _seedColor,
                      //             onColorChanged: (color) {
                      //               setState(() {
                      //                 _seedColor = color;
                      //               });
                      //             },
                      //           ),
                      //         ),
                      //         actions: [
                      //           TextButton(
                      //             child: Text('OK'),
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      //   child: Container(
                      //     width: 48,
                      //     height: 48,
                      //     decoration: BoxDecoration(
                      //       color: _seedColor,
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child: Center(
                      //       child: Icon(Icons.colorize,
                      //           color: Theme.of(context).colorScheme.onPrimary),
                      //     ),
                      //   ),
                      // ),
                      destinations: [
                        NavigationRailDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.build_outlined),
                          selectedIcon: Icon(Icons.build),
                          label: Text('Tool'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings),
                          label: Text('Setting'),
                        ),
                        NavigationRailDestination(
                          icon: TextButton(
                              onPressed: () {
                                setState(() => _extended = !_extended);
                              },
                              child: Icon(_extended
                                  ? Icons.arrow_left
                                  : Icons.arrow_right)),
                          label: _extended ? Text('Close') : Text(''),
                        ),
                      ],
                      extended: _extended,
                      onDestinationSelected: (int index) {
                        setState(() {
                          if (index == 3) {
                            setState(() => _extended = !_extended);
                          } else {
                            _onItemClick(index);
                          }
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: IndexedStack(index: _currentIndex, children: pages),
                ),
              ],
            ),
      bottomNavigationBar: MediaQuery.of(context).size.width < DesktopModeWidth
          ? BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: _currentIndex == 0
                      ? Icon(Icons.home)
                      : Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _currentIndex == 1
                      ? Icon(Icons.build)
                      : Icon(Icons.build_outlined),
                  label: 'Tool',
                ),
                BottomNavigationBarItem(
                  icon: _currentIndex == 2
                      ? Icon(Icons.settings)
                      : Icon(Icons.settings_outlined),
                  label: 'Setting',
                ),
              ],
              currentIndex: _currentIndex,
              onTap: _onItemClick,
            )
          : null,
    );
  }

  void _onItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
