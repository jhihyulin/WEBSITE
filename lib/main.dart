import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home.dart';
import '../provider/theme.dart';
import '../tool.dart';
import '../firebase_options.dart';
import '../setting.dart';
import '../pages/load_failed.dart';
import '../pages/profile.dart' deferred as profile;
import '../pages/sign_in.dart' deferred as sign_in;
import '../pages/status.dart' deferred as status;
import '../pages/vpn.dart' deferred as vpn;
import '../pages/short_url.dart' deferred as short_url;
import '../pages/long_url.dart' deferred as long_url;
import '../pages/contact.dart' deferred as contact;
import '../pages/about.dart' deferred as about;
import '../pages/bmi.dart' deferred as bmi;
import '../pages/timer.dart' deferred as timer;
import '../pages/url_launcher.dart' deferred as url_launcher;
import '../pages/qr_generator.dart' deferred as qr_generator;
import '../pages/clock.dart' deferred as clock;
import '../pages/zhsh_3d_map.dart' deferred as zhsh_3d_map;
import '../pages/not_found.dart' deferred as not_found;
import '../pages/tw_university_result_query.dart' deferred as tw_university_result_query;
import '../pages/spin_wheel.dart' deferred as spin_wheel;
import '../pages/privacy_policy.dart' deferred as privacy_policy;
import '../pages/terms_of_service.dart' deferred as terms_of_service;
import '../pages/chat.dart' deferred as chat;
import '../pages/chat_ai.dart' deferred as chatai;
import '../pages/loading.dart';

const websiteName = 'JHIHYU\'S WEBSITE';
const desktopModeWidth = 700;

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
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget Function(BuildContext) loadPage(Future<void> Function() loadLibrary, Widget Function(BuildContext) page) {
    return (BuildContext context) => FutureBuilder(
          future: loadLibrary(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return LoadFailedPage(errorMessage: snapshot.error.toString());
              } else {
                return page(context);
              }
            } else {
              return const LoadingPage();
            }
          },
        );
  }

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
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontFamilyFallback: [
                GoogleFonts.montserrat().fontFamily ?? '',
                GoogleFonts.notoSans().fontFamily ?? '',
                GoogleFonts.lato().fontFamily ?? '',
              ],
              brightness: Brightness.light,
              colorSchemeSeed: themeColor,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontFamilyFallback: [
                GoogleFonts.montserrat().fontFamily ?? '',
                GoogleFonts.notoSans().fontFamily ?? '',
                GoogleFonts.lato().fontFamily ?? '',
              ],
              brightness: Brightness.dark,
              colorSchemeSeed: themeColor,
            ),
            themeMode: themeMode == 0
                ? ThemeMode.system
                : themeMode == 1
                    ? ThemeMode.light
                    : ThemeMode.dark,
            home: const Scaffold(
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
                      // ignore parameter case
                      parameterList[0].toLowerCase(): parameterList[1]
                    };
                  }
                });
              }
              // ignore all query parameters
              name = name.replaceAll(RegExp(r'[?].*'), '');
              // ignore URL case
              name = name.toLowerCase();
              if (kDebugMode) {
                print('Route Name: $name, Parameters: $parameters');
              }
              switch (name) {
                case '/profile':
                  builder = loadPage(profile.loadLibrary, (context) {
                    return profile.ProfilePage();
                  });
                  break;
                case '/signin':
                  builder = loadPage(sign_in.loadLibrary, (context) {
                    return sign_in.SignInPage();
                  });
                  break;
                case '/status':
                  builder = loadPage(status.loadLibrary, (context) {
                    return status.StatusPage();
                  });
                  break;
                case '/vpn':
                  builder = loadPage(vpn.loadLibrary, (context) {
                    return vpn.VPNPage();
                  });
                  break;
                case '/shorturl':
                  builder = loadPage(short_url.loadLibrary, (context) {
                    return short_url.ShortURLPage();
                  });
                  break;
                case '/longurl':
                  builder = loadPage(long_url.loadLibrary, (context) {
                    return long_url.LongURLPage();
                  });
                  break;
                case '/contact':
                  builder = loadPage(contact.loadLibrary, (context) {
                    return contact.ContactPage();
                  });
                  break;
                case '/about':
                  builder = loadPage(about.loadLibrary, (context) {
                    return about.AboutPage();
                  });
                  break;
                case '/bmi':
                  builder = loadPage(bmi.loadLibrary, (context) {
                    return bmi.BMIPage();
                  });
                  break;
                case '/timer':
                  builder = loadPage(timer.loadLibrary, (context) {
                    return timer.TimerPage();
                  });
                  break;
                case '/urllauncher':
                  builder = loadPage(url_launcher.loadLibrary, (context) {
                    return url_launcher.URLLauncherPage();
                  });
                  break;
                case '/qrgenerator':
                  builder = loadPage(qr_generator.loadLibrary, (context) {
                    return qr_generator.QRGeneratorPage();
                  });
                  break;
                case '/clock':
                  builder = loadPage(clock.loadLibrary, (context) {
                    return clock.ClockPage();
                  });
                  break;
                case '/zhsh3dmap':
                  if (parameters != null) {
                    builder = loadPage(zhsh_3d_map.loadLibrary, (context) {
                      return zhsh_3d_map.ZHSH3DMapPage(
                        embededMode: parameters!['embededmode'] == 'true',
                      );
                    });
                  } else {
                    builder = loadPage(zhsh_3d_map.loadLibrary, (context) {
                      return zhsh_3d_map.ZHSH3DMapPage();
                    });
                  }
                  break;
                case '/twuniversityresultquery':
                  if (parameters != null) {
                    builder = loadPage(tw_university_result_query.loadLibrary, (context) {
                      return tw_university_result_query.TWUniversityResultQueryPage(
                        id: parameters!['id'] ?? '',
                      );
                    });
                  } else {
                    builder = loadPage(tw_university_result_query.loadLibrary, (context) {
                      return tw_university_result_query.TWUniversityResultQueryPage();
                    });
                  }
                  break;
                case '/spinwheel':
                  builder = loadPage(spin_wheel.loadLibrary, (context) {
                    return spin_wheel.SpinWheelPage();
                  });
                  break;
                case '/chatai':
                  builder = loadPage(chatai.loadLibrary, (context) {
                    return chatai.ChatAIPage();
                  });
                  break;
                case '/privacypolicy':
                  builder = loadPage(privacy_policy.loadLibrary, (context) {
                    return privacy_policy.PrivacyPolicyPage();
                  });
                  break;
                case '/termsofservice':
                  builder = loadPage(terms_of_service.loadLibrary, (context) {
                    return terms_of_service.TermsOfServicePage();
                  });
                  break;
                case '/chat':
                  builder = loadPage(chat.loadLibrary, (context) {
                    return chat.ChatPage();
                  });
                  break;
                case '/':
                  builder = (BuildContext context) => const NavigationController();
                  break;
                default:
                  builder = loadPage(not_found.loadLibrary, (context) {
                    return not_found.NotFoundPage();
                  });
              }
              return MaterialPageRoute(
                builder: builder,
                settings: settings,
              );
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class NavigationController extends StatefulWidget {
  const NavigationController({Key? key}) : super(key: key);

  @override
  State<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  Widget _displayPhoto = const Icon(Icons.login);
  Widget _dispayText = const Text('Sign In');
  int _currentIndex = 0;

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
              : Container(
                  padding: const EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                );
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

  final List<Widget> pages = [
    const HomePage(),
    ToolPage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            'assets/images/logo-180x180.png',
            frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(
                  seconds: 1,
                ),
                curve: Curves.easeOut,
                child: child,
              );
            },
          ),
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
        ],
      ),
      body: MediaQuery.of(context).size.width < desktopModeWidth
          ? AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 500,
              ),
              child: pages[_currentIndex],
            )
          : Row(
              children: [
                SafeArea(
                  child: IntrinsicWidth(
                    child: NavigationRail(
                      labelType: NavigationRailLabelType.selected,
                      selectedIndex: _currentIndex,
                      destinations: const [
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
                      ],
                      onDestinationSelected: (int index) {
                        setState(() {
                          _onItemClick(index);
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    child: pages[_currentIndex],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: MediaQuery.of(context).size.width < desktopModeWidth
          ? NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: _currentIndex,
              onDestinationSelected: _onItemClick,
              destinations: <Widget>[
                NavigationDestination(
                  icon: _currentIndex == 0 ? const Icon(Icons.home) : const Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: _currentIndex == 1 ? const Icon(Icons.build) : const Icon(Icons.build_outlined),
                  label: 'Tool',
                ),
                NavigationDestination(
                  icon: _currentIndex == 2 ? const Icon(Icons.settings) : const Icon(Icons.settings_outlined),
                  label: 'Setting',
                ),
              ],
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
