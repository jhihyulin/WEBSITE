import 'package:flutter/material.dart';
import 'pages/About.dart';
import 'pages/Contact.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

String Text_1 =
    'Hi~\nWelcome to my website!\nI am a high school student from Taiwan.';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
            child: Container(
                padding: EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxWidth: 700,
                  minHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      58,//BottomNavigationBar Height
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 1000,
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        displayFullTextOnTap: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            Text_1,
                            textAlign: TextAlign.center,
                            speed: const Duration(milliseconds: 50),
                            textStyle: const TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(spacing: 20, children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.info),
                        label: Text('About'),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/about');
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.chat),
                        label: Text('Contact'),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/contact');
                        },
                      ),
                    ]),
                  ],
                ))));
  }
}
