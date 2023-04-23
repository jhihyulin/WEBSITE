import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../plugins/logo_icons.dart';

Map<String, Map<String, Object>> socialMedia = {
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

Map<String, Object> experience = {
  'Visual Studio Code': Image.asset('assets/images/vscode.png'),
  'Python': Image.asset('assets/images/python.png'),
  'FastAPI': Image.asset('assets/images/fastapi.png'),
  'JavaScript': Image.asset('assets/images/javascript.png'),
  'HTML': Image.asset('assets/images/html.png'),
  'CSS': Image.asset('assets/images/css.png'),
  'Flutter': const FlutterLogo(),
  'C++': Image.asset('assets/images/cpp.png'),
  'C': Image.asset('assets/images/c.png'),
  'Arduino': Image.asset('assets/images/arduino.png'),
  'Fusion 360': Image.asset('assets/images/fusion360.png'),
  'Inventor': Image.asset('assets/images/inventor.png'),
  'AutoCAD': Image.asset('assets/images/autocad.png'),
  'Blender': Image.asset('assets/images/blender.png'),
  'Linux': Image.asset('assets/images/linux.png'),
  'Ubuntu': Image.asset('assets/images/ubuntu.png'),
  'Postman': Image.asset('assets/images/postman.png'),
  'Git': Image.asset('assets/images/git.png'),
  'Android Studio': Image.asset('assets/images/androidstudio.png'),
  'Docker': Image.asset('assets/images/docker.png'),
  'Solid Edge': Image.asset('assets/images/solidedge.png'),
};

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 640 ? true : false;
  }

  List _pinnedData = [];

  getGitHubPinnedRepo() {
    var uri =
        Uri.parse('https://gh-pinned-repos.egoist.dev/?username=jhihyulin');
    http.get(uri).then((response) {
      var data = jsonDecode(response.body);
      setState(() {
        _pinnedData = data;
      });
    });
  }

  void initState() {
    super.initState();
    getGitHubPinnedRepo();
  }

  // List getGitHubPinnedRepo = [{"owner":"jhihyulin","repo":"WEBSITE","link":"https://github.com/jhihyulin/WEBSITE","description":"My Personal Website","image":"https://opengraph.githubassets.com/1/jhihyulin/WEBSITE","website":"https://jhihyulin.live","language":"Dart","languageColor":"#00B4AB","stars":"2","forks":0},{"owner":"jhihyulin","repo":"TW-University-result-query","link":"https://github.com/jhihyulin/TW-University-result-query","description":"可用應試號碼查詢大學、科大第一階段結果或繁星推薦結果","image":"https://opengraph.githubassets.com/1/jhihyulin/TW-University-result-query","language":"Python","languageColor":"#3572A5","stars":"2","forks":0},{"owner":"jhihyulin","repo":"ShortURL","link":"https://github.com/jhihyulin/ShortURL","description":"A simple Short URL service deploy on deta.sh","image":"https://opengraph.githubassets.com/1/jhihyulin/ShortURL","language":"Python","languageColor":"#3572A5","stars":"1","forks":0},{"owner":"jhihyulin","repo":"remote_robotic_arm","link":"https://github.com/jhihyulin/remote_robotic_arm","description":"A simple remote-controlle robotic arm controlled by a joystick and servo motors.","image":"https://opengraph.githubassets.com/1/jhihyulin/remote_robotic_arm","language":"C++","languageColor":"#f34b7d","stars":"1","forks":0},{"owner":"jhihyulin","repo":"LongURL","link":"https://github.com/jhihyulin/LongURL","description":"A simple Long URL service deploy on deta.sh","image":"https://opengraph.githubassets.com/1/jhihyulin/LongURL","language":"Python","languageColor":"#3572A5","stars":0,"forks":0},{"owner":"jhihyulin","repo":"Kuai-Kuai","link":"https://github.com/jhihyulin/Kuai-Kuai","description":"數位版乖乖","image":"https://opengraph.githubassets.com/1/jhihyulin/Kuai-Kuai","stars":0,"forks":0}];

  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            content: SelectionArea(
              child: Text('Error: Failed to open in new tab, the URL is: $url',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer)),
            ),
            showCloseIcon: true,
            closeIconColor: Theme.of(context).colorScheme.onErrorContainer,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
          ),
        );
      }
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(
                                maxWidth: 200, minHeight: 128),
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
                                        child: const Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16.0))),
                                            clipBehavior: Clip.antiAlias,
                                            child: ExpansionTile(
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
                                            )))
                                  ])),
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  for (var key in experience.keys)
                                    _isDesktop(context)
                                        ? Chip(
                                            avatar: experience[key] as Widget,
                                            label: Text(key))
                                        : IconButton(
                                            onPressed: null,
                                            icon: Container(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 25, maxHeight: 25),
                                              child: experience[key] as Widget,
                                            ),
                                            tooltip: key,
                                          )
                                ],
                              ))
                        ],
                      )),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (var key in _pinnedData)
                      SizedBox(
                          width: _isDesktop(context) ? 320 : double.infinity,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () =>
                                      _launchUrl(Uri.parse(key['link'])),
                                  child: Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('${key['owner']}/${key['repo']}',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground)),
                                          const SizedBox(height: 10),
                                          Offstage(
                                            offstage:
                                                key['description'] == null,
                                            child: Column(children: [
                                              Text(
                                                utf8.decode(key['description']
                                                    .toString()
                                                    .codeUnits),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 10),
                                            ]),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.star_border),
                                                  Text(' ${key['stars']}'),
                                                  const SizedBox(width: 10),
                                                  const Icon(Icons.fork_right),
                                                  Text(' ${key['forks']}')
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Offstage(
                                                    offstage:
                                                        key['languageColor'] ==
                                                            null,
                                                    child: Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: key['languageColor'] ==
                                                                null
                                                            ? Colors.transparent
                                                            : Color(int.parse(
                                                                    key['languageColor']
                                                                        .toString()
                                                                        .substring(
                                                                            1),
                                                                    radix: 16) +
                                                                0xFF000000),
                                                      ),
                                                    ),
                                                  ),
                                                  Offstage(
                                                    offstage: key['language'] ==
                                                            null ||
                                                        key['languageColor'] ==
                                                            null,
                                                    child: const SizedBox(
                                                        width: 5),
                                                  ),
                                                  Offstage(
                                                      offstage:
                                                          key['language'] ==
                                                              null,
                                                      child: Text(
                                                          key['language'] ??
                                                              'null'))
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      )))))
                  ],
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
                        for (var key in socialMedia.keys)
                          _isDesktop(context)
                              ? ElevatedButton.icon(
                                  onPressed: () => _launchUrl(Uri.parse(
                                      socialMedia[key]!['url'] as String)),
                                  icon: Icon(
                                      socialMedia[key]!['icon'] as IconData),
                                  label: Text(key),
                                )
                              : IconButton(
                                  onPressed: () => _launchUrl(Uri.parse(
                                      socialMedia[key]!['url'] as String)),
                                  icon: Icon(
                                      socialMedia[key]!['icon'] as IconData),
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
