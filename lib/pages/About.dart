import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'plugins/logo_icons.dart';

const String Text_1 = 'Not yet written.';
const String Text_2 = '';

Map<String, Map<String, Object>> SocialMedia = {
  'GitHub': {
    'url': 'https://github.com/jhihyulin',
    'icon': Logo.github,
  },
  'LinkedIn': {
    'url': 'https://linkedin.com/in/jhihyulin',
    'icon': Logo.linkedin,
  },
  'GitLab': {
    'url': 'https://gitlab.com/jhihyulin',
    'icon': Logo.gitlab,
  },
  'Twitter': {
    'url': 'https://twitter.com/jhih_yu_lin',
    'icon': Logo.twitter,
  },
  'Facebook': {
    'url': 'https://facebook.com/jhihyu0414',
    'icon': Logo.facebook,
  },
  'Instagram': {
    'url': 'https://instagram.com/jhih_yu_lin',
    'icon': Logo.instagram,
  },
  'YouTube': {
    'url': 'https://youtube.com/@jhihyulin',
    'icon': Logo.youtube,
  },
  'Twitch': {
    'url': 'https://twitch.tv/jhih_yu_lin',
    'icon': Logo.twitch,
  },
  'GoogleDeveloper': {
    'url': 'https://g.dev/jhihyulin',
    'icon': Logo.google,
  },
  'StackOverflow': {
    'url': 'https://stackoverflow.com/users/15607217/jhih-yu-lin',
    'icon': Logo.stack_overflow,
  },
  'Spotify': {
    'url': 'https://open.spotify.com/user/ylde507yo3uxfvshedazdr88n',
    'icon': Logo.spotify,
  },
  'Medium': {
    'url': 'https://medium.com/@jhihyulin',
    'icon': Logo.medium_brand,
  },
  'Email': {
    'url': 'mailto:jy@jhihyulin.live',
    'icon': Icons.email,
  },
  'Telegram': {
    'url': 'https://t.me/jhihyulin',
    'icon': Logo.telegram,
  },
  'SoundCloud': {
    'url': 'https://soundcloud.com/jhihyulin',
    'icon': Logo.soundcloud,
  },
};

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
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
          children: <Widget>[
            AnimatedTextKit(
              isRepeatingAnimation: false,
              displayFullTextOnTap: true,
              animatedTexts: [
                TypewriterAnimatedText(
                  Text_1,
                  textAlign: TextAlign.center,
                  speed: const Duration(milliseconds: 50),
                ),
              ],
            ),
            //Text(Text_2),
            SizedBox(height: 20),
            Container(
                constraints: BoxConstraints(maxWidth: 700),
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var key in SocialMedia.keys)
                      ElevatedButton.icon(
                        onPressed: () => _launchUrl(
                            Uri.parse(SocialMedia[key]!['url'] as String)),
                        icon: Icon(SocialMedia[key]!['icon'] as IconData),
                        label: Text(key),
                      ),
                  ],
                ))
          ],
        ),
      ))),
    );
  }
}

Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
