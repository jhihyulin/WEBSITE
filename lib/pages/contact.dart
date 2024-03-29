import 'dart:convert';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../widget/scaffold_messenger.dart';
import '../widget/linear_progress_indicator.dart';
import '../widget/text_form_field.dart';
import '../widget/text_field.dart';

const String reportEmail = 'admin@jhihyulin.live';
const String contactDomain = 'api.jhihyulin.live';
const String contactURL = '/contact';

Uri conatctDomainURL = Uri.https(contactDomain, contactURL);

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactMessageController =
      TextEditingController();
  final TextEditingController contactSignatureController =
      TextEditingController();
  final _messageformKey = GlobalKey<FormState>();
  bool _loading = false;

  void _sendMessage() async {
    if (!_messageformKey.currentState!.validate()) {
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
      http.post(conatctDomainURL,
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
        CustomScaffoldMessenger.showMessageSnackBar(
            context, 'Message Sent Seccessfully.');
      }).catchError((error) {
        setState(() {
          _loading = false;
        });
        CustomScaffoldMessenger.showErrorMessageSnackBar(
            context, error.toString());
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      CustomScaffoldMessenger.showErrorMessageSnackBar(
          context, error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
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
              key: _messageformKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomTextField(
                    controller: contactEmailController,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Email',
                    hintText: 'example@domain.com',
                    prefixIcon: const Icon(Icons.email),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: contactSignatureController,
                    keyboardType: TextInputType.text,
                    labelText: 'Signature',
                    hintText: 'Type your signature here',
                    prefixIcon: const Icon(Icons.draw),
                    onSubmitted: (value) => {
                      _sendMessage(),
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    controller: contactMessageController,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 10,
                    labelText: 'Message',
                    hintText: 'Type your message here',
                    prefixIcon: const Icon(Icons.comment),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Message Is Required';
                      }
                      return null;
                    },
                    onTapOutside: (event) => {
                      _messageformKey.currentState!.validate(),
                    },
                  ),
                  Offstage(
                    offstage: !_loading,
                    child: const SizedBox(
                      height: 20,
                    ),
                  ),
                  Offstage(
                    offstage: !_loading,
                    child: const CustomLinearProgressIndicator(),
                  ),
                  Offstage(
                    offstage: _loading,
                    child: const SizedBox(
                      height: 20,
                    ),
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
                        const SizedBox(
                          width: 20,
                        ),
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
            ),
          ),
        ),
      ),
    );
  }
}
