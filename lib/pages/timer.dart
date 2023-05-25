import 'dart:async';

import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool _isRunning = false;
  late Timer _timer;
  String _mode = 'countdown'; // countdown, stopwatch

  double _counterSeconds = 0.00;
  int _counterMinutes = 0;
  int _counterHours = 0;

  double _mathBox() {
    return MediaQuery.of(context).size.width > 700
        ? 700 * .3
        : MediaQuery.of(context).size.width * .3;
  }

  void _startTimer(String mode) {
    setState(() {
      _isRunning = true;
    });
    if (mode == 'countdown') {
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          if (_counterSeconds > 0) {
            _counterSeconds -= 0.01;
          } else if (_counterMinutes > 0) {
            _counterMinutes -= 1;
            _counterSeconds = 59.99;
          } else if (_counterHours > 0) {
            _counterHours -= 1;
            _counterMinutes = 59;
            _counterSeconds = 59.99;
          } else {
            _isRunning = false;
            _timer.cancel();
          }
          if (_counterSeconds <= 0 &&
              _counterMinutes <= 0 &&
              _counterHours <= 0) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Stopwatch'),
                    content: const Text('Stopwatch has reached its limit.'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
            _isRunning = false;
            _timer.cancel();
          }
          _counterSeconds < 0 ? _counterSeconds = 0.00 : _counterSeconds;
        });
      });
    } else if (mode == 'stopwatch') {
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          if (_counterSeconds < 59.99) {
            _counterSeconds += 0.01;
          } else if (_counterMinutes < 59) {
            _counterMinutes += 1;
            _counterSeconds = 0.00;
          } else if (_counterHours < 99) {
            _counterHours += 1;
            _counterMinutes = 0;
            _counterSeconds = 0.00;
          } else {
            _isRunning = false;
            _timer.cancel();
          }
        });
      });
    }
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer.cancel();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _counterSeconds = 0.00;
      _counterMinutes = 0;
      _counterHours = 0;
    });
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Timer'),
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
                child: Container(
              constraints: BoxConstraints(
                maxWidth: 700,
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: _mathBox(),
                        height: _mathBox() * 1.5,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: _mathBox() * 0.25,
                                  child: TextButton(
                                    onPressed:
                                        _isRunning || _mode != 'countdown'
                                            ? null
                                            : () {
                                                setState(() {
                                                  _counterHours += 1;
                                                });
                                              },
                                    child: const Icon(Icons.arrow_drop_up),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    child: RichText(
                                      text: TextSpan(
                                        text: _counterHours
                                            .toString()
                                            .toString()
                                            .padLeft(2, '0'),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                        children: const <TextSpan>[
                                          TextSpan(
                                              text: 'h',
                                              style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: _mathBox() * 0.25,
                                  child: TextButton(
                                    onPressed: _isRunning ||
                                            _mode != 'countdown' ||
                                            _counterHours == 0
                                        ? null
                                        : () {
                                            setState(() {
                                              if (_counterHours > 0) {
                                                _counterHours =
                                                    _counterHours < 1
                                                        ? 0
                                                        : _counterHours - 1;
                                              }
                                            });
                                          },
                                    child: const Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _mathBox(),
                        height: _mathBox() * 1.5,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: _mathBox() * 0.25,
                                  child: TextButton(
                                    onPressed:
                                        _isRunning || _mode != 'countdown'
                                            ? null
                                            : () {
                                                setState(() {
                                                  _counterMinutes += 1;
                                                });
                                              },
                                    child: const Icon(Icons.arrow_drop_up),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    child: RichText(
                                      text: TextSpan(
                                        text: _counterMinutes
                                            .toString()
                                            .padLeft(2, '0'),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                        children: const <TextSpan>[
                                          TextSpan(
                                              text: 'm',
                                              style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: _mathBox() * 0.25,
                                  child: TextButton(
                                    onPressed: _isRunning ||
                                            _mode != 'countdown' ||
                                            _counterMinutes == 0
                                        ? null
                                        : () {
                                            setState(() {
                                              if (_counterMinutes > 0) {
                                                _counterMinutes =
                                                    _counterMinutes < 1
                                                        ? 0
                                                        : _counterMinutes - 1;
                                              }
                                            });
                                          },
                                    child: const Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _mathBox(),
                        height: _mathBox() * 1.5,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: _mathBox() * 0.25,
                                  child: TextButton(
                                    onPressed:
                                        _isRunning || _mode != 'countdown'
                                            ? null
                                            : () {
                                                setState(() {
                                                  _counterSeconds += 1;
                                                });
                                              },
                                    child: const Icon(Icons.arrow_drop_up),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FittedBox(
                                    child: RichText(
                                      text: TextSpan(
                                        text: _counterSeconds
                                            .toStringAsFixed(2)
                                            .padLeft(5, '0'),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                        children: const <TextSpan>[
                                          TextSpan(
                                              text: 's',
                                              style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: _mathBox() * 0.25,
                                  child: TextButton(
                                    onPressed: _isRunning ||
                                            _mode != 'countdown' ||
                                            _counterSeconds == 0
                                        ? null
                                        : () {
                                            setState(() {
                                              if (_counterSeconds > 0) {
                                                _counterSeconds =
                                                    _counterSeconds < 1
                                                        ? 0
                                                        : _counterSeconds - 1;
                                              }
                                            });
                                          },
                                    child: const Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(16),
                      isSelected: [
                        _mode == 'countdown',
                        _mode == 'stopwatch',
                      ],
                      onPressed: _isRunning
                          ? null
                          : (index) {
                              setState(() {
                                if (index == 0) {
                                  _mode = 'countdown';
                                } else if (index == 1) {
                                  _mode = 'stopwatch';
                                }
                              });
                            },
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Countdown'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Stopwatch'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.replay),
                      tooltip: 'Reset',
                      onPressed: _counterSeconds != 0 ||
                              _counterMinutes != 0 ||
                              _counterHours != 0
                          ? _resetTimer
                          : null,
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      ElevatedButton.icon(
                        icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                        label: Text(_isRunning ? 'Pause' : 'Start'),
                        onPressed: _counterHours == 0 &&
                                _counterMinutes == 0 &&
                                _counterSeconds == 0 &&
                                _mode == 'countdown'
                            ? null
                            : _isRunning
                                ? _pauseTimer
                                : () => _startTimer(_mode),
                      ),
                    ],
                  ),
                ],
              ),
            ))));
  }
}
