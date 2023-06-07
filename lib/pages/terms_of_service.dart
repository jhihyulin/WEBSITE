import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({Key? key}) : super(key: key);

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  _loadMarkdownData() async {
    var url = 'https://raw.githubusercontent.com/jhihyulin/WEBSITE/main/terms_of_service.md';
    var client = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    var response = await client.send(request);
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      return responseBody;
    } else {
      return 'Error: ${response.statusCode}';
    }
  }

  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      if (context.mounted) {
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
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms Of Service'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            padding: const EdgeInsets.all(10),
            child: FutureBuilder(
              future: _loadMarkdownData(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Markdown(
                    onTapLink: (text, href, title) {
                      _launchUrl(Uri.parse(href ?? ''));
                    },
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    selectable: true,
                    data: snapshot.data,
                  );
                } else {
                  return Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16.0),
                      ),
                      child: LinearProgressIndicator(
                        minHeight: 20,
                        backgroundColor: Theme.of(context).splashColor,
                        value: null,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
