import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShortURLPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShortURL'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'TODO:ShortURL Page',
            ),
          ],
        ),
      ),
    );
  }
}