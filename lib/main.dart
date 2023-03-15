import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';
import 'provider/theme.dart';
import 'tool.dart';
import 'pages/setting.dart';
import 'firebase_options.dart';
import 'pages/profile.dart';
import 'pages/sign_in.dart';
import 'pages/status.dart';
import 'pages/vpn.dart';
import 'pages/short_url.dart';
import 'pages/long_url.dart';
import 'pages/contact.dart';
import 'pages/about.dart';
import 'pages/bmi.dart';
import 'pages/timer.dart';
import 'pages/url_launcher.dart';
import 'pages/qr_generator.dart';
import 'pages/clock.dart';
import 'pages/zhsh_3d_map.dart';
import 'pages/404_page.dart';

const websiteName = 'JHIHYU\'S WEBSITE';
const desktopModeWidth = 640;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6LcPhjgkAAAAAAUtPybk3GHCkYZTxDd6w4kVOiQJ',
  );
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
            Color themeColor = themeProvider.themeColor;
            int themeMode = themeProvider.themeMode;
            return MaterialApp(
              title: websiteName,
              theme: ThemeData(
                  useMaterial3: true,
                  fontFamilyFallback: [
                    GoogleFonts.notoSans().fontFamily ?? '',
                    GoogleFonts.notoSerif().fontFamily ?? '',
                  ],
                  brightness: Brightness.light,
                  colorSchemeSeed: themeColor),
              darkTheme: ThemeData(
                  useMaterial3: true,
                  fontFamilyFallback: [
                    GoogleFonts.notoSans().fontFamily ?? '',
                    GoogleFonts.notoSerif().fontFamily ?? '',
                  ],
                  brightness: Brightness.dark,
                  colorSchemeSeed: themeColor),
              themeMode: themeMode == 0
                  ? ThemeMode.system
                  : themeMode == 1
                      ? ThemeMode.light
                      : ThemeMode.dark,
              home: Scaffold(
                body: NavigationController(),
              ),
              onGenerateRoute: (RouteSettings settings) {
                String? name = settings.name;
                WidgetBuilder? builder;
                Map<String, String>? parameters;
                // analyze parameters
                if (name!.contains(RegExp(r'.*[?].*[=].*'))) {
                  name.split(RegExp(r'[?&]')).forEach((String parameter) {
                    if (RegExp(r'.*[=].*').allMatches(parameter).isNotEmpty) {
                      List<String> parameterList = parameter.split('=');
                      parameters = {
                        ...parameters ?? {},
                        parameterList[0]: parameterList[1],
                      };
                    }
                  });
                }
                // ignore all query parameters
                name = name.replaceAll(RegExp(r'[?].*'), '');
                if (kDebugMode) {
                  print('Route Name: $name, Parameters: $parameters');
                }
                switch (name) {
                  case '/profile':
                    builder = (BuildContext context) => const ProfilePage();
                    break;
                  case '/signin':
                    builder = (BuildContext context) => SignInPage();
                    break;
                  case '/status':
                    builder = (BuildContext context) => const StatusPage();
                    break;
                  case '/vpn':
                    builder = (BuildContext context) => const VPNPage();
                    break;
                  case '/shorturl':
                    builder = (BuildContext context) => const ShortURLPage();
                    break;
                  case '/longurl':
                    builder = (BuildContext context) => const LongURLPage();
                    break;
                  case '/contact':
                    builder = (BuildContext context) => const ContactPage();
                    break;
                  case '/about':
                    builder = (BuildContext context) => const AboutPage();
                    break;
                  case '/bmi':
                    builder = (BuildContext context) => const BMIPage();
                    break;
                  case '/timer':
                    builder = (BuildContext context) => const TimerPage();
                    break;
                  case '/urllauncher':
                    builder = (BuildContext context) => const URLLauncherPage();
                    break;
                  case '/qrgenerator':
                    builder = (BuildContext context) => const QRGeneratorPage();
                    break;
                  case '/clock':
                    builder = (BuildContext context) => const ClockPage();
                    break;
                  case '/zhsh3dmap':
                    if (parameters != null) {
                      builder = (BuildContext context) => ZHSH3DMapPage(
                            embededMode: parameters!['embededMode'] == 'true',
                          );
                    } else {
                      builder = (BuildContext context) => ZHSH3DMapPage();
                    }
                    break;
                  case '/setting':
                    builder = (BuildContext context) => const SettingPage();
                    break;
                  case '/tool':
                    builder = (BuildContext context) =>
                        NavigationController(inputIndex: 1);
                    break;
                  default:
                    builder = (BuildContext context) => const NotFoundPage();
                }
                return MaterialPageRoute(builder: builder, settings: settings);
              },
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
  Widget _displayPhoto = const Icon(Icons.login);
  Widget _dispayText = const Text('Sign In');

  @override
  void initState() {
    super.initState();
    _firebasAuthEvent();
  }

  void _firebasAuthEvent() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (kDebugMode) {
          print('User is currently signed out!');
        }
        setState(() {
          _displayPhoto = const Icon(Icons.login);
          _dispayText = const Text('Sign In');
        });
      } else {
        if (kDebugMode) {
          print('User is signed in!');
        }
        setState(() {
          _displayPhoto = user.photoURL == null
              ? const Icon(Icons.person)
              : CircleAvatar(backgroundImage: NetworkImage(user.photoURL!));
          _dispayText = user.displayName == null
              ? user.email == null
                  ? user.phoneNumber == null
                      ? const Text('Unknown')
                      : Text(user.phoneNumber!)
                  : Text(user.email!)
              : Text(user.displayName!);
        });
      }
    });
  }

  final List<Widget> pages = [HomePage(), ToolPage()];

  bool _extended = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: const EdgeInsets.all(5),
          child: Image.asset('assets/images/logo-180x180.png'),
        ),
        title: const Text(websiteName),
        actions: [
          Container(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton.icon(
              icon: _displayPhoto,
              label: _dispayText,
              onPressed: () {
                if (FirebaseAuth.instance.currentUser == null) {
                  Navigator.pushNamed(context, '/signin');
                } else {
                  Navigator.pushNamed(context, '/profile');
                }
              },
            ),
          ),
          Offstage(
            offstage: MediaQuery.of(context).size.width >= desktopModeWidth,
            child: Container(
              padding: const EdgeInsets.all(5),
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/setting');
                },
              ),
            ),
          )
        ],
      ),
      body: MediaQuery.of(context).size.width < desktopModeWidth
          ? IndexedStack(index: _currentIndex, children: pages)
          : Row(
              children: [
                SafeArea(
                  child: IntrinsicWidth(
                    child: NavigationRail(
                        labelType: NavigationRailLabelType.none,
                        selectedIndex: _currentIndex,
                        destinations: [
                          const NavigationRailDestination(
                            icon: Icon(Icons.home_outlined),
                            selectedIcon: Icon(Icons.home),
                            label: Text('Home'),
                          ),
                          const NavigationRailDestination(
                            icon: Icon(Icons.build_outlined),
                            selectedIcon: Icon(Icons.build),
                            label: Text('Tool'),
                          ),
                          NavigationRailDestination(
                            icon: TextButton(
                                onPressed: () {
                                  setState(() => _extended = !_extended);
                                },
                                child: Icon(_extended
                                    ? Icons.arrow_left
                                    : Icons.arrow_right)),
                            label: _extended
                                ? const Text('Close')
                                : const Text(''),
                          ),
                        ],
                        extended: _extended,
                        onDestinationSelected: (int index) {
                          setState(() {
                            if (index == 2) {
                              setState(() => _extended = !_extended);
                            } else {
                              _onItemClick(index);
                            }
                          });
                        },
                        trailing: _extended
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/setting');
                                },
                                icon: const Icon(Icons.settings),
                                label: const Text('Setting'),
                              )
                            : TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/setting');
                                },
                                child: const Icon(Icons.settings),
                              )),
                  ),
                ),
                Expanded(
                  child: IndexedStack(index: _currentIndex, children: pages),
                ),
              ],
            ),
      bottomNavigationBar: MediaQuery.of(context).size.width < desktopModeWidth
          ? BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: _currentIndex == 0
                      ? const Icon(Icons.home)
                      : const Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _currentIndex == 1
                      ? const Icon(Icons.build)
                      : const Icon(Icons.build_outlined),
                  label: 'Tool',
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
