import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:url_launcher/url_launcher.dart';

Map _status1 = {
  'Main': 'https://stats.uptimerobot.com/plWPBU9LQz',
  'WebSite': 'https://stats.uptimerobot.com/plWPBU9LQz/793129119',
  'Japan Osaka #1': 'https://stats.uptimerobot.com/plWPBU9LQz/793129203',
  'Japan Osaka #2': 'https://stats.uptimerobot.com/plWPBU9LQz/793129204',
  'Korea Central #1': 'https://stats.uptimerobot.com/plWPBU9LQz/793129191',
  'Long URL': 'https://stats.uptimerobot.com/plWPBU9LQz/793129221',
  'Short URL': 'https://stats.uptimerobot.com/plWPBU9LQz/793129225',
  'VPN Service Manager': 'https://stats.uptimerobot.com/plWPBU9LQz/793144839',
  'AList': 'https://stats.uptimerobot.com/plWPBU9LQz/793436931',
};

Map _status2 = {
  'Main': 'https://status.jhihyulin.live',
};

Map _status3 = {
  'Main': 'https://status-vpn.jhihyulin.live/',
};

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  void _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: SelectionArea(
            child: Text('Can\'t open in NewTab, this is the URL: $url'),
          ),
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Status'),
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
                  ListView(
                shrinkWrap: true,
                children: [
                  ExpansionTile(
                    leading: const Icon(Icons.monitor_heart),
                    title: const Text('Uptime Robot'),
                    subtitle: const Text('Update every 5 minutes'),
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.025),
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                            subtitle:
                                Wrap(spacing: 10, runSpacing: 10, children: [
                              ElevatedButton(
                                child: const Text('WebSite'),
                                onPressed: () {
                                  _launchUrl(_status1['WebSite']);
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Japan Osaka #1'),
                                onPressed: () {
                                  _launchUrl(_status1['Japan Osaka #1']);
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Japan Osaka #2'),
                                onPressed: () {
                                  _launchUrl(_status1['Japan Osaka #2']);
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Korea Central #1'),
                                onPressed: () {
                                  _launchUrl(_status1['Korea Central #1']);
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Long URL'),
                                onPressed: () {
                                  _launchUrl(_status1['Long URL']);
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Short URL'),
                                onPressed: () {
                                  _launchUrl(_status1['Short URL']);
                                },
                              ),
                              ElevatedButton(
                                child: const Text('VPN Service Manager'),
                                onPressed: () {
                                  _launchUrl(_status1['VPN Service Manager']);
                                },
                              ),
                              ElevatedButton(
                                child: const Text('AList'),
                                onPressed: () {
                                  _launchUrl(_status1['AList']);
                                },
                              ),
                            ]),
                            trailing: IconButton(
                              icon: const Icon(Icons.open_in_new),
                              onPressed: () {
                                _launchUrl(_status1['Main']);
                              },
                            ),
                          )),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.monitor_heart),
                    title: const Text('cron-job.org'),
                    subtitle: const Text('Update every minute'),
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.025),
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                            subtitle:
                                Wrap(spacing: 10, runSpacing: 10, children: [
                              ElevatedButton(
                                child: const Text('WebSite'),
                                onPressed: () {},
                              ),
                              ElevatedButton(
                                child: const Text('Long URL'),
                                onPressed: () {},
                              ),
                              ElevatedButton(
                                child: const Text('Short URL'),
                                onPressed: () {},
                              ),
                              ElevatedButton(
                                child: const Text('AList'),
                                onPressed: () {},
                              ),
                            ]),
                            trailing: IconButton(
                              icon: const Icon(Icons.open_in_new),
                              onPressed: () {
                                _launchUrl(_status2['Main']);
                              },
                            ),
                          )),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.monitor_heart),
                    title: const Text('cron-job.org'),
                    subtitle: const Text('Update every minute'),
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.025),
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                            subtitle:
                                Wrap(spacing: 10, runSpacing: 10, children: [
                              ElevatedButton(
                                child: const Text('VPN Service Manager'),
                                onPressed: () {},
                              ),
                              ElevatedButton(
                                child: const Text('Japan Osaka #1'),
                                onPressed: () {},
                              ),
                              ElevatedButton(
                                child: const Text('Japan Osaka #2'),
                                onPressed: () {},
                              ),
                              ElevatedButton(
                                child: const Text('Korea Central #1'),
                                onPressed: () {},
                              ),
                            ]),
                            trailing: IconButton(
                              icon: const Icon(Icons.open_in_new),
                              onPressed: () {
                                _launchUrl(_status3['Main']);
                              },
                            ),
                          )),
                    ],
                  ),
                ],
              ),
                ]
              )
            ),
          ),
        ));
  }
}

// https://stats.uptimerobot.com/plWPBU9LQz
// https://status.jhihyulin.live
// https://status-vpn.jhihyulin.live/
