import 'dart:convert';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/sign_in.dart';
import '../widget/scaffold_messenger.dart';
import '../widget/linear_progress_indicator.dart';
import '../widget/launch_url.dart';

const String serverDomainVPN = 'vpn.jhihyulin.live';
const String serverURLVPN1 = '/server_list';
const String serverURLVPN2 = '/get_key';

Uri getServerList = Uri.https(serverDomainVPN, serverURLVPN1);
Uri getToken = Uri.https(serverDomainVPN, serverURLVPN2);

var _defaultSelect = 'null';

class VPNPage extends StatefulWidget {
  const VPNPage({super.key});

  @override
  State<VPNPage> createState() => _VPNPageState();
}

class _VPNPageState extends State<VPNPage> {
  final TextEditingController _accessUrlController = TextEditingController();
  String _accessUrl = '';
  double _dataUsedPercentage = 0;
  String _useBytesLimitVisualization = '';
  String _usedBytesVisualization = '';
  List<DropdownMenuItem<String>> items = [];
  List<DropdownMenuItem<String>> _items = [
    const DropdownMenuItem(
      value: 'null',
      child: Text('Please wait...'),
    )
  ];
  String selectedServerId = _defaultSelect;
  String _selectedServerId = _defaultSelect;
  bool _getResponse = false;
  bool _loading = false;
  bool _initing = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
      _initing = true;
    });
    _getServerList();
  }

  void _resetValue() {
    setState(() {
      _accessUrl = '';
      _dataUsedPercentage = 0;
      _useBytesLimitVisualization = '';
      _usedBytesVisualization = '';
      selectedServerId = _defaultSelect;
      _selectedServerId = _defaultSelect;
      _getResponse = false;
      _loading = false;
    });
  }

  void _getServerList() async {
    await http.get(getServerList).then((value) {
      var data = jsonDecode(value.body);
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> item = DropdownMenuItem(
        value: _defaultSelect,
        child: const Text('Please select server'),
      );
      items.add(item);
      for (var i = 0; i < data['server_amount']; i++) {
        DropdownMenuItem<String> item = DropdownMenuItem(
          value: data['server_list'][i]['server_id'],
          child: Text(data['server_list'][i]['display_name']),
        );
        items.add(item);
        selectedServerId = _defaultSelect;
      }
      setState(() {
        _selectedServerId = selectedServerId;
        _items = items;
        _loading = false;
        _initing = false;
      });
    }).catchError((error) {
      setState(() {
        _getResponse = false;
        _loading = false;
        _initing = false;
      });
      CustomScaffoldMessenger.showErrorMessageSnackBar(context, error);
    });
  }

  void _getKey(String serverId) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;
    String uid = user.uid;
    String token = await user.getIdToken();
    // print(uid);
    // print(token);
    // print(serverId);
    await http.post(getToken, body: jsonEncode({'firebase_uid': uid, 'token': token, 'server_id': serverId}), headers: {'Content-Type': 'application/json'}).then((value) {
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
      CustomScaffoldMessenger.showErrorMessageSnackBar(context, error);
    });
  }

  String getOS() {
    final userAgent = html.window.navigator.userAgent.toString().toLowerCase();
    if (userAgent.contains('android') && userAgent.contains('linux')) {
      return 'android';
    } else if (userAgent.contains('iphone') || userAgent.contains('ipad')) {
      return 'ios';
    } else if (userAgent.contains('mac') && userAgent.contains('macintosh')) {
      return 'mac';
    } else if (userAgent.contains('windows')) {
      return 'windows';
    } else if (userAgent.contains('cros') && !userAgent.contains('microsoft')) {
      return 'chromeos';
    } else if (userAgent.contains('linux') && !userAgent.contains('android')) {
      return 'linux';
    } else {
      return 'unknown';
    }
  }

  void _installOutlineVPN() async {
    String os = getOS();
    if (kDebugMode) {
      print(os);
    }
    switch (os) {
      case 'android':
        CustomLaunchUrl.launch(context, 'https://play.google.com/store/apps/details?id=org.outline.android.client');
        break;
      case 'ios':
        CustomLaunchUrl.launch(context, 'https://apps.apple.com/app/outline-vpn/id1356177741');
        break;
      case 'mac':
        CustomLaunchUrl.launch(context, 'https://itunes.apple.com/app/outline-vpn-client/id1356178125');
        break;
      case 'windows':
        CustomLaunchUrl.launch(context, 'https://s3.amazonaws.com/outline-releases/client/windows/stable/Outline-Client.exe');
        break;
      case 'chromeos':
        CustomLaunchUrl.launch(context, 'https://play.google.com/store/apps/details?id=org.outline.android.client');
        break;
      case 'linux':
        CustomLaunchUrl.launch(context, 'https://s3.amazonaws.com/outline-releases/client/linux/stable/Outline-Client.AppImage');
        break;
      case 'unknown':
        CustomLaunchUrl.launch(context, 'https://getoutline.org/zh-TW/get-started/#step-3');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return SignInPage(redirectPage: '/vpn');
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('VPN'),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Offstage(
                    offstage: _initing,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'VPN Server',
                        prefixIcon: const Icon(Icons.dns),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: _items,
                          value: _selectedServerId,
                          onChanged: _loading
                              ? null
                              : (value) {
                                  if (value == _defaultSelect) {
                                    setState(() {
                                      _getResponse = false;
                                      _selectedServerId = value.toString();
                                      _resetValue();
                                    });
                                    return;
                                  } else {
                                    setState(() {
                                      _loading = true;
                                      _getResponse = false;
                                      _selectedServerId = value.toString();
                                      _getKey(value.toString());
                                    });
                                  }
                                },
                        ),
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: _initing,
                    child: const SizedBox(
                      height: 20,
                    ),
                  ),
                  Offstage(
                    offstage: !_loading && _selectedServerId == _defaultSelect,
                    child: Column(
                      children: [
                        CustomLinearProgressIndicator(
                          value: _loading ? null : _dataUsedPercentage / 100,
                        ),
                      ],
                    ),
                  ),
                  Offstage(
                    offstage: _selectedServerId == _defaultSelect || !_getResponse,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Used: $_usedBytesVisualization'),
                            Text('Limit: $_useBytesLimitVisualization'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _accessUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Access Key',
                            prefixIcon: Icon(Icons.key),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              label: const Text('Add To APP'),
                              icon: const Icon(Icons.vpn_lock),
                              onPressed: () async {
                                CustomLaunchUrl.launch(context, _accessUrl);
                              },
                            ),
                            TextButton(
                              child: const Icon(Icons.copy),
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(text: _accessUrl)).then((value) {
                                  CustomScaffoldMessenger.showMessageSnackBar(context, 'Copied to clipboard');
                                }).catchError(
                                  (error) {
                                    CustomScaffoldMessenger.showErrorMessageSnackBar(context, error.toString());
                                  },
                                );
                              },
                            ),
                            TextButton(
                              child: const Icon(Icons.help),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('How to use Outline VPN?'),
                                      content: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 700,
                                          minWidth: 700,
                                        ),
                                        child: SingleChildScrollView(
                                          physics: const BouncingScrollPhysics(),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: '1. If you don\'t have Outline APP on your device, click ',
                                                    ),
                                                    TextSpan(
                                                      style: TextStyle(
                                                        color: Theme.of(context).colorScheme.primary,
                                                      ),
                                                      text: 'Install Outline VPN APP',
                                                      recognizer: TapGestureRecognizer()
                                                        ..onTap = () {
                                                          _installOutlineVPN();
                                                        },
                                                    ),
                                                    const TextSpan(
                                                      text: ' to install it.',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Text('2. Turn back to this page and click "Add To APP"'),
                                              const Text('3. Will open Outline VPN APP, click "ADD SERVER"'),
                                              const Text('4. Access key will save in Outline APP'),
                                              const Text('5. Click "CONNECT" to connect to VPN server'),
                                              const Text('* If you are first time to use Outline APP, will need to allow Outline APP to access your device.'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
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