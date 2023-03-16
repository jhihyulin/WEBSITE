import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  int _hour = 0;
  int _minute = 0;
  int _second = 0;
  bool _blink = false;
  bool _fullscreen = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      DateTime now = DateTime.now();
      setState(() {
        _blink = !_blink;
        _hour = now.hour;
        _minute = now.minute;
        _second = now.second;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    document.exitFullscreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _fullscreen
          ? null
          : AppBar(
              title: const Text('Clock'),
            ),
      body: _fullscreen
          ? Clock(
              hour: _hour,
              minute: _minute,
              second: _second,
              blink: _blink,
              fullscreen: _fullscreen,
            )
          : SingleChildScrollView(
              child: Center(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  constraints: BoxConstraints(
                    maxWidth:
                        _fullscreen ? MediaQuery.of(context).size.width : 700,
                    minHeight: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Clock(
                          hour: _hour,
                          minute: _minute,
                          second: _second,
                          blink: _blink,
                          fullscreen: _fullscreen,
                        ),
                      ])),
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          document.fullscreenElement == null
              ? document.documentElement!.requestFullscreen()
              : document.exitFullscreen();
          document.fullscreenElement == null
              ? setState(() {
                  _fullscreen = true;
                })
              : setState(() {
                  _fullscreen = false;
                });
        },
        child: Icon(_fullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
      ),
    );
  }
}

class Clock extends StatelessWidget {
  final int hour;
  final int minute;
  final int second;
  final bool blink;
  final bool fullscreen;

  const Clock({
    Key? key,
    required this.hour,
    required this.minute,
    required this.second,
    required this.blink,
    required this.fullscreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: fullscreen ? 200 : 100,
                maxHeight: fullscreen ? 200 : 100,
              ),
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(fullscreen ? 40 : 20),
                  child: Text(
                    hour.toString(),
                    style: TextStyle(fontSize: fullscreen ? 60 : 30),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: blink ? 1 : 0,
              child: Text(
                ':',
                style: TextStyle(fontSize: fullscreen ? 60 : 30),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: fullscreen ? 200 : 100,
                maxHeight: fullscreen ? 200 : 100,
              ),
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(fullscreen ? 40 : 20),
                  child: Text(
                    minute.toString(),
                    style: TextStyle(fontSize: fullscreen ? 60 : 30),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: blink ? 1 : 0,
              child: Text(
                ':',
                style: TextStyle(fontSize: fullscreen ? 60 : 30),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: fullscreen ? 200 : 100,
                maxHeight: fullscreen ? 200 : 100,
              ),
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(fullscreen ? 40 : 20),
                  child: Text(
                    second.toString(),
                    style: TextStyle(fontSize: fullscreen ? 60 : 30),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
