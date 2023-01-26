import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

const String REPORT_MAIL = 'admin@jhihyulin.live';
const String MESSAGEACTION_DOMAIN = 'script.google.com';
const String MESSAGEACTION_URL =
    '/macros/s/AKfycbyssrqnoDBKjw2KrILRYkhuR_Wd2fYjqUVq0y_W5JvAYiBLtTtt26KWrKn__YSkE3x5SA/exec';

Uri MESSAGEACTION = Uri.https(MESSAGEACTION_DOMAIN, MESSAGEACTION_URL);

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController ContactEmailController =
        new TextEditingController();
    final TextEditingController ContactMessageController =
        new TextEditingController();
    final TextEditingController ContactSignatureController =
        new TextEditingController();
    final _MessageformKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(20),
                  constraints: BoxConstraints(maxWidth: 500),
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
                          ),
                        ),
                        TextFormField(
                          controller: ContactMessageController,
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 10,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            hintText: 'Type your message here',
                            prefixIcon: Icon(Icons.comment),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Message Is Required';
                            }
                            return null;
                          },
                          onTapOutside: (event) => {
                            _MessageformKey.currentState!.validate(),
                          }
                        ),
                        TextField(
                          controller: ContactSignatureController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Signature',
                            hintText: 'Type your signature here',
                            prefixIcon: Icon(Icons.drive_file_rename_outline),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
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
                                String Email = ContactEmailController.text;
                                String Message = ContactMessageController.text;
                                String Signature =
                                    ContactSignatureController.text;
                                if (_MessageformKey.currentState!.validate()) {
                                  SendMessage(Email, Message, Signature, context);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )))),
    );
  }
}

void SendMessage(Email, Message, Signature, context) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final String uid = user?.uid ?? '';
  final Timestamp TimeStamp = Timestamp.now();
  FirebaseFirestore.instance.collection('message').add({
    'Email': Email,
    'Message': Message,
    'Signature': Signature,
    'uid': uid,
    'TimeStamp': TimeStamp,
  }).then((value) {
    var response = http.post(MESSAGEACTION, body: {
      'message': Message,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Message Sent Seccessfully.'),
        showCloseIcon: true,
        closeIconColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error Notifying Admin!'),
          showCloseIcon: true,
          closeIconColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Report',
            onPressed: () async {
              Uri _url = Uri.parse(
                  'mailto:$REPORT_MAIL?subject=%5BWebsite%5DContact%20Error%20Report&body=%5B2%5DError%20Message%3A%20$error%0D%0AEmail%3A%20$Email%0D%0AMessage%3A%20$Message%0D%0ASignature%3A%20$Signature%0D%0ATimeStamp%3A%20$TimeStamp%0D%0AUID%3A%20$uid');
              if (!await launchUrl(_url)) {
                FailToSendReport(error, context);
              }
            },
          )));
    });
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error Sending Message!'),
        showCloseIcon: true,
        closeIconColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 10),
        action: SnackBarAction(
          label: 'Report',
          onPressed: () async {
            Uri _url = Uri.parse(
                'mailto:$REPORT_MAIL?subject=%5BWebsite%5DContact%20Error%20Report&body=%5B1%5DError%20Message%3A%20$error%0D%0AEmail%3A%20$Email%0D%0AMessage%3A%20$Message%0D%0ASignature%3A%20$Signature%0D%0ATimeStamp%3A%20$TimeStamp%0D%0AUID%3A%20$uid');
            if (!await launchUrl(_url)) {
              FailToSendReport(error, context);
            }
          },
        )));
  });
}

void FailToSendReport(error, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
        'Fail to send report.\nPleae send Email to $REPORT_MAIL\nAlso don\'t forget to attach a screenshot and this error message:\n$error'),
    showCloseIcon: true,
    closeIconColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 10),
  ));
}
