import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();
  final DatabaseReference _fireBaseDB = FirebaseDatabase.instance.ref();
  StreamSubscription<DatabaseEvent>? _onChatAddedSubscription;
  List<Map<String, dynamic>> _chat = [];
  int _messageWidth() {
    if (MediaQuery.of(context).size.width < 700) {
      return MediaQuery.of(context).size.width.toInt() - 100;
    } else {
      return 600;
    }
  }

  @override
  void initState() {
    initChat();
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _onChatAddedSubscription?.cancel();
    super.dispose();
  }

  void initChat() {
    _fireBaseDB.child('chat').once().then((event) {
      if (event.snapshot.value != null) {
        var chat = event.snapshot.value as Map<String, dynamic>;
        debugPrint('get chat $chat');
        for (var i in chat.values) {
          debugPrint(
              'get chat ${i['uid']} ${i['name']} ${i['message']} ${i['timestamp']}');
          addChat(
              i['uid'] as String,
              i['name'] as String,
              i['message'] as String,
              i['timestamp'] as int,
              i['photoUrl'] as String);
        }
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }, onError: (Object o) {
      final error = o as FirebaseException;
      debugPrint('Error: ${error.code} ${error.message}');
    });

    _onChatAddedSubscription =
        _fireBaseDB.child('chat').onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        var chat = event.snapshot.value as Map<String, dynamic>;
        debugPrint('listened chat $chat');
        debugPrint(
            'listened chat ${chat['uid']} ${chat['name']} ${chat['message']} ${chat['timestamp']} ${chat['photoUrl']}');
        addChat(
            chat['uid'] as String,
            chat['name'] as String,
            chat['message'] as String,
            chat['timestamp'] as int,
            chat['photoUrl'] as String);
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    }, onError: (Object o) {
      final error = o as FirebaseException;
      debugPrint('Error: ${error.code} ${error.message}');
    });
  }

  void addChat(String? uid, String? name, String? message, int? timestamp,
      String? photoUrl) {
    setState(() {
      _chat.add({
        'uid': uid ?? '',
        'name': name ?? '',
        'message': message ?? '',
        'timestamp': timestamp ?? 0,
        'photoUrl': photoUrl ?? '',
      });
      _chat.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
    });
  }

  void sendChat(message) async {
    debugPrint('sendChat $message');
    var user = FirebaseAuth.instance.currentUser;
    var uid = user!.uid;
    await _fireBaseDB.child('chat').push().set({
      'uid': uid,
      'name': user.displayName,
      'message': message,
      'timestamp': ServerValue.timestamp,
      'photoUrl': user.photoURL,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(children: [
        Expanded(
          flex: 1,
          child: Center(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  constraints: const BoxConstraints(maxWidth: 700),
                  height: double.infinity,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // chat screen
                          for (var i in _chat)
                            if (i['uid'] ==
                                FirebaseAuth.instance.currentUser!.uid)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                      right: 5,
                                    ),
                                    child: Text(
                                        DateTime.fromMillisecondsSinceEpoch(
                                                i['timestamp'])
                                            .toString()
                                            .substring(11, 16),
                                        style:
                                            TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge
                                                    ?.fontSize)),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: _messageWidth().toDouble()),
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      i['message'],
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // photo
                                    Container(
                                      margin: const EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        left: 5,
                                      ),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            NetworkImage(i['photoUrl']),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(i['name'],
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.fontSize)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: _messageWidth()
                                                        .toDouble()),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                margin: const EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10))),
                                                child: Text(
                                                  i['message'],
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 5,
                                                ),
                                                child: Text(
                                                    DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                                i['timestamp'])
                                                        .toString()
                                                        .substring(11, 16),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                        fontSize:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .labelLarge
                                                                ?.fontSize)),
                                              ),
                                            ],
                                          )
                                        ]),
                                  ])
                        ]),
                  ))),
        ),
        // input
        Expanded(
          flex: 0,
          child: Container(
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some message';
                    }
                    return null;
                  },
                  controller: _inputController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 4,
                  scrollPhysics: const BouncingScrollPhysics(),
                  //maxLength: 400,
                  decoration: InputDecoration(
                    labelText: 'Chat',
                    hintText: 'Enter your message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            sendChat(_inputController.text);
                            _inputController.clear();
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut);
                          }
                        }),
                  ),
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                ),
              )),
        )
      ]),
    );
  }
}
