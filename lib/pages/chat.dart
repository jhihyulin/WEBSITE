import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _inputController = TextEditingController();
  List<Map<String, String>> _chat = [
    // {
    //   'uid': 'testuid',
    //   'name': 'testname',
    //   'message': 'testmessage',
    //   'timestamp': 'testtimestamp'
    // },
    // {
    //   'uid': 'testuid2',
    //   'name': 'testname2',
    //   'message': 'testmessage2',
    //   'timestamp': 'testtimestamp2'
    // },
    {}
  ];

  @override
  void initState() {
    initChat();
    super.initState();
  }

  void initChat() {
    // var pastMessage = FirebaseDatabase.instance
    //     .ref()
    //     .child('chat')
    //     .orderByChild('timestamp')
    //     .limitToLast(10);
    // pastMessage.onChildAdded.listen((event) {
    //   debugPrint(event.snapshot.value.toString());
    //   var data = event.snapshot.value;
    //   setState(() {
    //     _chat.add({
    //       'uid': (event.snapshot.value as Map<String, dynamic>)['uid'] ?? '',
    //       'name': (event.snapshot.value as Map<String, dynamic>)['name'] ?? '',
    //       'message':
    //           (event.snapshot.value as Map<String, dynamic>)['message'] ?? '',
    //       'timestamp': (event.snapshot.value as Map<String, dynamic>)
    //           ['timestamp'],
    //       'role': (event.snapshot.value as Map<String, dynamic>)['role'] ?? '',
    //     });
    //   });
    // });
    FirebaseDatabase.instance.ref().child('chat').onChildAdded.listen((event) async {
      // debugPrint('RTDB list-0');
      // debugPrint(event.snapshot.value.toString());
      // debugPrint('RTDB list-1');
      // var data = event.snapshot.value;
      Map<String, dynamic> data = event.snapshot.value as Map<String, dynamic>;
      // setState(() {
      //   _chat.add({
      //     'uid': data['uid'] ?? '',
      //     'name': data['name'] ?? '',
      //     'message': data['message'] ?? '',
      //     'timestamp': data['timestamp'] ?? '',
      //   });
      // });
      debugPrint(data.toString());
      // debugPrint('RTDB list-2');
      // setState(() {
      //   _chat.add({
      //     'uid': (event.snapshot.value as Map<String, dynamic>)['uid'] ?? '',
      //     'name': (event.snapshot.value as Map<String, dynamic>)['name'] ?? '',
      //     'message':
      //         (event.snapshot.value as Map<String, dynamic>)['message'] ?? '',
      //     'timestamp': (event.snapshot.value as Map<String, dynamic>)
      //             ['timestamp']
      //   });
      // });
      // debugPrint('RTDB list-3');
    });
  }

  void sendChat(message) async {
    debugPrint('sendChat $message');
    debugPrint('sendChat-0');
    var user = FirebaseAuth.instance.currentUser;
    debugPrint('sendChat-1');
    var uid = user!.uid;
    debugPrint('sendChat-2');
    await FirebaseDatabase.instance.ref().child('chat').push().set({
      'uid': uid,
      'name': user.displayName,
      'message': message,
      'timestamp': ServerValue.timestamp
    });
    debugPrint('sendChat-3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
                child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 700,
                      minHeight: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        // chat screen
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _chat.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_chat[index]['name'] ?? ''),
                                subtitle: Text(_chat[index]['message'] ?? ''),
                              );
                            }),
                        // input message
                        TextField(
                          controller: _inputController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Message',
                              suffix: IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    if (!_inputController.text.isEmpty) {
                                      sendChat(_inputController.text);
                                      _inputController.clear();
                                    }
                                  })),
                        )
                      ],
                    )))));
  }
}
