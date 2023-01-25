import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'TODO:Status Page',
            ),
          ],
        ),
      ),
    );
  }
}