import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

const String VPNSERVER_DOMAIN = 'vpn.jhihyulin.live';
const String VPNSERVER_URL_1 = '/server_list';
const String VPNSERVER_URL_2 = '/get_key';

Uri VPNSERVER_GET_SERVER_LIST = Uri.https(VPNSERVER_DOMAIN, VPNSERVER_URL_1);
Uri VPNSERVER_GET_VPN_TOKEN = Uri.https(VPNSERVER_DOMAIN, VPNSERVER_URL_2);

var defaultSelect = 'null';

class VPNPage extends StatefulWidget {
  @override
  _VPNPageState createState() => _VPNPageState();
}

class _VPNPageState extends State<VPNPage> {
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
  String selectedServerId = '';
  String _selectedServerId = '';

  @override
  void initState() {
    super.initState();
    _getServerList();
  }

  void _resetValue() {
    setState(() {
      _accessUrl = '';
      _dataUsedPercentage = 0;
      _useBytesLimitVisualization = '';
      _usedBytesVisualization = '';
      _selectedServerId = '';
    });
  }

  void _getServerList() async {
    var response = await http.get(VPNSERVER_GET_SERVER_LIST);
    var data = jsonDecode(response.body);
    List<DropdownMenuItem> items = [];
    DropdownMenuItem item = new DropdownMenuItem(
      child: Text('Please select server'),
      value: defaultSelect,
    );
    items.add(item);
    for (var i = 0; i < data['server_amount']; i++) {
      DropdownMenuItem item = new DropdownMenuItem(
        child: Text(data['server_list'][i]['display_name']),
        value: data['server_list'][i]['server_id'],
      );
      items.add(item);
      selectedServerId = defaultSelect;
    }
    setState(() {
      _selectedServerId = selectedServerId;
      _items = items;
    });
  }

  void _getKey(String serverId) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User user = await _auth.currentUser!;
    String uid = user.uid;
    String token = await user.getIdToken();
    print(uid);
    print(token);
    print(serverId);
    var response = await http.post(VPNSERVER_GET_VPN_TOKEN, body: jsonEncode({
        'firebase_uid': uid,
        'server_id': serverId,
        'firebase_token': token
    }),
    headers: {
        'Content-Type': 'application/json',
    });
    var data = jsonDecode(response.body);
    setState(() {
      _accessUrl = data['access_url'] + '#' + data['display_name'];
      _dataUsedPercentage = data['data_used_percentage'];
      _useBytesLimitVisualization = data['use_bytes_limit_visualization'];
      _usedBytesVisualization = data['used_bytes_visualization'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('VPN'),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton(
                    items: _items,
                    value: defaultSelect,
                    onChanged: (value) {
                      if (value == defaultSelect) {
                        _resetValue();
                        return;
                      } else {
                        setState(() {
                          _selectedServerId = value;
                          _getKey(value);
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Data Used: $_usedBytesVisualization'),
                  SizedBox(height: 20),
                  Text('Data Limit: $_useBytesLimitVisualization'),
                  SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: _dataUsedPercentage / 100,
                    backgroundColor: Theme.of(context).splashColor,//TODO: change low purple
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    label: Text('Add To APP'),
                    icon: Icon(Icons.vpn_lock),
                    onPressed: () async {
                      final Uri VPN_url = Uri.parse(_accessUrl);
                      if (!await launchUrl(VPN_url)) {
                        throw Exception('Could not launch $_accessUrl');
                      }
                    },
                  ),
                  //TODO: When no server selected, show nothing
                ],
              )),
        )
      )
    );
  }
}


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