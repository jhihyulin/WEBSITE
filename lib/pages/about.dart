import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';

import '../widget/expansion_tile.dart';
import '../widget/linear_progress_indicator.dart';
import '../widget/launch_url.dart';
import '../widget/card.dart';

Map<String, Map<String, Object>> socialMedia = {
  'GitHub': {
    'url': 'https://github.com/jhihyulin',
    'icon': FontAwesome.github,
  },
  'LinkedIn': {
    'url': 'https://linkedin.com/in/jhihyulin',
    'icon': FontAwesome.linkedin,
  },
  'GitLab': {
    'url': 'https://gitlab.com/jhihyulin',
    'icon': FontAwesome.gitlab,
  },
  'Twitter': {
    'url': 'https://twitter.com/jhih_yu_lin',
    'icon': FontAwesome.twitter,
  },
  'Facebook': {
    'url': 'https://facebook.com/jhihyu0414',
    'icon': FontAwesome.facebook,
  },
  'Instagram': {
    'url': 'https://instagram.com/jhih_yu_lin',
    'icon': FontAwesome.instagram,
  },
  'YouTube': {
    'url': 'https://youtube.com/@jhihyulin',
    'icon': FontAwesome.youtube,
  },
  'Twitch': {
    'url': 'https://twitch.tv/jhih_yu_lin',
    'icon': FontAwesome.twitch,
  },
  'Google Developer': {
    'url': 'https://g.dev/jhihyulin',
    'icon': FontAwesome.google,
  },
  'StackOverflow': {
    'url': 'https://stackoverflow.com/users/15607217/jhih-yu-lin',
    'icon': FontAwesome.stack_overflow,
  },
  'Spotify': {
    'url': 'https://open.spotify.com/user/ylde507yo3uxfvshedazdr88n',
    'icon': FontAwesome.spotify,
  },
  'Medium': {
    'url': 'https://medium.com/@jhihyulin',
    'icon': FontAwesome.medium,
  },
  'Email': {
    'url': 'mailto:jy@jhihyulin.live',
    'icon': Icons.email,
  },
  'Telegram': {
    'url': 'https://t.me/jhihyulin',
    'icon': FontAwesome.telegram,
  },
  'SoundCloud': {
    'url': 'https://soundcloud.com/jhihyulin',
    'icon': FontAwesome.soundcloud,
  },
  'Pinterest': {
    'url': 'https://pinterest.com/jhih_yu_lin',
    'icon': FontAwesome.pinterest,
  },
  'Discord': {
    'url': 'https://discord.com/users/561051528065187862',
    'icon': FontAwesome.discord,
  },
  'Tumblr': {
    'url': 'https://tumblr.com/jhihyulin',
    'icon': FontAwesome.tumblr,
  },
  'Reddit': {
    'url': 'https://reddit.com/user/Economy_Scene_3191',
    'icon': FontAwesome.reddit,
  },
  'Steam': {
    'url': 'https://steamcommunity.com/id/SageT5678',
    'icon': FontAwesome.steam,
  },
  'Snapchat': {
    'url': 'https://snapchat.com/add/jhihyul',
    'icon': FontAwesome.snapchat,
  },
  'Slack': {
    'url': 'https://jhihyulin.slack.com',
    'icon': FontAwesome.slack,
  },
};

Map<String, Object> experience = {
  'Visual Studio Code': Image.asset('assets/images/vscode.png'),
  'Python': Image.asset('assets/images/python.png'),
  'FastAPI': Image.asset('assets/images/fastapi.png'),
  'JavaScript': Image.asset('assets/images/javascript.png'),
  'Cloudflare': Image.asset('assets/images/cloudflare.png'),
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
  bool _ghLoaded = false;

  getGitHubPinnedRepo() async {
    var uri = Uri.parse('https://gh-pinned-repos.egoist.dev/?username=jhihyulin');
    http.get(uri).then((response) {
      var data = jsonDecode(response.body);
      setState(() {
        _pinnedData = data;
        _ghLoaded = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getGitHubPinnedRepo();
  }

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
              minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomCard(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(
                            maxWidth: 200,
                            minHeight: 300,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            'assets/images/salon.jpg',
                            frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) {
                                return child;
                              }
                              return AnimatedOpacity(
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(
                                  seconds: 1,
                                ),
                                curve: Curves.easeOut,
                                child: child,
                              );
                            },
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              debugPrint('Error: $exception');
                              return Text('😢\n$exception');
                            },
                          ),
                        ),
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ListTile(
                                leading: Icon(Icons.badge),
                                title: Text("Name"),
                                subtitle: Text("Jhih-Yu Lin"),
                              ),
                              CustomCard(
                                child: CustomExpansionTile(
                                  onExpansionChanged: (value) {
                                    setState(() {
                                      _isExpanded = value;
                                    });
                                  },
                                  leading: const Icon(Icons.school),
                                  title: const Text("School"),
                                  subtitle: _isExpanded ? null : const Text("Zhonghe Senior High School"),
                                  children: const [
                                    ListTile(
                                      title: Text("Zhonghe Senior High School"),
                                      subtitle: Text("2020 - 2023"),
                                    ),
                                    ListTile(
                                      title: Text("Tsz-Shiou Senior High School"),
                                      subtitle: Text("2017 - 2020"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                        label: Text(key),
                                      )
                                    : IconButton(
                                        onPressed: null,
                                        icon: Container(
                                          constraints: const BoxConstraints(
                                            maxWidth: 25,
                                            maxHeight: 25,
                                          ),
                                          child: experience[key] as Widget,
                                        ),
                                        tooltip: key,
                                      ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _ghLoaded
                    ? Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (var key in _pinnedData)
                            SizedBox(
                              width: _isDesktop(context) ? 320 : double.infinity,
                              height: 160,
                              child: CustomCard(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => CustomLaunchUrl.launch(context, key['link']),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(FontAwesome.github),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '${key['owner']}/${key['repo']}',
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.onBackground,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Offstage(
                                              offstage: key['description'] == null,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    utf8.decode(key['description'].toString().codeUnits),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.star_border),
                                                Text(' ${key['stars']}'),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Icon(Icons.fork_right),
                                                Text(' ${key['forks']}'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Offstage(
                                                  offstage: key['languageColor'] == null,
                                                  child: Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: key['languageColor'] == null ? Colors.transparent : Color(int.parse(key['languageColor'].toString().substring(1), radix: 16) + 0xFF000000),
                                                    ),
                                                  ),
                                                ),
                                                Offstage(
                                                  offstage: key['language'] == null || key['languageColor'] == null,
                                                  child: const SizedBox(
                                                    width: 5,
                                                  ),
                                                ),
                                                Offstage(
                                                  offstage: key['language'] == null,
                                                  child: Text(key['language'] ?? 'null'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.all(10),
                        child: const CustomLinearProgressIndicator(),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 700,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      for (var key in socialMedia.keys)
                        _isDesktop(context)
                            ? ElevatedButton.icon(
                                onPressed: () => CustomLaunchUrl.launch(context, socialMedia[key]!['url'] as String),
                                icon: Icon(socialMedia[key]!['icon'] as IconData),
                                label: Text(key),
                              )
                            : IconButton(
                                onPressed: () => CustomLaunchUrl.launch(context, socialMedia[key]!['url'] as String),
                                icon: Icon(socialMedia[key]!['icon'] as IconData),
                                tooltip: key,
                              ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
