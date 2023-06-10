import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../widget/scaffold_messenger.dart';
import '../widget/linear_progress_indicator.dart';
import '../widget/card.dart';
import '../widget/text_form_field.dart';

class TWUniversityResultQueryPage extends StatefulWidget {
  const TWUniversityResultQueryPage({
    Key? key,
    this.id = '',
  }) : super(key: key);

  final String? id;

  @override
  State<TWUniversityResultQueryPage> createState() => _TWUniversityResultQueryPageState();
}

class _TWUniversityResultQueryPageState extends State<TWUniversityResultQueryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController inputIdController = TextEditingController();

  bool _loading = false;
  bool _loaded = false;

  String _name = '';
  String _id = '';
  Map<dynamic, dynamic> _stardata = {};
  Map<dynamic, dynamic> _udata = {};
  Map<dynamic, dynamic> _tudata = {};

  void shoeCopiedMessage() {
    CustomScaffoldMessenger.showMessageSnackBar(context, '已複製到剪貼簿');
  }

  void resetValue() {
    setState(() {
      _name = '';
      _stardata = {};
      _udata = {};
      _tudata = {};
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.id!.isNotEmpty) {
      setState(() {
        inputIdController.text = widget.id!;
        _id = widget.id!;
      });
      Timer(const Duration(milliseconds: 1), () {
        search();
      });
    }
  }

  Future<Map<String, dynamic>> _query(String id) async {
    String? token = await FirebaseAppCheck.instance.getToken();

    String url = 'https://api.jhihyulin.live/TWUniversityResultQuery?id=$id';
    http.Response response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'X-Firebase-AppCheck': token!,
    });

    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void search() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _id = inputIdController.text;
        _loading = true;
        _loaded = false;
      });
      var data = _query(inputIdController.text);
      data.then((value) {
        var name = value['name'] ?? '';
        var stardata = value['star'] ?? {};
        var udata = value['u'] ?? {};
        var tudata = value['tu'] ?? {};
        setState(() {
          _loading = false;
          _loaded = true;
          _name = name;
          _stardata = stardata;
          _udata = udata;
          _tudata = tudata;
        });
      }).catchError((error) {
        CustomScaffoldMessenger.showErrorMessageSnackBar(context, error.toString());
        setState(() {
          _loading = false;
          _loaded = false;
        });
        resetValue();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('大學結果查詢'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: BoxConstraints(
              maxWidth: 700,
              minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    controller: inputIdController,
                    prefixIcon: const Icon(Icons.numbers),
                    labelText: '輸入學測應試號碼',
                    hintText: '輸入學測應試號碼',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        inputIdController.clear();
                      },
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '請輸入學測應試號碼';
                      } else if (value.contains(RegExp(r'[^\d]'))) {
                        return '學測應試號碼只能為數字';
                      } else if (value.length != 8) {
                        return '學測應試號碼長度應為8';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      search();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Offstage(
                    offstage: !_loaded,
                    child: CustomCard(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Offstage(
                              offstage: _name == '',
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text(
                                  '姓名',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: utf8.decode(_name.toString().codeUnits),
                                      ),
                                    );
                                  },
                                ),
                                subtitle: Text(
                                  utf8.decode(_name.toString().codeUnits),
                                ),
                              ),
                            ),
                            Offstage(
                              offstage: _stardata.isEmpty,
                              child: ListTile(
                                leading: const Icon(Icons.star),
                                title: const Text(
                                  '繁星推薦招生錄取',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    var data = ['繁星推薦招生錄取'];
                                    data = data + [for (var key in _stardata.keys) '$key: ${utf8.decode(_stardata[key].toString().codeUnits)}'];
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: data.join('\n'),
                                      ),
                                    );
                                    shoeCopiedMessage();
                                  },
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var key in _stardata.keys)
                                      Text(
                                        '$key: ${utf8.decode(_stardata[key].toString().codeUnits)}',
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Offstage(
                              offstage: _udata.isEmpty,
                              child: ListTile(
                                leading: const Icon(Icons.school),
                                title: const Text(
                                  '大學申請入學第一階段篩選',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    var data = ['大學申請入學第一階段篩選'];
                                    data = data + [for (var key in _udata.keys) '$key: ${utf8.decode(_udata[key].toString().codeUnits)}'];
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: data.join('\n'),
                                      ),
                                    );
                                    shoeCopiedMessage();
                                  },
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var key in _udata.keys)
                                      Text(
                                        '$key: ${utf8.decode(_udata[key].toString().codeUnits)}',
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Offstage(
                              offstage: _tudata.isEmpty,
                              child: ListTile(
                                leading: const Icon(Icons.school),
                                title: const Text(
                                  '科技校院日間部四年制申請入學聯合招生第一階段篩選',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    var data = ['科技校院日間部四年制申請入學聯合招生第一階段篩選'];
                                    data = data + [for (var key in _tudata.keys) '$key: ${utf8.decode(_tudata[key].toString().codeUnits)}'];
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: data.join(
                                          '\n',
                                        ),
                                      ),
                                    );
                                    shoeCopiedMessage();
                                  },
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var key in _tudata.keys)
                                      Text(
                                        '$key: ${utf8.decode(_tudata[key].toString().codeUnits)}',
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Offstage(
                              offstage: _name != '' || _stardata.isNotEmpty || _udata.isNotEmpty || _tudata.isNotEmpty,
                              child: ListTile(
                                leading: const Icon(Icons.error),
                                trailing: IconButton(
                                  icon: const Icon(Icons.help),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          icon: const Icon(Icons.help),
                                          title: const Text('查無資料'),
                                          content: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('可能有以下幾點原因:'),
                                              Text('1. 輸入錯誤'),
                                              Text('2. 特殊選才錄取'),
                                              Text('3. 無任何校系通過第一階段篩選'),
                                              Text('4. 繁星推薦未錄取'),
                                              Text('5. 無報名科技校院日間部四年制申請入學聯合招生'),
                                              Text('6. 無報名大學申請入學'),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('確定'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                title: const Text(
                                  '查無資料',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !_loaded,
                    child: const SizedBox(
                      height: 20,
                    ),
                  ),
                  Offstage(
                    offstage: _loading,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton.icon(
                          icon: _loaded ? const Icon(Icons.refresh) : const Icon(Icons.search),
                          label: _loaded ? const Text('重新查詢') : const Text('查詢'),
                          onPressed: () {
                            search();
                          },
                        ),
                        Offstage(
                          offstage: !_loaded || _stardata.isEmpty && _udata.isEmpty && _tudata.isEmpty,
                          child: TextButton(
                            child: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: [
                                    _name == '' ? false : '姓名: ${utf8.decode(_name.toString().codeUnits)}',
                                    _stardata.isEmpty ? false : '繁星推薦:\n${[for (var key in _stardata.keys) '$key: ${utf8.decode(_stardata[key].toString().codeUnits)}'].join('\n')}',
                                    _udata.isEmpty ? false : '大學申請入學第一階段篩選:\n${[for (var key in _udata.keys) '$key: ${utf8.decode(_udata[key].toString().codeUnits)}'].join('\n')}',
                                    _tudata.isEmpty ? false : '科技校院日間部四年制申請入學聯合招生第一階段篩選:\n${[for (var key in _tudata.keys) '$key: ${utf8.decode(_tudata[key].toString().codeUnits)}'].join('\n')}',
                                  ].join('\n').replaceAll('\nfalse', '').replaceAll('false\n', ''),
                                ),
                              );
                              shoeCopiedMessage();
                            },
                          ),
                        ),
                        Offstage(
                          offstage: !_loaded,
                          child: TextButton(
                            child: const Icon(Icons.send),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: 'https://jhihyulin.live/TWUniversityResultQuery?id=$_id'),
                              );
                              shoeCopiedMessage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Offstage(
                    offstage: !_loading,
                    child: const CustomLinearProgressIndicator(),
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
