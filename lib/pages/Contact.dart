import 'dart:convert';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

const String REPORT_MAIL = 'admin@jhihyulin.live';
const String CONTACT_DOMAIN = 'api.jhihyulin.live';
const String CONTACT_URL = '/contact';

Uri CONTACT = Uri.https(CONTACT_DOMAIN, CONTACT_URL);

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController ContactEmailController =
      new TextEditingController();
  final TextEditingController ContactMessageController =
      new TextEditingController();
  final TextEditingController ContactSignatureController =
      new TextEditingController();
  final _MessageformKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void _sendMessage() async {
    if (!_MessageformKey.currentState!.validate()) {
      return;
    }
    String Email = ContactEmailController.text;
    String Message = ContactMessageController.text;
    String Signature = ContactSignatureController.text;
    setState(() {
      _loading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String uid = user?.uid ?? '';
    final Timestamp TimeStamp = Timestamp.now();
    final appCheckToken = await FirebaseAppCheck.instance.getToken();
    FirebaseFirestore.instance.collection('message').add({
      'Email': Email,
      'Message': Message,
      'Signature': Signature,
      'uid': uid,
      'TimeStamp': TimeStamp,
    }).then((documentSnapshot) {
      var response = http.post(CONTACT,
          body: jsonEncode({
            'message': Message,
            'email': Email,
            'signature': Signature,
            'documentID': documentSnapshot.id,
          }),
          headers: {
            'X-Firebase-AppCheck': appCheckToken!,
            'Content-Type': 'application/json',
          }).then((value) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Message Sent Seccessfully.'),
          showCloseIcon: true,
          behavior: SnackBarBehavior.floating,
        ));
      }).catchError((error) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error Notifying Admin!'),
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 10),
          // action: SnackBarAction(
          //   label: 'Report',
          //   onPressed: () async {
          //     Uri _url = Uri.parse(
          //         'mailto:$REPORT_MAIL?subject=%5BWebsite%5DContact%20Error%20Report&body=%5B2%5DError%20Message%3A%20$error%0D%0AEmail%3A%20$Email%0D%0AMessage%3A%20$Message%0D%0ASignature%3A%20$Signature%0D%0ATimeStamp%3A%20$TimeStamp%0D%0AUID%3A%20$uid');
          //     if (!await launchUrl(_url)) {
          //       FailToSendReport(error, context);
          //     }
          //   },
          // )
        ));
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error Sending Message!'),
        showCloseIcon: true,
        closeIconColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 10),
        // action: SnackBarAction(
        //   label: 'Report',
        //   onPressed: () async {
        //     Uri _url = Uri.parse(
        //         'mailto:$REPORT_MAIL?subject=%5BWebsite%5DContact%20Error%20Report&body=%5B1%5DError%20Message%3A%20$error%0D%0AEmail%3A%20$Email%0D%0AMessage%3A%20$Message%0D%0ASignature%3A%20$Signature%0D%0ATimeStamp%3A%20$TimeStamp%0D%0AUID%3A%20$uid');
        //     if (!await launchUrl(_url)) {
        //       FailToSendReport(error, context);
        //     }
        //   },
        // )
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
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
                    key: _MessageformKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: ContactEmailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'example@domain.com',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)))),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: ContactMessageController,
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 10,
                          decoration: InputDecoration(
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
                            _MessageformKey.currentState!.validate(),
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: ContactSignatureController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
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
                          child: SizedBox(height: 20),
                        ),
                        Offstage(
                          offstage: !_loading,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: LinearProgressIndicator(
                              minHeight: 20,
                              backgroundColor: Theme.of(context)
                                  .splashColor, //TODO: change low purple
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: _loading,
                          child: SizedBox(height: 20),
                        ),
                        Offstage(
                          offstage: _loading,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                label: Text('Clear'),
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  ContactEmailController.clear();
                                  ContactMessageController.clear();
                                  ContactSignatureController.clear();
                                },
                              ),
                              SizedBox(width: 20),
                              ElevatedButton.icon(
                                label: Text('Send'),
                                icon: Icon(Icons.send),
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

// void FailToSendReport(error, context) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     content: Text(
//         'Fail to send report.\nPleae send Email to $REPORT_MAIL\nAlso don\'t forget to attach a screenshot and this error message:\n$error'),
//     showCloseIcon: true,
//     closeIconColor: Colors.red,
//     behavior: SnackBarBehavior.floating,
//     duration: Duration(seconds: 10),
//   ));
// }
