import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Set<Map<String, dynamic>> _status = {
  {
    'name': 'All Service',
    'provider': 'UptimeRobot',
    'url': 'https://stats.uptimerobot.com/plWPBU9LQz',
    'update': 'Update every 5 minutes',
    'leading': Icons.cloud,
    'status': {
      'Main': 'https://stats.uptimerobot.com/plWPBU9LQz',
      'WebSite': 'https://stats.uptimerobot.com/plWPBU9LQz/793129119',
      'API': 'https://stats.uptimerobot.com/plWPBU9LQz/793711415',
      'Japan Osaka #1': 'https://stats.uptimerobot.com/plWPBU9LQz/793129203',
      'Japan Osaka #3': 'https://stats.uptimerobot.com/plWPBU9LQz/794105153',
      'Long URL': 'https://stats.uptimerobot.com/plWPBU9LQz/793129221',
      'Short URL': 'https://stats.uptimerobot.com/plWPBU9LQz/793129225',
      'VPN Service Manager': 'https://stats.uptimerobot.com/plWPBU9LQz/793144839',
    },
  },
  {
    'name': 'Main Service',
    'provider': 'cron-job.org',
    'url': 'https://status.jhihyulin.live',
    'update': 'Update every minute',
    'leading': Icons.cloud,
    'status': {
      'Main': 'https://status.jhihyulin.live',
      'WebSite': null,
      'API': null,
      'Long URL': null,
      'Short URL': null,
    },
  },
  {
    'name': 'VPN Service',
    'provider': 'cron-job.org',
    'url': 'https://status-vpn.jhihyulin.live',
    'update': 'Update every minute',
    'leading': Icons.vpn_lock,
    'status': {
      'Main': 'https://status-vpn.jhihyulin.live',
      'VPN Service Manager': null,
      'Japan Osaka #1': null,
      'Japan Osaka #3': null,
    },
  }
};

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  void _launchUrl(String url) {
    Uri uri = Uri.parse(url);
    launchUrl(uri);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        content: SelectionArea(
          child: Text(
            'Error: Failed to open in new tab, the URL is: $url',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
        showCloseIcon: true,
        closeIconColor: Theme.of(context).colorScheme.onErrorContainer,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(
          seconds: 10,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      dividerColor: Colors.transparent,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
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
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      for (var status in _status)
                        Theme(
                          data: theme,
                          child: ExpansionTile(
                            title: Text(status['name']),
                            subtitle: Text(status['update']),
                            leading: Icon(status['leading']),
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: ListTile(
                                  subtitle: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      Chip(
                                        label: Text(status['provider']),
                                      ),
                                      for (var item in status['status'].entries)
                                        if (item.key != 'Main')
                                          ElevatedButton(
                                            onPressed: item.value == null
                                                ? null
                                                : () {
                                                    _launchUrl(item.value);
                                                  },
                                            child: Text(item.key),
                                          ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.open_in_new),
                                    onPressed: () {
                                      _launchUrl(status['url']);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
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
