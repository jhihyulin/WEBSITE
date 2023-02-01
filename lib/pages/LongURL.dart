import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'LogInFirst.dart';

const String LURLSERVER_DOMAIN = 'l.jhihyulin.live';
const String LURLSERVER_URL_1 = '/create';
const int _LURLSupportLimit = 8201;

Uri LURLSERVER_CREATE = Uri.https(LURLSERVER_DOMAIN, LURLSERVER_URL_1);

class LongURLPage extends StatefulWidget {
  LongURLPage({Key? key}) : super(key: key);

  @override
  _LongURLPageState createState() => _LongURLPageState();
}

class _LongURLPageState extends State<LongURLPage> {
  final TextEditingController LURLURLController = new TextEditingController();
  final TextEditingController LURLlURLController = new TextEditingController();
  final _LURLformKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _loaded = false;
  String _lurl = '';
  int _LURLLength = 0;

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
    if (_LURLformKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _loaded = false;
      });
      FirebaseAuth _auth = FirebaseAuth.instance;
      User user = await _auth.currentUser!;
      String uid = user.uid;
      String token = await user.getIdToken();
      await http
          .post(LURLSERVER_CREATE,
              body: jsonEncode({
                'firebase_uid': uid,
                'original_url': LURLURLController.text
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
                  LURLlURLController.text = _lurl;
                  _LURLLength = _lurl.length;
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
                  duration: Duration(seconds: 10),
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
      return SignInFirstPage(originPage: '/longurl');
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('LongURL'),
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
                  child: Form(
                      key: _LURLformKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: LURLURLController,
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
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
                                _LURLformKey.currentState!.validate(),
                              },
                              onFieldSubmitted: (event) => {
                                _createURL(),
                              },
                            ),
                            Offstage(
                                offstage: !_loading,
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: LinearProgressIndicator(
                                        minHeight: 20,
                                        backgroundColor: Theme.of(context)
                                            .splashColor, //TODO: change low purple
                                      ),
                                    ),
                                  ],
                                )),
                            Offstage(
                                offstage: !_loaded,
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: LURLlURLController,
                                      minLines: 1,
                                      maxLines: 20,
                                      decoration: InputDecoration(
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
                            SizedBox(height: 20),
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
                                          ? Text('Recreate')
                                          : Text('Create Long URL'),
                                      icon: _loaded
                                          ? Icon(Icons.refresh)
                                          : Icon(Icons.add),
                                    ),
                                  ),
                                  Offstage(
                                    offstage: !_loaded,
                                    child: ElevatedButton.icon(
                                      label: Text('Copy'),
                                      icon: Icon(Icons.copy),
                                      onPressed: () {
                                        Clipboard.setData(
                                                ClipboardData(text: _lurl))
                                            .then((value) => {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Copied to clipboard'),
                                                    showCloseIcon: true,
                                                    behavior: SnackBarBehavior
                                                        .floating,
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
                                                    duration:
                                                        Duration(seconds: 10),
                                                  ))
                                                });
                                      },
                                    ),
                                  ),
                                  Offstage(
                                      offstage: !_loaded,
                                      child: TextButton(
                                        child: Icon(Icons.help),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Not working?'),
                                                  content: Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth: 700,
                                                      minWidth: 700,
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: [
                                                          ExpansionTile(
                                                            leading: Icon(
                                                                Icons.http),
                                                            title: Text(
                                                                'HTTP 414'),
                                                            subtitle: Text(
                                                                'Request-URI Too Large'),
                                                            children: [
                                                              Offstage(
                                                                offstage:
                                                                    _LURLLength <= _LURLSupportLimit,
                                                                child:
                                                                    Text.rich(
                                                                  TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text:
                                                                              'The URL you generated is '),
                                                                      TextSpan(
                                                                        text:
                                                                            '$_LURLLength',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' characters long, which exceeds the upper limit of ',
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            '$_LURLSupportLimit',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            ' characters supported by our provider.',
                                                                      ),
                                                                      TextSpan(
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
                                                                      TextSpan(
                                                                          text:
                                                                              ' to shorten the original URL before generating Long URL.'),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Offstage(
                                                                offstage: _LURLLength > _LURLSupportLimit,
                                                                child: Text.rich(
                                                                  TextSpan(
                                                                    children: [
                                                                      TextSpan(text: 'This is a unknown error, please contact us at '),
                                                                      TextSpan(
                                                                        style: TextStyle(
                                                                          color: Theme.of(context).colorScheme.primary,
                                                                        ),
                                                                        text: 'admin@jhihyulin.live',
                                                                        recognizer: TapGestureRecognizer()
                                                                          ..onTap = () {
                                                                            launchUrl(Uri.parse('mailto:admin@jhihyulin.live?subject=%5BLong%20URL%5D%20Bug%20Report'));
                                                                          },
                                                                      ),
                                                                      TextSpan(text: ' for help.'),
                                                                      TextSpan(text: '\nDon\'t forget to include the following information:'),
                                                                      TextSpan(text: '\n1. Original URL'),
                                                                      TextSpan(text: '\n2. Generated Long URL'),
                                                                      TextSpan(text: '\n3. Error ScreenShot'),
                                                                    ]
                                                                  )
                                                                )
                                                              )
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
                                                        child: Text('OK'))
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
