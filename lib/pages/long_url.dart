import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'sign_in.dart';

const String lURLServerDomain = 'l.jhihyulin.live';
const String lURLServerURL1 = '/create';
const int _lURLSupportLimit = 8201;

Uri lURLServerCreate = Uri.https(lURLServerDomain, lURLServerURL1);

class LongURLPage extends StatefulWidget {
  const LongURLPage({Key? key}) : super(key: key);

  @override
  State<LongURLPage> createState() => _LongURLPageState();
}

class _LongURLPageState extends State<LongURLPage> {
  final TextEditingController lURLURLController = TextEditingController();
  final TextEditingController lURLlURLController = TextEditingController();
  final _lURLformKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _loaded = false;
  String _lurl = '';
  int _lURLLength = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = false;
      _loaded = false;
    });
  }

  void _createURL() async {
    setState(() {
      _loading = true;
      _loaded = false;
    });
    if (_lURLformKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _loaded = false;
      });
      FirebaseAuth auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      String uid = user.uid;
      String token = await user.getIdToken();
      await http
          .post(lURLServerCreate,
              body: jsonEncode({
                'firebase_uid': uid,
                'original_url': lURLURLController.text
              }),
              headers: {
                'Content-Type': 'application/json',
                'X-Firebase-AppCheck': token
              })
          .then((value) => {
                setState(() {
                  _lurl = jsonDecode(value.body)['url'];
                  _loading = false;
                  _loaded = true;
                  lURLlURLController.text = _lurl;
                  _lURLLength = _lurl.length;
                }),
              })
          .catchError((error) => {
                setState(() {
                  _loading = false;
                  _loaded = false;
                }),
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error: $error'),
                  showCloseIcon: true,
                  closeIconColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 10),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                )),
              });
    } else {
      setState(() {
        _loading = false;
        _loaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return SignInPage(redirectPage: '/longurl');
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text('LongURL'),
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
                  child: Form(
                      key: _lURLformKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: lURLURLController,
                              keyboardType: TextInputType.url,
                              decoration: const InputDecoration(
                                  labelText: 'URL',
                                  hintText: 'https://example.com',
                                  prefixIcon: Icon(Icons.link),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0)))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'URL is required';
                                } else if (!Uri.parse(value).isAbsolute) {
                                  return 'URL is invalid';
                                } else {
                                  return null;
                                }
                              },
                              onTapOutside: (event) => {
                                _lURLformKey.currentState!.validate(),
                              },
                              onFieldSubmitted: (event) => {
                                _createURL(),
                              },
                            ),
                            Offstage(
                                offstage: !_loading,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0)),
                                      child: LinearProgressIndicator(
                                        minHeight: 20,
                                        backgroundColor:
                                            Theme.of(context).splashColor,
                                      ),
                                    ),
                                  ],
                                )),
                            Offstage(
                                offstage: !_loaded,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      controller: lURLlURLController,
                                      minLines: 1,
                                      maxLines: 20,
                                      decoration: const InputDecoration(
                                        labelText: 'Long URL',
                                        prefixIcon: Icon(Icons.link),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16.0)),
                                        ),
                                      ),
                                      readOnly: true,
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 20),
                            Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  Offstage(
                                    offstage: _loading,
                                    child: ElevatedButton.icon(
                                      onPressed: _createURL,
                                      label: _loaded
                                          ? const Text('Recreate')
                                          : const Text('Create Long URL'),
                                      icon: _loaded
                                          ? const Icon(Icons.refresh)
                                          : const Icon(Icons.add),
                                    ),
                                  ),
                                  Offstage(
                                    offstage: !_loaded,
                                    child: ElevatedButton.icon(
                                      label: const Text('Copy'),
                                      icon: const Icon(Icons.copy),
                                      onPressed: () {
                                        Clipboard.setData(
                                                ClipboardData(text: _lurl))
                                            .then((value) => {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        'Copied to clipboard'),
                                                    showCloseIcon: true,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    16.0))),
                                                  ))
                                                })
                                            .catchError((error) => {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content:
                                                        Text('Error: $error'),
                                                    showCloseIcon: true,
                                                    closeIconColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .error,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    duration: const Duration(
                                                        seconds: 10),
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    16.0))),
                                                  ))
                                                });
                                      },
                                    ),
                                  ),
                                  Offstage(
                                      offstage: !_loaded,
                                      child: TextButton(
                                        child: const Icon(Icons.help),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Not working?'),
                                                  content: Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxWidth: 700,
                                                      minWidth: 700,
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      child: ListBody(
                                                        children: [
                                                          ExpansionTile(
                                                            leading: const Icon(
                                                                Icons.http),
                                                            title: const Text(
                                                                'HTTP 414'),
                                                            subtitle: const Text(
                                                                'Request-URI Too Large'),
                                                            children: [
                                                              Offstage(
                                                                offstage:
                                                                    _lURLLength <=
                                                                        _lURLSupportLimit,
                                                                child:
                                                                    Text.rich(
                                                                  TextSpan(
                                                                    children: [
                                                                      const TextSpan(
                                                                          text:
                                                                              'The URL you generated is '),
                                                                      TextSpan(
                                                                        text:
                                                                            '$_lURLLength',
                                                                        style:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      const TextSpan(
                                                                        text:
                                                                            ' characters long, which exceeds the upper limit of ',
                                                                      ),
                                                                      const TextSpan(
                                                                        text:
                                                                            '$_lURLSupportLimit',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      const TextSpan(
                                                                        text:
                                                                            ' characters supported by our provider.',
                                                                      ),
                                                                      const TextSpan(
                                                                          text:
                                                                              '\nYou can use '),
                                                                      TextSpan(
                                                                        style:
                                                                            TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .primary,
                                                                        ),
                                                                        text:
                                                                            'Short URL',
                                                                        recognizer:
                                                                            TapGestureRecognizer()
                                                                              ..onTap = () {
                                                                                Navigator.pushNamed(context, '/shorturl');
                                                                              },
                                                                      ),
                                                                      const TextSpan(
                                                                          text:
                                                                              ' to shorten the original URL before generating Long URL.'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Offstage(
                                                                  offstage:
                                                                      _lURLLength >
                                                                          _lURLSupportLimit,
                                                                  child: Text.rich(
                                                                      TextSpan(
                                                                          children: [
                                                                        const TextSpan(
                                                                            text:
                                                                                'This is a unknown error, please contact us at '),
                                                                        TextSpan(
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.primary,
                                                                          ),
                                                                          text:
                                                                              'admin@jhihyulin.live',
                                                                          recognizer: TapGestureRecognizer()
                                                                            ..onTap = () {
                                                                              launchUrl(Uri.parse('mailto:admin@jhihyulin.live?subject=%5BLong%20URL%5D%20Bug%20Report'));
                                                                            },
                                                                        ),
                                                                        const TextSpan(
                                                                            text:
                                                                                ' for help.'),
                                                                        const TextSpan(
                                                                            text:
                                                                                '\nDon\'t forget to include the following information:'),
                                                                        const TextSpan(
                                                                            text:
                                                                                '\n1. Original URL'),
                                                                        const TextSpan(
                                                                            text:
                                                                                '\n2. Generated Long URL'),
                                                                        const TextSpan(
                                                                            text:
                                                                                '\n3. Error ScreenShot'),
                                                                      ])))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text('OK'))
                                                  ],
                                                );
                                              });
                                        },
                                      )),
                                ]),
                          ]))),
            ),
          ));
    }
  }
}
