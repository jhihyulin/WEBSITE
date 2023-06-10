import 'dart:async';

import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  int _hour = DateTime.now().hour;
  int _minute = DateTime.now().minute;
  int _second = DateTime.now().second;
  bool _fullscreen = false;
  late Timer _timer;
  bool _is12hr = false;

  double _mathBox() {
    return (_fullscreen
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width > 700
                ? 700
                : MediaQuery.of(context).size.width) *
        .25;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      DateTime now = DateTime.now();
      setState(() {
        _hour = _is12hr ? now.hour % 12 : now.hour;
        _minute = now.minute;
        _second = now.second;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    html.document.exitFullscreen();
    super.dispose();
  }

  void changeHourMode() {
    setState(() {
      _is12hr = !_is12hr;
      _hour = _is12hr ? _hour % 12 : _hour;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _fullscreen
          ? null
          : AppBar(
              title: const Text('Clock'),
            ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: _fullscreen
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width > 700
                    ? 700
                    : MediaQuery.of(context).size.width,
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * .75,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: _mathBox(),
                    height: _mathBox(),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: InkWell(
                        onTap: () => changeHourMode(),
                        child: Stack(
                          children: [
                            Container(
                              width: _mathBox(),
                              height: _mathBox(),
                              padding: const EdgeInsets.all(10),
                              child: FittedBox(
                                child: Text(
                                  _hour.toString().padLeft(2, '0'),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: _mathBox() * .25,
                                height: _mathBox() * .25,
                                padding: EdgeInsets.all(_mathBox() * .05),
                                child: FittedBox(
                                  child: Text(
                                    _is12hr
                                        ? DateTime.now().hour < 12
                                            ? 'AM'
                                            : 'PM'
                                        : '',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onBackground,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _mathBox() * .25,
                    height: _mathBox(),
                    child: const FittedBox(
                      alignment: Alignment.center,
                      child: Text(':'),
                    ),
                  ),
                  SizedBox(
                    width: _mathBox(),
                    height: _mathBox(),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: FittedBox(
                          child: Text(
                            _minute.toString().padLeft(2, '0'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _mathBox() * .25,
                    height: _mathBox(),
                    child: const FittedBox(
                      alignment: Alignment.center,
                      child: Text(':'),
                    ),
                  ),
                  SizedBox(
                    width: _mathBox(),
                    height: _mathBox(),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: FittedBox(
                          child: Text(
                            _second.toString().padLeft(2, '0'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          html.document.fullscreenElement == null ? html.document.documentElement!.requestFullscreen() : html.document.exitFullscreen();
          html.document.fullscreenElement == null
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
