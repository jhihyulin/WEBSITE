import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/scaffold_messenger.dart';
import '../widget/launch_url.dart';
import '../widget/text_form_field.dart';
import '../widget/text_field.dart';

class ChatAIPage extends StatefulWidget {
  const ChatAIPage({Key? key}) : super(key: key);

  @override
  State<ChatAIPage> createState() => _ChatAIPageState();
}

class _ChatAIPageState extends State<ChatAIPage> {
  late List<Map<String, String>> _chatData;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();
  late OpenAI openAI;
  String? _token;
  double _temperature = 0.5;
  double _temporaryTemperature = 0.5;
  int _messageWidth() {
    if (MediaQuery.of(context).size.width < 700) {
      return MediaQuery.of(context).size.width.toInt() - 100;
    } else {
      return 600;
    }
  }

  List<String> _models = [
    'gpt-3.5-turbo',
    'gpt-3.5-turbo-0301',
    'text-davinci-003',
    'text-davinci-002',
    'code-davinci-002',
    'gpt-4',
    'gpt-4-0314',
    'gpt-4-32k',
    'gpt-4-32k-0314',
  ];
  String _model = 'gpt-3.5-turbo';
  String _temporaryModel = 'gpt-3.5-turbo';
  int modelIndex = 0;

  String? _systemMessage;
  bool _generating = false;
  String? _generatingMessage;
  Timer? _timer;

  @override
  initState() {
    _chatData = <Map<String, String>>[];
    openAI = OpenAI.instance.build(token: 'sk-', baseOption: HttpSetup(receiveTimeout: const Duration(minutes: 1)), enableLog: kDebugMode);
    getToken();
    getSystemMessage();
    getTemperature();
    getModel();
    initGeneralAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void initGeneralAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if ((_generatingMessage ?? '').length < 3) {
        setState(() {
          _generatingMessage = '${_generatingMessage ?? ''}．';
        });
      } else {
        setState(() {
          _generatingMessage = '．';
        });
      }
    });
  }

  void chat(String message) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _inputController.clear();
    setState(() {
      _generating = true;
      _chatData.add({'role': 'user', 'content': message});
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    debugPrint('_chatData: ${_chatData.toString()}');
    final request = ChatCompleteText(
      messages: _chatData,
      maxToken: 400,
      model: ChatModelFromValue(model: _model),
      temperature: _temperature,
    );
    final raw = await openAI.onChatCompletion(request: request).catchError((e) {
      CustomScaffoldMessenger.showMessageSnackBar(context, 'Error: ${e.toString()}');
      setState(() {
        _generating = false;
      });
      return null;
    });
    setState(() {
      _chatData.add({'role': raw!.choices[0].message!.role, 'content': raw.choices[0].message!.content});
      _generating = false;
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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
    String? token = prefs.getString('openAIToken');
    if (token != null) {
      openAI.setToken(token);
      setState(() {
        _token = token;
      });
    }
  }

  setSystemMessage(String message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('systemMessage', message);
    setState(() {
      _systemMessage = message;
      _chatData.clear();
      _chatData.add({'role': 'system', 'content': _systemMessage!});
      _chatData.removeWhere((element) => element['content'] == '');
    });
  }

  getSystemMessage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? systemMessage = prefs.getString('systemMessage');
    setState(() {
      if (systemMessage != null) {
        _systemMessage = systemMessage;
        _chatData.clear();
        _chatData.add({'role': 'system', 'content': _systemMessage!});
      }
    });
  }

  setTemperature(double temperature) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('temperature', temperature);
    setState(() {
      _temperature = temperature;
      _temporaryTemperature = temperature;
    });
  }

  getTemperature() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double? temperature = prefs.getDouble('temperature');
    setState(() {
      if (temperature != null) {
        _temperature = temperature;
        _temporaryTemperature = temperature;
      }
    });
  }

  setModel(String model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('model', model);
    setState(() {
      _model = model;
      _temporaryModel = model;
    });
  }

  getModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? model = prefs.getString('model');
    setState(() {
      if (model != null) {
        _model = model;
        _temporaryModel = model;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat AI'),
        actions: [
          Offstage(
            offstage: _chatData.isEmpty,
            child: IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear',
              onPressed: () {
                setState(() {
                  //openAI.cancelAIGenerate();
                  _chatData.clear();
                  //_generating = false;
                  //_chatData.add({'role': 'system', 'content': _systemMessage!});
                });
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                constraints: const BoxConstraints(
                  maxWidth: 700,
                ),
                height: double.infinity,
                child: SingleChildScrollView(
                  controller: _scrollController,
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
                                  maxWidth: _messageWidth().toDouble(),
                                ),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  i['content']!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (i['role'] == 'assistant')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: _messageWidth().toDouble(),
                                ),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(
                                  bottom: 5,
                                  top: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SelectionArea(
                                  child: Text(
                                    i['content']!,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: i['content']!,
                                    ),
                                  );
                                  CustomScaffoldMessenger.showMessageSnackBar(context, '已複製到剪貼簿');
                                },
                              ),
                            ],
                          )
                        else if (i['role'] == 'system')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: _messageWidth().toDouble(),
                                ),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(
                                  bottom: 5,
                                  top: 5,
                                ),
                                child: SelectionArea(
                                  child: SelectionArea(
                                    child: Text(
                                      i['content']!,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onBackground,
                                      ),
                                    ),
                                  ),
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
                                    maxWidth: _messageWidth().toDouble(),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(
                                    bottom: 5,
                                    top: 5,
                                    right: 50,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    _generatingMessage ?? '',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // input
          Expanded(
            flex: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 56,
                    width: 56,
                    child: IconButton(
                      icon: const Icon(Icons.settings),
                      tooltip: 'Chat AI Settings',
                      onPressed: () {
                        // setting token dialog
                        showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController tokenInputController = TextEditingController(text: _token);
                            final TextEditingController systemMessageController = TextEditingController(text: _systemMessage);
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text('Chat AI Settings'),
                                  content: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomTextField(
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 3,
                                          controller: systemMessageController,
                                          labelText: 'System Message',
                                          hintText: 'Enter some environment settings',
                                          prefixIcon: const Icon(Icons.description),
                                          suffixIcon: IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                systemMessageController.clear();
                                              }),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CustomTextField(
                                          keyboardType: TextInputType.text,
                                          controller: tokenInputController,
                                          labelText: 'OpenAI Token',
                                          hintText: 'Enter your token',
                                          prefixIcon: const Icon(Icons.key),
                                          suffixIcon: IconButton(
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              tokenInputController.clear();
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: 'Temperature',
                                            prefixIcon: const Icon(Icons.thermostat),
                                            labelStyle: TextStyle(
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                          ),
                                          child: Slider(
                                            value: _temporaryTemperature,
                                            min: 0,
                                            max: 1,
                                            divisions: 100,
                                            label: _temporaryTemperature.toStringAsFixed(2),
                                            onChanged: (value) {
                                              setState(() {
                                                _temporaryTemperature = value;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: 'Model',
                                            prefixIcon: const Icon(Icons.model_training),
                                            labelStyle: TextStyle(
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _temporaryModel,
                                              items: _models.map((e) {
                                                return DropdownMenuItem<String>(
                                                  value: e,
                                                  child: Text(e),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _temporaryModel = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Where to get token?',
                                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize!),
                                              ),
                                              ElevatedButton.icon(
                                                icon: const Icon(Icons.open_in_new),
                                                onPressed: () {
                                                  CustomLaunchUrl.launch(context, 'https://platform.openai.com/account/api-keys');
                                                },
                                                label: const Text('OpenAI Website'),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Where will the token be saved?',
                                                style: TextStyle(
                                                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize!,
                                                ),
                                              ),
                                              const Text('The token will be saved in your browser\'s cookie.'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (_token != tokenInputController.text) {
                                          setToken(tokenInputController.text);
                                        }
                                        if (_systemMessage != systemMessageController.text) {
                                          setSystemMessage(systemMessageController.text);
                                        }
                                        if (_temporaryTemperature != _temperature) {
                                          setTemperature(_temporaryTemperature);
                                        }
                                        if (_temporaryModel != _model) {
                                          setModel(_temporaryModel);
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Save'),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: CustomTextFormField(
                        validator: (value) {
                          if (_token == null || _token!.isEmpty) {
                            return 'Please enter your token in setting';
                          }
                          if (value == null || value.isEmpty) {
                            return 'Please enter some message';
                          }
                          return null;
                        },
                        controller: _inputController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 4,
                        labelText: 'Chat AI',
                        hintText: 'Enter your message',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            chat(_inputController.text);
                          },
                        ),
                        onChanged: (value) {
                          _formKey.currentState!.validate();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
