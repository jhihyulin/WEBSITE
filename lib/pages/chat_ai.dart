import 'package:flutter/material.dart';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatAIPage extends StatefulWidget {
  const ChatAIPage({Key? key}) : super(key: key);

  @override
  State<ChatAIPage> createState() => _chatDataAIPageState();
}

class _chatDataAIPageState extends State<ChatAIPage> {
  List<Map<String, String>> _chatData = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();
  late OpenAI openAI;
  String? _token;
  int _messageWidth() {
    if (MediaQuery.of(context).size.width < 700) {
      return MediaQuery.of(context).size.width.toInt() - 100;
    } else {
      return 600;
    }
  }

  bool _generating = false;

  @override
  initState() {
    openAI = OpenAI.instance.build(
        token: _token ?? 'sk-',
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
        isLog: true);
    getToken();
    super.initState();
  }

  void _launchUrl(String url) {
    Uri uri = Uri.parse(url);
    launchUrl(uri);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        content: SelectionArea(
          child: Text('Error: Failed to open in new tab, the URL is: $url',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer)),
        ),
        showCloseIcon: true,
        closeIconColor: Theme.of(context).colorScheme.onErrorContainer,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 10),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
      ),
    );
  }

  void chat(String message) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _inputController.clear();
    setState(() {
      _generating = true;
      _chatData.add({'role': 'user', 'content': message});
    });
    debugPrint('_chatData: ${_chatData.toString()}');

    final request = ChatCompleteText(
        messages: _chatData, maxToken: 400, model: ChatModel.gptTurbo);
    final raw = await openAI.onChatCompletion(request: request).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: SelectionArea(
            child: Text('Error: ${e.toString()}',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer)),
          ),
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.onErrorContainer,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 10),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
        ),
      );
      setState(() {
        _generating = false;
      });
    });
    setState(() {
      _chatData.add({
        'role': raw!.choices[0].message!.role,
        'content': raw.choices[0].message!.content
      });
      _generating = false;
    });

    debugPrint("_chatData: ${_chatData.toString()}");
  }

  void setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('openAIToken', token);
    openAI.setToken(token);
    setState(() {
      _token = token;
    });
  }

  void getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('openAIToken');
    openAI.setToken(_token ?? 'sk-');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat AI'),
        ),
        body: Column(children: [
          Expanded(
            flex: 1,
            child: Center(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    constraints: BoxConstraints(maxWidth: 700),
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // chat screen
                            for (var i in _chatData)
                              if (i['role'] == 'user')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: _messageWidth().toDouble()),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 50),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        i['content']!,
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
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: _messageWidth().toDouble()),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(
                                          bottom: 5, top: 5, right: 50),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        i['content']!,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      ),
                                    ),
                                  ],
                                ),
                            _generating
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth:
                                                _messageWidth().toDouble()),
                                        padding: const EdgeInsets.all(10),
                                        margin: const EdgeInsets.only(
                                            bottom: 5, top: 5, right: 50),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          'Generating...',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ]),
                    ))),
          ),
          // input
          Expanded(
            flex: 0,
            child: Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: 700,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 56,
                      width: 56,
                      child: IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            // setting token dialog
                            showDialog(
                                context: context,
                                builder: (context) {
                                  final TextEditingController
                                      tokenInputController =
                                      TextEditingController(text: _token);
                                  return AlertDialog(
                                    title: const Text('Chat AI Settings'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: tokenInputController,
                                          decoration: InputDecoration(
                                              labelText: 'OpenAI Token',
                                              hintText: 'Enter your token'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Where to get token?',
                                                  style: TextStyle(
                                                      fontSize:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .fontSize!),
                                                ),
                                                ElevatedButton.icon(
                                                    icon: const Icon(
                                                        Icons.open_in_new),
                                                    onPressed: () {
                                                      launchUrl(Uri.parse(
                                                          'https://platform.openai.com/account/api-keys'));
                                                    },
                                                    label: const Text(
                                                        'OpenAI Website')),
                                                SizedBox(height: 10),
                                                Text(
                                                    'Where will the token be saved?',
                                                    style: TextStyle(
                                                        fontSize:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .fontSize!)),
                                                Text(
                                                    'The token will be saved in your browser\'s cookie.'),
                                              ],
                                            ))
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () {
                                            setToken(tokenInputController.text);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Save'))
                                    ],
                                  );
                                });
                          }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (_token == null || _token!.isEmpty) {
                            return 'Please enter your token in setting';
                          }
                          if (value == null || value.isEmpty) {
                            return 'Please enter some message';
                          }
                        },
                        controller: _inputController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 4,
                        scrollPhysics: const BouncingScrollPhysics(),
                        //maxLength: 400,
                        decoration: InputDecoration(
                          labelText: 'Chat AI',
                          hintText: 'Enter your message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                chat(_inputController.text);
                              }),
                        ),
                        onChanged: (value) {
                          _formKey.currentState!.validate();
                        },
                      ),
                    ))
                  ],
                )),
          )
        ]));
  }
}
