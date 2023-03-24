import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../plugins/logo_icons.dart';

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
  'Google Developer': {
    'url': 'https://g.dev/jhihyulin',
    'icon': Logo.google_developers,
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
  'Pinterest': {
    'url': 'https://pinterest.com/jhih_yu_lin',
    'icon': Logo.pinterest,
  },
  'Discord': {
    'url': 'https://discord.com/users/561051528065187862',
    'icon': Logo.discord,
  },
  'Tumblr': {
    'url': 'https://tumblr.com/jhihyulin',
    'icon': Logo.tumblr,
  },
  'Reddit': {
    'url': 'https://reddit.com/user/Economy_Scene_3191',
    'icon': Logo.reddit,
  },
  'Steam': {
    'url': 'https://steamcommunity.com/id/SageT5678',
    'icon': Logo.steam,
  },
  'Snapchat': {
    'url': 'https://snapchat.com/add/jhihyul',
    'icon': Logo.snapchat,
  },
  'Slack': {
    'url': 'https://jhihyulin.slack.com',
    'icon': Logo.slack,
  },
};

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 640 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
          child: Center(
              child: Container(
        padding: const EdgeInsets.all(20),
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
            Card(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        constraints:
                            const BoxConstraints(maxWidth: 200, minHeight: 128),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/images/avatar.jpg'),
                        ),
                      ),
                      Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ListTile(
                                  leading: Icon(Icons.badge),
                                  title: Text("Name"),
                                  subtitle: Text("Jhih Yu"),
                                ),
                                Theme(
                                    data: theme,
                                    child: const ExpansionTile(
                                      leading: Icon(Icons.school),
                                      title: Text("School"),
                                      subtitle: Text(
                                          "Zhonghe Senior High School"),
                                      children: [
                                        ListTile(
                                          title: Text(
                                              "Zhonghe Senior High School"),
                                          trailing: Text("2020 - 2023"),
                                        ),
                                        ListTile(
                                          title: Text(
                                              "Tsz-Shiou Senior High School"),
                                          trailing: Text("2017 - 2020"),
                                        ),
                                      ],
                                    ))
                              ])),
                      Container(
                          padding: const EdgeInsets.all(10),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: const [
                              Chip(
                                  label: Text("Python"),
                                  avatar: Icon(Logo.python)),
                              Chip(
                                  label: Text("JavaScript"),
                                  avatar: Icon(Logo.js_square)),
                              Chip(
                                label: Text("FastAPI"),
                              ),
                              Chip(label: Text("Flutter")),
                              Chip(label: Text("C++")),
                            ],
                          ))
                    ],
                  )),
            ),
            const SizedBox(height: 20),
            Container(
                constraints: const BoxConstraints(maxWidth: 700),
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var key in SocialMedia.keys)
                      _isDesktop(context)
                          ? ElevatedButton.icon(
                              onPressed: () => _launchUrl(Uri.parse(
                                  SocialMedia[key]!['url'] as String)),
                              icon: Icon(SocialMedia[key]!['icon'] as IconData),
                              label: Text(key),
                            )
                          : IconButton(
                              onPressed: () => _launchUrl(Uri.parse(
                                  SocialMedia[key]!['url'] as String)),
                              icon: Icon(SocialMedia[key]!['icon'] as IconData),
                              tooltip: key,
                            )
                  ],
                ))
          ],
        ),
      ))),
    );
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
