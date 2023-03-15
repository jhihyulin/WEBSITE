import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'sign_in.dart';

const String SURLSERVER_DOMAIN = 's.jhihyulin.live';
const String SURLSERVER_URL_1 = '/create';

Uri SURLSERVER_CREATE = Uri.https(SURLSERVER_DOMAIN, SURLSERVER_URL_1);

class ShortURLPage extends StatefulWidget {
  const ShortURLPage({Key? key}) : super(key: key);

  @override
  _ShortURLPageState createState() => _ShortURLPageState();
}

class _ShortURLPageState extends State<ShortURLPage> {
  final TextEditingController SURLURLController = new TextEditingController();
  final TextEditingController SURLsURLController = new TextEditingController();
  final _SURLformKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _loaded = false;
  String _surl = '';

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
    if (_SURLformKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _loaded = false;
      });
      FirebaseAuth _auth = FirebaseAuth.instance;
      User user = await _auth.currentUser!;
      String uid = user.uid;
      String token = await user.getIdToken();
      await http
          .post(SURLSERVER_CREATE,
              body: jsonEncode({
                'firebase_uid': uid,
                'original_url': SURLURLController.text
              }),
              headers: {
                'Content-Type': 'application/json',
                'X-Firebase-AppCheck': token
              })
          .then((value) => {
                setState(() {
                  _surl = jsonDecode(value.body)['url'];
                  _loading = false;
                  _loaded = true;
                  SURLsURLController.text = _surl;
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
      return SignInPage(redirectPage: '/shorturl');
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ShortURL'),
        ),
        body: SingleChildScrollView(
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
                  key: _SURLformKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          controller: SURLURLController,
                          keyboardType: TextInputType.url,
                          decoration: const InputDecoration(
                              labelText: 'URL',
                              hintText: 'https://example.com',
                              prefixIcon: Icon(Icons.link),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)))),
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
                            _SURLformKey.currentState!.validate(),
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
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(16.0)),
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
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: SURLsURLController,
                                  decoration: const InputDecoration(
                                    labelText: 'Short URL',
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
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              Offstage(
                                offstage: _loading,
                                child: ElevatedButton.icon(
                                  onPressed: _createURL,
                                  label: _loaded
                                      ? const Text('Recreate')
                                      : const Text('Create Short URL'),
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
                                            ClipboardData(text: _surl))
                                        .then((value) => {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content:
                                                    Text('Copied to clipboard'),
                                                showCloseIcon: true,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ))
                                            })
                                        .catchError((error) => {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text('Error: $error'),
                                                showCloseIcon: true,
                                                closeIconColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                duration: const Duration(seconds: 10),
                                              ))
                                            });
                                  },
                                ),
                              )
                            ]),
                      ]))),
        )),
      );
    }
  }
}
