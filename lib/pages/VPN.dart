import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '/pages/LogInFirst.dart';

const String VPNSERVER_DOMAIN = 'vpn.jhihyulin.live';
const String VPNSERVER_URL_1 = '/server_list';
const String VPNSERVER_URL_2 = '/get_key';

Uri VPNSERVER_GET_SERVER_LIST = Uri.https(VPNSERVER_DOMAIN, VPNSERVER_URL_1);
Uri VPNSERVER_GET_VPN_TOKEN = Uri.https(VPNSERVER_DOMAIN, VPNSERVER_URL_2);

var _defaultSelect = 'null';

class VPNPage extends StatefulWidget {
  @override
  _VPNPageState createState() => _VPNPageState();
}

class _VPNPageState extends State<VPNPage> {
  final TextEditingController _accessUrlController = TextEditingController();
  String _accessUrl = '';
  double _dataUsedPercentage = 0;
  String _useBytesLimitVisualization = '';
  String _usedBytesVisualization = '';
  List<DropdownMenuItem<dynamic>> items = [];
  List<DropdownMenuItem<dynamic>> _items = [
    DropdownMenuItem(
      child: Text('Please wait...'),
      value: 'null',
    )
  ];
  String selectedServerId = _defaultSelect;
  String _selectedServerId = _defaultSelect;
  bool _getResponse = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    _getServerList();
  }

  void _resetValue() {
    setState(() {
      String _accessUrl = '';
      double _dataUsedPercentage = 0;
      String _useBytesLimitVisualization = '';
      String _usedBytesVisualization = '';
      List<DropdownMenuItem<dynamic>> items = [];
      List<DropdownMenuItem<dynamic>> _items = [
        DropdownMenuItem(
          child: Text('Please wait...'),
          value: 'null',
        )
      ];
      String selectedServerId = _defaultSelect;
      String _selectedServerId = _defaultSelect;
      bool _getResponse = false;
      bool _loading = false;
    });
  }

  void _getServerList() async {
    await http.get(VPNSERVER_GET_SERVER_LIST).then((value) {
      var data = jsonDecode(value.body);
      List<DropdownMenuItem> items = [];
      DropdownMenuItem item = new DropdownMenuItem(
        child: Text('Please select server'),
        value: _defaultSelect,
      );
      items.add(item);
      for (var i = 0; i < data['server_amount']; i++) {
        DropdownMenuItem item = new DropdownMenuItem(
          child: Text(data['server_list'][i]['display_name']),
          value: data['server_list'][i]['server_id'],
        );
        items.add(item);
        selectedServerId = _defaultSelect;
      }
      setState(() {
        _selectedServerId = selectedServerId;
        _items = items;
        _loading = false;
      });
    }).catchError((error) {
      setState(() {
        _getResponse = false;
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 10),
        ),
      );
    });
  }

  void _getKey(String serverId) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User user = await _auth.currentUser!;
    String uid = user.uid;
    String token = await user.getIdToken();
    // print(uid);
    // print(token);
    // print(serverId);
    await http.post(VPNSERVER_GET_VPN_TOKEN,
        body: jsonEncode({
          'firebase_uid': uid,
          'server_id': serverId,
          'firebase_token': token
        }),
        headers: {
          'Content-Type': 'application/json',
        }).then((value) {
      var data = jsonDecode(value.body);
      setState(() {
        _accessUrlController.text = data['access_url'] + '#' + data['display_name'];
        _accessUrl = data['access_url'] + '#' + data['display_name'];
        _dataUsedPercentage = data['data_used_percentage'];
        _useBytesLimitVisualization = data['use_bytes_limit_visualization'];
        _usedBytesVisualization = data['used_bytes_visualization'];
        _getResponse = true;
        _loading = false;
      });
    }).catchError((error) {
      setState(() {
        _getResponse = false;
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          showCloseIcon: true,
          closeIconColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 10),
        ),
      );
    });
  }

  void _installOutlineVPN() async {
    print('cc');//TODO: open install link
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return SignInFirstPage(originPage: '/vpn');
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('VPN'),
          ),
          body: Center(
              child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                constraints: BoxConstraints(maxWidth: 700),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton(
                      items: _items,
                      value: _selectedServerId,
                      onChanged: (value) {
                        if (value == _defaultSelect) {
                          setState(() {
                            _getResponse = false;
                            _selectedServerId = value;
                            _resetValue();
                          });
                          return;
                        } else {
                          setState(() {
                            _loading = true;
                            _getResponse = false;
                            _selectedServerId = value;
                            _getKey(value);
                          });
                        }
                      },
                    ),
                    Offstage(
                      offstage:
                          !_loading && _selectedServerId == _defaultSelect,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: LinearProgressIndicator(
                              minHeight: 20,
                              backgroundColor: Theme.of(context)
                                  .splashColor, //TODO: change low purple
                              value:
                                  _loading ? null : _dataUsedPercentage / 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage:
                          _selectedServerId == _defaultSelect || !_getResponse,
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Used: $_usedBytesVisualization'),
                            Text('Limit: $_useBytesLimitVisualization'),
                          ],
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _accessUrlController,
                          decoration: InputDecoration(
                            labelText: 'Access Key',
                            prefixIcon: Icon(Icons.key),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            ),
                          ),
                          readOnly: true,
                        ),
                        SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                label: Text('Add To APP'),
                                icon: Icon(Icons.vpn_lock),
                                onPressed: () async {
                                  final Uri VPN_url = Uri.parse(_accessUrl);
                                  if (!await launchUrl(VPN_url)) {
                                    throw Exception(
                                        'Could not launch $_accessUrl');
                                  }
                                },
                              ),
                              SizedBox(width: 20),
                              TextButton(
                                child: Icon(Icons.copy),
                                onPressed: () async {
                                  await Clipboard.setData(
                                          ClipboardData(text: _accessUrl))
                                      .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Copied to clipboard'),
                                        showCloseIcon: true,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: Copy failed'),
                                        showCloseIcon: true,
                                        closeIconColor: Theme.of(context).colorScheme.error,
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 10),
                                      ),
                                    );
                                  });
                                },
                              ),
                              SizedBox(width: 20),
                              TextButton(
                                child: Icon(Icons.help),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              Text('How to use Outline VPN?'),
                                          content: SingleChildScrollView(
                                              child: (Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text.rich(TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        '1. If you don\'t have Outline APP on your device, click '),
                                                TextSpan(
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                  text:
                                                      'Install Outline VPN APP',
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          _installOutlineVPN();
                                                        },
                                                ),
                                                TextSpan(
                                                    text: ' to install it.'),
                                              ])),
                                              const Text(
                                                  '2. Turn back to this page and click "Add To APP"'),
                                              const Text(
                                                  '3. Will open Outline VPN APP, click "ADD SERVER"'),
                                              const Text(
                                                  '4. Access key will save in Outline APP'),
                                              const Text(
                                                  '5. Click "CONNECT" to connect to VPN server'),
                                              const Text(
                                                  '* If you are first time to use Outline APP, will need to allow Outline APP to access your device.'),
                                            ],
                                          ))),
                                          actions: [
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                },
                              )
                            ])
                      ]),
                    )
                  ],
                )),
          )));
    }
  }
}

// TextSpan(text: '1. If you don\'t have Outline APP on your device, click "Install Outline VPN" to install it.'),
// Text('2. Turn back to this page and click "Add To APP"'),
// Text('3. Will open Outline VPN APP, click "ADD SERVER"'),
// Text('4. Access key will save in Outline APP'),
// Text('5. Click "CONNECT" to connect to VPN server'),
// Text('* If you are first time to use Outline APP, will need to allow Outline APP to access your device.'),


/*
{
    "server_amount": 3,
    "server_list": [
        {
            "display_name": "Japan Osaka #1",
            "server_id": "Japan_Osaka_1",
            "country": "Japan",
            "city": "Osaka",
            "flag": "&#127471;&#127477;"
        },
        {
            "display_name": "Japan Osaka #2",
            "server_id": "Japan_Osaka_2",
            "country": "Japan",
            "city": "Osaka",
            "flag": "&#127471;&#127477;"
        },
        {
            "display_name": "Korea Central #1",
            "server_id": "Korea_Central_1",
            "country": "Korea",
            "city": "Central",
            "flag": "&#127472;&#127479;"
        }
    ]
}
*/