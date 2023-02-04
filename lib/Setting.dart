import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/Theme.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  ThemeMode _themeMode = ThemeProvider().themeMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return SingleChildScrollView(
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
                            initiallyExpanded: true,
                            title: Text('General'),
                            children: [
                              ListTile(
                                title: Text('Theme Mode'),
                                subtitle: _themeMode == ThemeMode.system
                                    ? Text('System')
                                    : _themeMode == ThemeMode.light
                                        ? Text('Light')
                                        : Text('Dark'),
                                trailing: ToggleButtons(
                                  borderRadius: BorderRadius.circular(16),
                                  children: [
                                    Icon(Icons.brightness_auto),
                                    Icon(Icons.light_mode),
                                    Icon(Icons.dark_mode),
                                  ],
                                  isSelected: [
                                    _themeMode == ThemeMode.system,
                                    _themeMode == ThemeMode.light,
                                    _themeMode == ThemeMode.dark,
                                  ],
                                  onPressed: (index) {
                                    setState(() {
                                      _themeMode = ThemeMode.values[index];
                                      Provider.of<ThemeProvider>(context,
                                              listen: false)
                                          .setThemeMode(_themeMode);
                                    });
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ))));
  }
}
