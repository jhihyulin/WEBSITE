import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

import 'sign_in.dart';

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
  Timer? _scrollTimer;
  late List<Map<String, dynamic>> _chat;
  int _messageWidth() {
    if (MediaQuery.of(context).size.width < 700) {
      return MediaQuery.of(context).size.width.toInt() * 2 ~/ 3;
    } else {
      return 500;
    }
  }

  bool _showFab = false;
  bool _handleScrollNotification(UserScrollNotification notification) {
    final ScrollDirection direction = notification.direction;
    setState(() {
      if (direction == ScrollDirection.reverse) {
        _showFab = false;
      } else if (direction == ScrollDirection.forward) {
        _showFab = true;
      }
    });
    return true;
  }

  @override
  void initState() {
    _chat = <Map<String, dynamic>>[];
    initChat();
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _onChatAddedSubscription?.cancel();
    _scrollController.dispose();
    _scrollTimer?.cancel();
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
      _scrollTimer = Timer(
          const Duration(milliseconds: 100),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut));
    });
    debugPrint('chatlength ${_chat.length}');
  }

  void sendChat(message) async {
    debugPrint('sendChat $message');
    var user = FirebaseAuth.instance.currentUser;
    var uid = user!.uid;
    await _fireBaseDB.child('chat').push().set({
      'uid': uid,
      'name': user.displayName ?? '',
      'message': message ?? '',
      'timestamp': ServerValue.timestamp,
      'photoUrl': user.photoURL ?? '',
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
                  child: Stack(children: [
                    NotificationListener<UserScrollNotification>(
                      onNotification: _handleScrollNotification,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              for (int i = 0; i < _chat.length; i++)
                                if (_chat[i]['uid'] ==
                                    (FirebaseAuth.instance.currentUser != null
                                        ? FirebaseAuth.instance.currentUser!.uid
                                        : ''))
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
                                                    int.parse(_chat[i]
                                                            ['timestamp']
                                                        .toString()))
                                                .toString()
                                                .substring(11, 16),
                                            style: TextStyle(
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
                                            maxWidth:
                                                _messageWidth().toDouble()),
                                        padding: const EdgeInsets.all(10),
                                        margin: EdgeInsets.only(
                                            top: i == 0 ||
                                                    _chat[i]['uid'] !=
                                                        _chat[i - 1]['uid']
                                                ? 5
                                                : 1,
                                            bottom: i == _chat.length - 1 ||
                                                    _chat[i]['uid'] !=
                                                        _chat[i + 1]['uid']
                                                ? 5
                                                : 1),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(i ==
                                                          0 ||
                                                      _chat[i]['uid'] !=
                                                          _chat[i - 1]['uid']
                                                  ? 10
                                                  : 0),
                                              topLeft:
                                                  const Radius.circular(10),
                                              bottomRight: Radius.circular(i ==
                                                          _chat.length - 1 ||
                                                      _chat[i]['uid'] !=
                                                          _chat[i + 1]['uid']
                                                  ? 10
                                                  : 0),
                                              bottomLeft:
                                                  const Radius.circular(10),
                                            )),
                                        child: Text(
                                          _chat[i]['message'] as String,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // photo
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 5,
                                          ),
                                          child: _chat[i]['uid'] !=
                                                      _chat[i == 0 ? i : i - 1]
                                                          ['uid'] ||
                                                  i == 0
                                              ? CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      _chat[i]['photoUrl']
                                                          as String),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                )
                                              : Container(width: 40),
                                        ),
                                        const SizedBox(width: 5),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (_chat[i]['uid'] !=
                                                      _chat[i == 0 ? i : i - 1]
                                                          ['uid'] ||
                                                  i == 0)
                                                Text(_chat[i]['name'] as String,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                        fontSize:
                                                            Theme.of(context)
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
                                                        maxWidth:
                                                            _messageWidth()
                                                                .toDouble()),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    margin: EdgeInsets.only(
                                                        top: i == 0 ||
                                                                _chat[i][
                                                                        'uid'] !=
                                                                    _chat[i - 1]
                                                                        ['uid']
                                                            ? 5
                                                            : 1,
                                                        bottom: i ==
                                                                    _chat.length -
                                                                        1 ||
                                                                _chat[i][
                                                                        'uid'] !=
                                                                    _chat[i + 1]
                                                                        ['uid']
                                                            ? 5
                                                            : 1),
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        borderRadius: BorderRadius.only(
                                                            topRight: const Radius
                                                                .circular(10),
                                                            topLeft: Radius.circular(
                                                                i == 0 || _chat[i]['uid'] != _chat[i - 1]['uid']
                                                                    ? 10
                                                                    : 0),
                                                            bottomRight:
                                                                const Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    i == _chat.length - 1 || _chat[i]['uid'] != _chat[i + 1]['uid'] ? 10 : 0))),
                                                    child: Text(
                                                      _chat[i]['message']
                                                          as String,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      top: 5,
                                                      bottom: 5,
                                                      left: 5,
                                                    ),
                                                    child: Text(
                                                        DateTime.fromMillisecondsSinceEpoch(
                                                                int.parse(_chat[
                                                                            i][
                                                                        'timestamp']
                                                                    .toString()))
                                                            .toString()
                                                            .substring(11, 16),
                                                        style: TextStyle(
                                                            color:
                                                                Theme.of(context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                            fontSize: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge
                                                                ?.fontSize)),
                                                  ),
                                                ],
                                              )
                                            ]),
                                      ])
                            ]),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: AnimatedSlide(
                            duration: const Duration(milliseconds: 300),
                            offset: _showFab ? Offset.zero : const Offset(0, 2),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _showFab ? 1 : 0,
                              child: FloatingActionButton(
                                  child: const Icon(Icons.arrow_downward),
                                  onPressed: () {
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeOut);
                                  }),
                            )))
                  ]))),
        ),
        // input
        Expanded(
          flex: 0,
          child: Container(
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Form(
                  key: _formKey,
                  child: FirebaseAuth.instance.currentUser != null
                      ? TextFormField(
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
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeOut);
                                  }
                                }),
                          ),
                          onChanged: (value) {
                            _formKey.currentState!.validate();
                          },
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.login),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignInPage(redirectPage: '/chat')),
                                  );
                                },
                                label: const Text('Sign In to chat'),
                              ),
                            ],
                          ),
                        ))),
        )
      ]),
    );
  }
}
