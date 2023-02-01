import 'package:flutter/material.dart';
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
  'WebSite': null,
  'Long URL': null,
  'Short URL': null,
  'AList': null,
};

Map _status3 = {
  'Main': 'https://status-vpn.jhihyulin.live',
  'VPN Service Manager': null,
  'Japan Osaka #1': null,
  'Japan Osaka #2': null,
  'Korea Central #1': null,
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
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                    subtitle: Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: [
                                          for (var i in _status1.keys)
                                            if (i != 'Main')
                                              if (_status1[i] != null)
                                                ElevatedButton(
                                                  child: Text(i),
                                                  onPressed: () {
                                                    _launchUrl(_status1[i]);
                                                  }
                                                )
                                              else
                                                ElevatedButton(
                                                  child: Text(i),
                                                  onPressed: null
                                                )
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
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                    subtitle: Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: [
                                          for (var i in _status2.keys)
                                            if (i != 'Main')
                                              if (_status2[i] != null)
                                                ElevatedButton(
                                                  child: Text(i),
                                                  onPressed: () {
                                                    _launchUrl(_status2[i]);
                                                  }
                                                )
                                              else
                                                ElevatedButton(
                                                  child: Text(i),
                                                  onPressed: null
                                                )
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
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                    subtitle: Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: [
                                          for (var i in _status3.keys)
                                            if (i != 'Main')
                                              if (_status3[i] != null)
                                                ElevatedButton(
                                                  child: Text(i),
                                                  onPressed: () {
                                                    _launchUrl(_status3[i]);
                                                  }
                                                )
                                              else
                                                ElevatedButton(
                                                  child: Text(i),
                                                  onPressed: null
                                                )
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
                    ])),
          ),
        ));
  }
}

// https://stats.uptimerobot.com/plWPBU9LQz
// https://status.jhihyulin.live
// https://status-vpn.jhihyulin.live/
