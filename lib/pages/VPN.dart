import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VPNPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VPN'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'TODO:VPN Page',
            ),
          ],
        ),
      ),
    );
  }
}