import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../provider/theme.dart';
import '../widget/expansion_tile.dart';
import '../widget/launch_url.dart';
import '../widget/toggle_buttons.dart';
import '../widget/image.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final Map<Color, String> _colors = {
    Colors.red: 'Red',
    Colors.pink: 'Pink',
    Colors.purple: 'Purple',
    Colors.deepPurple: 'Deep Purple',
    Colors.indigo: 'Indigo',
    Colors.blue: 'Blue',
    Colors.lightBlue: 'Light Blue',
    Colors.cyan: 'Cyan',
    Colors.teal: 'Teal',
    Colors.green: 'Green',
    Colors.lightGreen: 'Light Green',
    Colors.lime: 'Lime',
    Colors.yellow: 'Yellow',
    Colors.amber: 'Amber',
    Colors.orange: 'Orange',
    Colors.deepOrange: 'Deep Orange',
    Colors.brown: 'Brown',
    Colors.grey: 'Grey',
    Colors.blueGrey: 'Blue Grey',
  };
  String colorString(Color color) {
    String colorHashCode(Color color) {
      return color
          .toString()
          .replaceAll('Color(0xff', '')
          .replaceAll('MaterialColor(primary value: ', '')
          .replaceAll('ColorSwatch(primary value: ', '')
          .replaceAll(')', '');
    }

    for (MapEntry<Color, String> entry in _colors.entries) {
      if (colorHashCode(entry.key) == colorHashCode(color)) {
        return entry.value;
      }
    }
    return colorHashCode(color);
  }

  @override
  Widget build(BuildContext context) {
    int themeMode = Provider.of<ThemeProvider>(context, listen: true).themeMode;
    List<bool> themeModeIsSelected = List.generate(3, (i) {
      if (i == themeMode) {
        return true;
      }
      return false;
    });
    Color themeColor =
        Provider.of<ThemeProvider>(context, listen: true).themeColor;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 700,
            minHeight: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                (MediaQuery.of(context).size.width > 700
                    ? 0
                    : 80), //NavigationBar Height
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: CustomExpansionTile(
                  leading: const Icon(Icons.tune),
                  initiallyExpanded: true,
                  title: const Text('General'),
                  children: [
                    ListTile(
                      leading: user != null
                          ? const Icon(Icons.sync)
                          : const Icon(Icons.sync_disabled),
                      title: user != null
                          ? const Text('Logged in')
                          : const Text('Logged out'),
                      subtitle: user != null
                          ? const Text(
                              'Settings will sync to your account, and take effect on all devices immediately.')
                          : const Text(
                              'Login to sync settings to your account.'),
                    ),
                    ListTile(
                      leading: themeMode == 0
                          ? const Icon(Icons.brightness_auto)
                          : themeMode == 1
                              ? const Icon(Icons.light_mode)
                              : const Icon(Icons.dark_mode),
                      title: const Text('Theme Mode'),
                      subtitle: themeMode == 0
                          ? const Text('System')
                          : themeMode == 1
                              ? const Text('Light')
                              : const Text('Dark'),
                      trailing: CustomToggleButtons(
                        isSelected: themeModeIsSelected,
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < themeModeIsSelected.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                themeModeIsSelected[buttonIndex] = true;
                                themeMode = buttonIndex;
                              } else {
                                themeModeIsSelected[buttonIndex] = false;
                              }
                            }
                            Provider.of<ThemeProvider>(context, listen: false)
                                .setThemeMode(themeMode);
                          });
                        },
                        children: const [
                          Icon(Icons.brightness_auto),
                          Icon(Icons.light_mode),
                          Icon(Icons.dark_mode),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.color_lens),
                      title: const Text('Theme Color'),
                      subtitle: Text(colorString(themeColor)),
                      trailing: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                icon: const Icon(Icons.color_lens),
                                title: const Text('Theme Color'),
                                content: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: BlockPicker(
                                    availableColors: _colors.keys.toList(),
                                    pickerColor: themeColor,
                                    onColorChanged: (color) {
                                      setState(() {
                                        themeColor = color;
                                      });
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        themeColor = Provider.of<ThemeProvider>(
                                                context,
                                                listen: false)
                                            .defaultThemeColor;
                                        Provider.of<ThemeProvider>(context,
                                                listen: false)
                                            .setThemeColor(themeColor);
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text('Reset'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Provider.of<ThemeProvider>(context,
                                              listen: false)
                                          .setThemeColor(themeColor);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: CustomExpansionTile(
                  leading: const Icon(Icons.info),
                  initiallyExpanded: false,
                  title: const Text('About'),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.handyman),
                      title: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.center,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              child: const CustomImage(
                                src: 'assets/images/BuiltWithFlutter.png',
                                height: 30,
                              ),
                            ),
                            onTap: () {
                              CustomLaunchUrl.launch(
                                  context, 'https://flutter.dev');
                            },
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(16),
                            child: const CustomImage(
                              src:
                                  'assets/images/BuiltWithFirebaseLightRemoveBackground.png',
                              height: 60,
                            ),
                            onTap: () {
                              CustomLaunchUrl.launch(
                                  context, 'https://firebase.google.com');
                            },
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: const Text('License'),
                      subtitle: const Text('MIT License'),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () {
                          CustomLaunchUrl.launch(context,
                              'https://github.com/jhihyulin/WEBSITE/blob/main/LICENSE');
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(FontAwesome.github),
                      title: const Text('Repository'),
                      subtitle: const Text('jhihyulin/WEBSITE'),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () {
                          CustomLaunchUrl.launch(
                              context, 'https://github.com/jhihyulin/WEBSITE');
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Contact'),
                      subtitle: Container(
                        alignment: Alignment.centerLeft,
                        child: const SelectionArea(
                          child: Text('JY@jhihyulin.live'),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () {
                          CustomLaunchUrl.launch(
                              context, 'mailto:JY@jhihyulin.live');
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.web),
                      title: const Text('Version'),
                      subtitle: FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (BuildContext context,
                            AsyncSnapshot<PackageInfo> snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                                '${snapshot.data!.version}+${snapshot.data!.buildNumber}');
                          } else {
                            return const Text('Loading...');
                          }
                        },
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/privacypolicy');
                          },
                          child: const Text('Privacy Policy'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/termsofservice');
                          },
                          child: const Text('Terms of Service'),
                        ),
                      ],
                    ),
                    Text(
                      'ALL RIGHTS RESERVED © ${DateTime.now().year} JHIHYULIN.LIVE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodySmall?.fontSize,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
