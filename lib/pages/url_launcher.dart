import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncherPage extends StatefulWidget {
  const URLLauncherPage({super.key});

  @override
  State<URLLauncherPage> createState() => _URLLauncherPageState();
}

class _URLLauncherPageState extends State<URLLauncherPage> {
  final TextEditingController inputURLController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _launchURL() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String url = inputURLController.text;
    if (!await launchUrl(Uri.parse(url))) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            content: Text('Error: URL Launch Failed',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer)),
            showCloseIcon: true,
            closeIconColor: Theme.of(context).colorScheme.onErrorContainer,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
          ),
        );
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('URL Launcher'),
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
                    children: [
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a URL';
                            }
                            return null;
                          },
                          controller: inputURLController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.link),
                            labelText: 'Enter URL',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                inputURLController.clear();
                              },
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            _launchURL();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.rocket_launch),
                            label: const Text('Launch URL'),
                            onPressed: _launchURL,
                          ),
                          TextButton(
                            child: const Icon(Icons.help),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('What\'s the use?'),
                                      content: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 700,
                                          minWidth: 700,
                                        ),
                                        child: const SingleChildScrollView(
                                            physics:
                                                BouncingScrollPhysics(),
                                            child: Column(
                                              children: [
                                                Text(
                                                    'Enter a URL and click Launch URL button to open the URL in the browser or your device\'s default app for the URL.'),
                                              ],
                                            )),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                          )
                        ],
                      )
                    ],
                  ))),
        ));
  }
}
