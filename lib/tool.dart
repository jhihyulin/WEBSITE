import 'package:flutter/material.dart';

class ToolPage extends StatelessWidget {
  final Map<String, Map<String, dynamic>> _tools = {
    'status': {
      'title': 'Status',
      'icon': Icons.monitor_heart,
      'route': '/status',
    },
    'vpn': {
      'title': 'VPN',
      'icon': Icons.vpn_key,
      'route': '/vpn',
    },
    'shorturl': {
      'title': 'Short URL',
      'icon': Icons.link,
      'route': '/shorturl',
    },
    'longurl': {
      'title': 'Long URL',
      'icon': Icons.link,
      'route': '/longurl',
    },
    'bmi': {
      'title': 'BMI',
      'icon': Icons.accessibility,
      'route': '/bmi',
    },
    'timer': {
      'title': 'Timer',
      'icon': Icons.timer,
      'route': '/timer',
    },
    'urllauncher': {
      'title': 'URL Launcher',
      'icon': Icons.rocket_launch,
      'route': '/urllauncher',
    },
    'qr': {
      'title': 'QR Generator',
      'icon': Icons.qr_code,
      'route': '/qrgenerator',
    },
    'clock': {
      'title': 'Clock',
      'icon': Icons.access_time,
      'route': '/clock',
    },
    'zhsh3dmap': {
      'title': 'ZHSH 3D Map',
      'icon': Icons.map,
      'route': '/zhsh3dmap',
    },
  };

  @override
  Widget build(BuildContext context) {
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
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        for (var tool in _tools.entries)
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(context, tool.value['route']);
                            },
                            icon: Icon(tool.value['icon']),
                            label: Text(tool.value['title'])
                          )
                      ],
                    ),
                  ],
                ))));
  }
}
