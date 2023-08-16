import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';

import '../widget/expansion_tile.dart';
import '../widget/linear_progress_indicator.dart';
import '../widget/launch_url.dart';
import '../widget/card.dart';
import '../widget/image.dart';
import '../widget/my_icons.dart';

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
  'X': {
    'url': 'https://x.com/jhih_yu_lin',
    'icon': MyIcons.x,
    // FontAwesome released 6.4.2, but flutter_icons_plus is still 6.3.0
    // so I download from https://fontawesome.com/icons/x-twitter
    // https://site-assets.fontawesome.com/releases/v6.4.2/svgs/brands/x-twitter.svg
    // and generate .ttf file on fluttericon.com
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
  'Visual Studio Code': const CustomImage(src: 'assets/images/vscode.png'),
  'Python': const CustomImage(src: 'assets/images/python.png'),
  'FastAPI': const CustomImage(src: 'assets/images/fastapi.png'),
  'JavaScript': const CustomImage(src: 'assets/images/javascript.png'),
  'Cloudflare': const CustomImage(src: 'assets/images/cloudflare.png'),
  'HTML': const CustomImage(src: 'assets/images/html.png'),
  'CSS': const CustomImage(src: 'assets/images/css.png'),
  'Flutter': const FlutterLogo(),
  'C++': const CustomImage(src: 'assets/images/cpp.png'),
  'C': const CustomImage(src: 'assets/images/c.png'),
  'Arduino': const CustomImage(src: 'assets/images/arduino.png'),
  'Fusion 360': const CustomImage(src: 'assets/images/fusion360.png'),
  'Inventor': const CustomImage(src: 'assets/images/inventor.png'),
  'AutoCAD': const CustomImage(src: 'assets/images/autocad.png'),
  'Blender': const CustomImage(src: 'assets/images/blender.png'),
  'Linux': const CustomImage(src: 'assets/images/linux.png'),
  'Ubuntu': const CustomImage(src: 'assets/images/ubuntu.png'),
  'Postman': const CustomImage(src: 'assets/images/postman.png'),
  'Git': const CustomImage(src: 'assets/images/git.png'),
  'Android Studio': const CustomImage(src: 'assets/images/androidstudio.png'),
  'Docker': const CustomImage(src: 'assets/images/docker.png'),
  'Solid Edge': const CustomImage(src: 'assets/images/solidedge.png'),
};

Map<String, Map<String, String>> school = {
  // 'National Dong Hwa University': {
  //   'part': 'Department of Physics',
  //   'url': 'https://www.ndhu.edu.tw',
  //   'icon': 'assets/images/ndhu.png',
  //   'start': '2023',
  // },
  'Zhonghe Senior High School': {
    'url': 'https://www.chshs.ntpc.edu.tw',
    'icon': 'assets/images/chshs.png',
    'start': '2020',
    'end': '2023',
  },
  'Tsz-Shiou Senior High School': {
    'part': 'Junior High Department',
    'url': 'https://www.tsshs.ntpc.edu.tw',
    'icon': 'assets/images/tsshs.png',
    'start': '2017',
    'end': '2020',
  },
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
    var uri =
        Uri.parse('https://gh-pinned-repos.egoist.dev/?username=jhihyulin');
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
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
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
                        InkWell(
                          borderRadius: BorderRadius.circular(16.0),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: const CustomImage(
                                      src: 'assets/images/salon.png',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(
                              maxWidth: 200,
                              minHeight: 300,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: const CustomImage(
                              src: 'assets/images/salon.png',
                            ),
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
                                  title: const Text("Education"),
                                  subtitle: _isExpanded
                                      ? null
                                      : Text(school.keys.first),
                                  children: [
                                    for (var key in school.keys)
                                      ListTile(
                                        leading: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CustomImage(
                                            src: school[key]!['icon']!,
                                          ),
                                        ),
                                        title: Text(key),
                                        subtitle: Column(
                                          children: [
                                            if (school[key]!['part'] != null)
                                              SizedBox(
                                                width: double.infinity,
                                                child:
                                                    Text(school[key]!['part']!),
                                              ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                '${school[key]!['start']} ~ ${school[key]!['end'] ?? ''}',
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          CustomLaunchUrl.launch(
                                              context, school[key]!['url']!);
                                        },
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
                              width:
                                  _isDesktop(context) ? 320 : double.infinity,
                              height: 160,
                              child: CustomCard(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => CustomLaunchUrl.launch(
                                      context, key['link']),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(FontAwesome.github),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  '${key['repo']}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Offstage(
                                              offstage:
                                                  key['description'] == null,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    utf8.decode(
                                                        key['description']
                                                            .toString()
                                                            .codeUnits),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground
                                                          .withOpacity(0.6),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                    width: 5,
                                                  ),
                                                ),
                                                Offstage(
                                                  offstage:
                                                      key['language'] == null,
                                                  child: Text(key['language'] ??
                                                      'null'),
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
                                onPressed: () => CustomLaunchUrl.launch(context,
                                    socialMedia[key]!['url'] as String),
                                icon:
                                    Icon(socialMedia[key]!['icon'] as IconData),
                                label: Text(key),
                              )
                            : IconButton(
                                onPressed: () => CustomLaunchUrl.launch(context,
                                    socialMedia[key]!['url'] as String),
                                icon:
                                    Icon(socialMedia[key]!['icon'] as IconData),
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
