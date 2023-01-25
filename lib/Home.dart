import 'package:flutter/material.dart';
import 'pages/About.dart';
import 'pages/Contact.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 1000,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 30.0,
              fontFamily: 'Montserrat',
              color: Colors.white,
            ),
            child: AnimatedTextKit(
              isRepeatingAnimation: false,
              displayFullTextOnTap: true,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Hi~\nWelcome to my website!\nI am a high school student from Taiwan.',
                  textAlign: TextAlign.center,
                  speed: const Duration(milliseconds: 50),
                ),
              ],
            ),
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
    ));
  }
}
