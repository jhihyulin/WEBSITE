import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_markdown/flutter_markdown.dart';

import '../widget/linear_progress_indicator.dart';
import '../widget/launch_url.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  _loadMarkdownData() async {
    var url = 'https://raw.githubusercontent.com/jhihyulin/WEBSITE/main/privacy_policy.md';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
                      CustomLaunchUrl.launch(context, href ?? '');
                    },
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    selectable: true,
                    data: snapshot.data,
                  );
                } else {
                  return const Center(
                    child: CustomLinearProgressIndicator(),
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
