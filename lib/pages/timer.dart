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
            child: Center(
                child: Container(
          padding: const EdgeInsets.all(20),
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
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _isRunning || _mode != 'countdown'
                            ? null
                            : () {
                                setState(() {
                                  _counterHours += 1;
                                });
                              },
                        child: const Icon(Icons.arrow_drop_up),
                      ),
                      Chip(
                        label: Text('$_counterHours H'),
                      ),
                      TextButton(
                        onPressed: _isRunning || _mode != 'countdown'
                            ? null
                            : () {
                                setState(() {
                                  if (_counterHours > 0) {
                                    _counterHours -= 1;
                                  }
                                });
                              },
                        child: const Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _isRunning || _mode != 'countdown'
                            ? null
                            : () {
                                setState(() {
                                  _counterMinutes += 1;
                                });
                              },
                        child: const Icon(Icons.arrow_drop_up),
                      ),
                      Chip(
                        label: Text('$_counterMinutes M'),
                      ),
                      TextButton(
                        onPressed: _isRunning || _mode != 'countdown'
                            ? null
                            : () {
                                setState(() {
                                  if (_counterMinutes > 0) {
                                    _counterMinutes -= 1;
                                  }
                                });
                              },
                        child: const Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _isRunning || _mode != 'countdown'
                            ? null
                            : () {
                                setState(() {
                                  _counterSeconds += 1;
                                });
                              },
                        child: const Icon(Icons.arrow_drop_up),
                      ),
                      Chip(
                        label: Text('${_counterSeconds.toStringAsFixed(2)} S'),
                      ),
                      TextButton(
                        onPressed: _isRunning || _mode != 'countdown'
                            ? null
                            : () {
                                setState(() {
                                  if (_counterSeconds > 0) {
                                    _counterSeconds -= 1;
                                  }
                                });
                              },
                        child: const Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    labelText: 'Mode',
                  ),
                  child: DropdownButton(
                    value: _mode,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'countdown',
                        child: Text('Countdown'),
                      ),
                      DropdownMenuItem(
                        value: 'stopwatch',
                        child: Text('Stopwatch'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _mode = value!;
                      });
                    },
                  )),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(_isRunning ? 'Pause' : 'Start'),
                    onPressed:
                        _isRunning ? _pauseTimer : () => _startTimer(_mode),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text('Reset'),
                    onPressed: _counterSeconds != 0 ||
                            _counterMinutes != 0 ||
                            _counterHours != 0
                        ? _resetTimer
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ))));
  }
}
