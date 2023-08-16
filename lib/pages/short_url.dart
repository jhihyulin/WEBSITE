import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import '../pages/sign_in.dart';
import '../widget/scaffold_messenger.dart';
import '../widget/linear_progress_indicator.dart';
import '../widget/text_form_field.dart';

const String sURLServerDomain = 's.jhihyulin.live';
const String sURLServerURL1 = '/create';

Uri sURLServerCreate = Uri.https(sURLServerDomain, sURLServerURL1);

class ShortURLPage extends StatefulWidget {
  const ShortURLPage({Key? key}) : super(key: key);

  @override
  State<ShortURLPage> createState() => _ShortURLPageState();
}

class _ShortURLPageState extends State<ShortURLPage> {
  final TextEditingController sURLURLController = TextEditingController();
  final TextEditingController sURLsURLController = TextEditingController();
  final _sURLFormKey = GlobalKey<FormState>();
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
    if (_sURLFormKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _loaded = false;
      });
      FirebaseAuth auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      String uid = user.uid;
      String? token = await user.getIdToken();
      await http
          .post(
            sURLServerCreate,
            body: jsonEncode(
                {'firebase_uid': uid, 'original_url': sURLURLController.text}),
            headers: {
              'Content-Type': 'application/json',
              'X-Firebase-AppCheck': token ?? ''
            },
          )
          .then((value) => {
                setState(() {
                  _surl = jsonDecode(value.body)['url'];
                  _loading = false;
                  _loaded = true;
                  sURLsURLController.text = _surl;
                }),
              })
          .catchError((error) => {
                setState(() {
                  _loading = false;
                  _loaded = false;
                }),
                CustomScaffoldMessenger.showErrorMessageSnackBar(
                    context, error),
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
      return SignInPage(
        redirectPage: '/shorturl',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ShortURL'),
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
                key: _sURLFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomTextFormField(
                      controller: sURLURLController,
                      keyboardType: TextInputType.url,
                      labelText: 'URL',
                      hintText: 'https://example.com',
                      prefixIcon: const Icon(Icons.link),
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
                        _sURLFormKey.currentState!.validate(),
                      },
                      onFieldSubmitted: (event) => {
                        _createURL(),
                      },
                    ),
                    Offstage(
                      offstage: !_loading,
                      child: const Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          CustomLinearProgressIndicator(),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: !_loaded,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            controller: sURLsURLController,
                            labelText: 'Short URL',
                            prefixIcon: const Icon(Icons.link),
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                                ClipboardData(
                                  text: _surl,
                                ),
                              )
                                  .then(
                                    (value) => {
                                      CustomScaffoldMessenger
                                          .showMessageSnackBar(
                                              context, 'Copied to clipboard'),
                                    },
                                  )
                                  .catchError(
                                    (error) => {
                                      CustomScaffoldMessenger
                                          .showErrorMessageSnackBar(
                                              context, error),
                                    },
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
