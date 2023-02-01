import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Set<Map<String, dynamic>> _status = {
  {
    'name': 'Uptime Robot',
    'url': 'https://stats.uptimerobot.com/plWPBU9LQz',
    'update': 'Update every 5 minutes',
    'status': {
      'Main': 'https://stats.uptimerobot.com/plWPBU9LQz',
      'WebSite': 'https://stats.uptimerobot.com/plWPBU9LQz/793129119',
      'Japan Osaka #1': 'https://stats.uptimerobot.com/plWPBU9LQz/793129203',
      'Japan Osaka #2': 'https://stats.uptimerobot.com/plWPBU9LQz/793129204',
      'Korea Central #1': 'https://stats.uptimerobot.com/plWPBU9LQz/793129191',
      'Long URL': 'https://stats.uptimerobot.com/plWPBU9LQz/793129221',
      'Short URL': 'https://stats.uptimerobot.com/plWPBU9LQz/793129225',
      'VPN Service Manager':
          'https://stats.uptimerobot.com/plWPBU9LQz/793144839',
      'AList': 'https://stats.uptimerobot.com/plWPBU9LQz/793436931',
    },
  },
  {
    'name': 'cron-job.org',
    'url': 'https://status.jhihyulin.live',
    'update': 'Update every minute',
    'status': {
      'Main': 'https://status.jhihyulin.live',
      'WebSite': null,
      'Long URL': null,
      'Short URL': null,
      'AList': null,
    },
  },
  {
    'name': 'VPN Service Manager',
    'url': 'https://status-vpn.jhihyulin.live',
    'update': 'Update every minute',
    'status': {
      'Main': 'https://status-vpn.jhihyulin.live',
      'VPN Service Manager': null,
      'Japan Osaka #1': null,
      'Japan Osaka #2': null,
      'Korea Central #1': null,
    },
  }
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
                      Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for (var status in _status)
                              ExpansionTile(
                                title: Text(status['name']),
                                subtitle: Text(status['update']),
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      child: ListTile(
                                        subtitle: Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: [
                                            for (var item
                                                in status['status'].entries)
                                              ElevatedButton(
                                                child: Text(item.key),
                                                onPressed: () => _launchUrl(
                                                    item.value.toString()),
                                              ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                            icon: const Icon(Icons.open_in_new),
                                            onPressed: () {
                                              _launchUrl(status['url']);
                                            }),
                                      ))
                                ],
                              ),
                          ],
                        ),
                      )
                    ])),
          ),
        ));
  }
}

// https://stats.uptimerobot.com/plWPBU9LQz
// https://status.jhihyulin.live
// https://status-vpn.jhihyulin.live/
