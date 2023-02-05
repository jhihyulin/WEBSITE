import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../provider/Theme.dart';

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
                                initiallyExpanded: true,
                                title: Text('General'),
                                children: [
                                  ListTile(
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
                                    title: Text('Theme Color'),
                                    subtitle: Text(_themeColor
                                        .toString()
                                        .replaceAll('Color(0xff', '')
                                        .replaceAll(
                                            'MaterialColor(primary value: ', '')
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
                                                              Navigator.of(context).pop();
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
                      ],
                    )))));
  }
}
