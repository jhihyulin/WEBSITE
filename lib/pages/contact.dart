import 'dart:convert';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

const String contactDomain = 'api.jhihyulin.live';
const String contactURL = '/contact';

Uri contact = Uri.https(contactDomain, contactURL);

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController contactEmailController =
      TextEditingController();
  final TextEditingController contactMessageController =
      TextEditingController();
  final TextEditingController contactSignatureController =
      TextEditingController();
  final _messageFormKey = GlobalKey<FormState>();
  bool _loading = false;

  void _sendMessage() async {
    if (!_messageFormKey.currentState!.validate()) {
      return;
    }
    String email = contactEmailController.text;
    String message = contactMessageController.text;
    String signature = contactSignatureController.text;
    setState(() {
      _loading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String uid = user?.uid ?? '';
    final Timestamp timeStamp = Timestamp.now();
    final appCheckToken = await FirebaseAppCheck.instance.getToken();
    FirebaseFirestore.instance.collection('message').add({
      'Email': email,
      'Message': message,
      'Signature': signature,
      'uid': uid,
      'TimeStamp': timeStamp,
    }).then((documentSnapshot) {
      http.post(contact,
          body: jsonEncode({
            'message': message,
            'email': email,
            'signature': signature,
            'documentID': documentSnapshot.id,
          }),
          headers: {
            'X-Firebase-AppCheck': appCheckToken!,
            'Content-Type': 'application/json',
          }).then((value) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Message Sent Seccessfully.'),
          showCloseIcon: true,
          behavior: SnackBarBehavior.floating,
        ));
      }).catchError((error) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Error Notifying Admin!'),
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 10),
        ));
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Error Sending Message!'),
        showCloseIcon: true,
        closeIconColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 10),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
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
                    key: _messageFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: contactEmailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'example@domain.com',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)))),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: contactMessageController,
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 10,
                          decoration: const InputDecoration(
                              labelText: 'Message',
                              hintText: 'Type your message here',
                              prefixIcon: Icon(Icons.comment),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Message Is Required';
                            }
                            return null;
                          },
                          onTapOutside: (event) => {
                            _messageFormKey.currentState!.validate(),
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: contactSignatureController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Signature',
                              hintText: 'Type your signature here',
                              prefixIcon: Icon(Icons.draw),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)))),
                          onSubmitted: (value) => {
                            _sendMessage(),
                          },
                        ),
                        Offstage(
                          offstage: !_loading,
                          child: const SizedBox(height: 20),
                        ),
                        Offstage(
                          offstage: !_loading,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                            child: LinearProgressIndicator(
                              minHeight: 20,
                              backgroundColor: Theme.of(context)
                                  .splashColor,
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: _loading,
                          child: const SizedBox(height: 20),
                        ),
                        Offstage(
                          offstage: _loading,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                label: const Text('Clear'),
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  contactEmailController.clear();
                                  contactMessageController.clear();
                                  contactSignatureController.clear();
                                },
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                label: const Text('Send'),
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  _sendMessage();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )))),
    );
  }
}
