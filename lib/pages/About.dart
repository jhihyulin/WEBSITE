import 'package:flutter/material.dart';
import 'plugins/logo_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

const String Text_1 = 'Not yet written.';
const String Text_2 = '';

final Uri GitHub_url = Uri.parse('https://github.com/jhihyulin');
final Uri LinkedIn_url = Uri.parse('https://linkedin.com/in/jhihyulin');
final Uri GitLab_url = Uri.parse('https://gitlab.com/jhihyulin');
final Uri Twitter_url = Uri.parse('https://twitter.com/jhih_yu_lin');
final Uri Facebook_url = Uri.parse('https://facebook.com/jhihyu0414');
final Uri Instagram_url = Uri.parse('https://instagram.com/jhih_yu_lin');
final Uri YouTube_url = Uri.parse('https://youtube.com/@jhihyulin');
final Uri Twitch_url = Uri.parse('https://twitch.tv/jhih_yu_lin');
final Uri GoogleDeveloper_url = Uri.parse('https://g.dev/jhihyulin');
final Uri StackOverflow_url =
    Uri.parse('https://stackoverflow.com/users/15607217/jhih-yu-lin');
final Uri Spotify_url =
    Uri.parse('https://open.spotify.com/user/ylde507yo3uxfvshedazdr88n');
final Uri Medium_url = Uri.parse('https://medium.com/@jhihyulin');
final Uri Email_url = Uri.parse('mailto:jy@jhihyulin.live');
final Uri Telegram_url = Uri.parse('https://t.me/jhihyulin');
final Uri SoundCloud_url = Uri.parse('https://soundcloud.com/jhihyulin');

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                  constraints: BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                          icon: const Icon(Logo.github),
                          label: Text('GitHub'),
                          onPressed: () => _launchUrl(GitHub_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.gitlab),
                          label: Text('GitLab'),
                          onPressed: () => _launchUrl(GitLab_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.linkedin),
                          label: Text('LinkedIn'),
                          onPressed: () => _launchUrl(LinkedIn_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.twitter),
                          label: Text('Twitter'),
                          onPressed: () => _launchUrl(Twitter_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.facebook),
                          label: Text('Facebook'),
                          onPressed: () => _launchUrl(Facebook_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.instagram),
                          label: Text('Instagram'),
                          onPressed: () => _launchUrl(Instagram_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.youtube),
                          label: Text('YouTube'),
                          onPressed: () => _launchUrl(YouTube_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.twitch),
                          label: Text('Twitch'),
                          onPressed: () => _launchUrl(Twitch_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.google_developers),
                          label: Text('Google Developer'),
                          onPressed: () => _launchUrl(GoogleDeveloper_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.stack_overflow),
                          label: Text('Stack Overflow'),
                          onPressed: () => _launchUrl(StackOverflow_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.spotify),
                          label: Text('Spotify'),
                          onPressed: () => _launchUrl(Spotify_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.medium_brand),
                          label: Text('Medium'),
                          onPressed: () => _launchUrl(Medium_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Icons.email),
                          label: Text('Email'),
                          onPressed: () => _launchUrl(Email_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.telegram),
                          label: Text('Telegram'),
                          onPressed: () => _launchUrl(Telegram_url)),
                      ElevatedButton.icon(
                          icon: const Icon(Logo.soundcloud),
                          label: Text('SoundCloud'),
                          onPressed: () => _launchUrl(SoundCloud_url)),
                    ],
                  ))
            ],
          ),
        )
      ),
    );
  }
}

Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
