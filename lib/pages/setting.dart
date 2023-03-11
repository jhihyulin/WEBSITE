import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/theme.dart';
import '../plugins/logo_icons.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    int _themeMode =
        Provider.of<ThemeProvider>(context, listen: false).themeMode;
    List<bool> _themeModeIsSelected = List.generate(3, (i) {
      if (i == _themeMode) {
        return true;
      }
      return false;
    });
    Color _themeColor =
        Provider.of<ThemeProvider>(context, listen: false).themeColor;
    bool _syncSelect = true;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
        appBar: AppBar(
          title: Text('Setting'),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 700,
                      minHeight: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          58, //BottomNavigationBar Height
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          child: Theme(
                              data: theme,
                              child: ExpansionTile(
                                leading: Icon(Icons.tune),
                                initiallyExpanded: true,
                                title: Text('General'),
                                children: [
                                  ListTile(
                                    leading: user != null
                                        ? Icon(Icons.sync)
                                        : Icon(Icons.sync_disabled),
                                    title: user != null
                                        ? Text('Logged in')
                                        : Text('Logged out'),
                                    subtitle: user != null
                                        ? Text(
                                            'Settings will sync to your account.')
                                        : Text(
                                            'Login to sync settings to your account.'),
                                  ),
                                  ListTile(
                                    leading: _themeMode == 0
                                        ? Icon(Icons.brightness_auto)
                                        : _themeMode == 1
                                            ? Icon(Icons.light_mode)
                                            : Icon(Icons.dark_mode),
                                    title: Text('Theme Mode'),
                                    subtitle: _themeMode == 0
                                        ? Text('System')
                                        : _themeMode == 1
                                            ? Text('Light')
                                            : Text('Dark'),
                                    trailing: ToggleButtons(
                                      borderRadius: BorderRadius.circular(16),
                                      children: [
                                        Icon(Icons.brightness_auto),
                                        Icon(Icons.light_mode),
                                        Icon(Icons.dark_mode),
                                      ],
                                      isSelected: _themeModeIsSelected,
                                      onPressed: (int index) {
                                        setState(() {
                                          for (int buttonIndex = 0;
                                              buttonIndex <
                                                  _themeModeIsSelected.length;
                                              buttonIndex++) {
                                            if (buttonIndex == index) {
                                              _themeModeIsSelected[
                                                  buttonIndex] = true;
                                              _themeMode = buttonIndex;
                                            } else {
                                              _themeModeIsSelected[
                                                  buttonIndex] = false;
                                            }
                                          }
                                          Provider.of<ThemeProvider>(context,
                                                  listen: false)
                                              .setThemeMode(_themeMode);
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.color_lens),
                                    title: Text('Theme Color'),
                                    subtitle: Text(_themeColor
                                        .toString()
                                        .replaceAll('Color(0xff', '')
                                        .replaceAll(
                                            'MaterialColor(primary value: ', '')
                                        .replaceAll(
                                            'ColorSwatch(primary value: ', '')
                                        .replaceAll(')', '')),
                                    trailing: InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: _themeColor,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    title: Text('Theme Color'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ColorPicker(
                                                        pickerColor:
                                                            _themeColor,
                                                        onColorChanged:
                                                            (color) {
                                                          setState(() {
                                                            _themeColor = color;
                                                          });
                                                        },
                                                        pickerAreaHeightPercent:
                                                            0.8,
                                                        enableAlpha: false,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _themeColor = Provider.of<
                                                                          ThemeProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .defaultThemeColor;
                                                              Provider.of<ThemeProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .setThemeColor(
                                                                      _themeColor);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          child: Text('Reset')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              Text('Cancel')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Provider.of<ThemeProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .setThemeColor(
                                                                    _themeColor);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('OK'))
                                                    ]);
                                              });
                                        }),
                                  )
                                ],
                              )),
                        ),
                        Card(
                            child: Theme(
                          data: theme,
                          child: ExpansionTile(
                            leading: Icon(Icons.info),
                            initiallyExpanded: false,
                            title: Text('About'),
                            children: [
                              ListTile(
                                  leading: Icon(Icons.handyman),
                                  title: Wrap(
                                      alignment: WrapAlignment.start,
                                      runAlignment: WrapAlignment.center,
                                      children: [
                                        InkWell(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Container(
                                              padding: EdgeInsets.all(15),
                                              child: Image(
                                                  image: AssetImage(
                                                      'assets/images/BuiltWithFlutter.png'),
                                                  height: 30),
                                            ),
                                            onTap: () {
                                              launchUrl(Uri.parse(
                                                  'https://flutter.dev'));
                                            }),
                                        InkWell(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Container(
                                              child: Image(
                                                  image: AssetImage(
                                                      'assets/images/BuiltWithFirebaseLightRemoveBackground.png'),
                                                  height: 60),
                                            ),
                                            onTap: () {
                                              launchUrl(Uri.parse(
                                                  'https://firebase.google.com'));
                                            }),
                                      ])),
                              ListTile(
                                  leading: Icon(Icons.code),
                                  title: Text('License'),
                                  subtitle: Text('MIT License'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.open_in_new),
                                    onPressed: () {
                                      launchUrl(Uri.parse(
                                          'https://github.com/jhihyulin/WEBSITE/blob/main/LICENSE'));
                                    },
                                  )),
                              ListTile(
                                  leading: Icon(Logo.github),
                                  title: Text('Repository'),
                                  subtitle: Text('jhihyulin/WEBSITE'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.open_in_new),
                                    onPressed: () {
                                      launchUrl(Uri.parse(
                                          'https://github.com/jhihyulin/WEBSITE'));
                                    },
                                  )),
                              ListTile(
                                  leading: Icon(Icons.email),
                                  title: Text('Contact'),
                                  subtitle: Container(
                                    alignment: Alignment.centerLeft,
                                    child: SelectionArea(
                                      child: Text('JY@jhihyulin.live'),
                                    )
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.open_in_new),
                                    onPressed: () {
                                      launchUrl(Uri.parse(
                                          'mailto:JY@jhihyulin.live'));
                                    },
                                  )),
                              Text('ALL RIGHTS RESERVED © 2023 JHIHYULIN.LIVE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ))
                      ],
                    )))));
  }
}
