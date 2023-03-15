import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncherPage extends StatefulWidget {
  const URLLauncherPage({super.key});

  @override
  _URLLauncherPageState createState() => _URLLauncherPageState();
}

class _URLLauncherPageState extends State<URLLauncherPage> {
  @override
  final TextEditingController URLInputController = new TextEditingController();

  _launchURL() async {
    String url = URLInputController.text;
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('URL is Empty'),
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 10),
        ),
      );
      return;
    }
    if (!await launchUrl(Uri.parse(url))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('URL Launch Failed'),
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 10),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('URL Launcher'),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
                  padding: EdgeInsets.all(20),
                  constraints: BoxConstraints(
                    maxWidth: 700,
                    minHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: URLInputController,
                        decoration: InputDecoration(
                          labelText: 'Enter URL',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onSubmitted: (value) {
                          _launchURL();
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.rocket_launch),
                            label: Text('Launch URL'),
                            onPressed: _launchURL,
                          ),
                          TextButton(
                            child: Icon(Icons.help),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('What\'s the use?'),
                                      content: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 700,
                                          minWidth: 700,
                                        ),
                                        child: SingleChildScrollView(
                                            child: Column(
                                          children: [
                                            Text(
                                                'Enter a URL and click Launch URL button to open the URL in the browser or your device\'s default app for the URL.'),
                                          ],
                                        )),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                          )
                        ],
                      )
                    ],
                  ))),
        ));
  }
}
