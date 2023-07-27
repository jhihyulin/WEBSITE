import 'dart:async';

import 'package:flutter/material.dart';

import '../widget/card.dart';
import '../widget/toggle_buttons.dart';

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

  int _targetTimeForMilliSeconds = 0;
  int _lastTimeForMilliSeconds = 0;

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
      setState(() {
        _targetTimeForMilliSeconds = DateTime.now().millisecondsSinceEpoch +
            _counterHours * 3600000 +
            _counterMinutes * 60000 +
            (_counterSeconds * 1000).floor();
        _lastTimeForMilliSeconds =
            _targetTimeForMilliSeconds - DateTime.now().millisecondsSinceEpoch;
      });
      _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        if (_lastTimeForMilliSeconds > 0) {
          setState(() {
            _lastTimeForMilliSeconds = _targetTimeForMilliSeconds -
                DateTime.now().millisecondsSinceEpoch;
            _counterHours = (_lastTimeForMilliSeconds / 3600000).floor();
            _counterMinutes =
                ((_lastTimeForMilliSeconds % 3600000) / 60000).floor();
            _counterSeconds =
                (((_lastTimeForMilliSeconds % 3600000) % 60000) / 1000);
          });
        } else {
          setState(() {
            _counterHours = 0;
            _counterMinutes = 0;
            _counterSeconds = 0.00;
            _lastTimeForMilliSeconds = 0;
            _targetTimeForMilliSeconds = 0;
            _isRunning = false;
          });
          _timer.cancel();
          alert();
        }
      });
    } else if (mode == 'stopwatch') {
      setState(() {
        _targetTimeForMilliSeconds = DateTime.now().millisecondsSinceEpoch -
            _counterHours * 3600000 -
            _counterMinutes * 60000 -
            (_counterSeconds * 1000).floor();
        _lastTimeForMilliSeconds =
            DateTime.now().millisecondsSinceEpoch - _targetTimeForMilliSeconds;
      });
      _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
        setState(() {
          _lastTimeForMilliSeconds = DateTime.now().millisecondsSinceEpoch -
              _targetTimeForMilliSeconds;
          _counterHours = (_lastTimeForMilliSeconds / 3600000).floor();
          _counterMinutes =
              ((_lastTimeForMilliSeconds % 3600000) / 60000).floor();
          _counterSeconds =
              (((_lastTimeForMilliSeconds % 3600000) % 60000) / 1000);
        });
      });
    }
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
      _targetTimeForMilliSeconds = 0;
      _lastTimeForMilliSeconds = 0;
    });
    _timer.cancel();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _counterSeconds = 0.00;
      _counterMinutes = 0;
      _counterHours = 0;
      _targetTimeForMilliSeconds = 0;
      _lastTimeForMilliSeconds = 0;
    });
    _timer.cancel();
  }

  void alert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Time UP!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
                      child: CustomCard(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 0,
                              child: SizedBox(
                                width: double.infinity,
                                height: _mathBox() * 0.25,
                                child: TextButton(
                                  onPressed: _isRunning || _mode != 'countdown'
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
                                            .onBackground,
                                      ),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: 'h',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
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
                                              _counterHours = _counterHours < 1
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
                      child: CustomCard(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 0,
                              child: SizedBox(
                                width: double.infinity,
                                height: _mathBox() * 0.25,
                                child: TextButton(
                                  onPressed: _isRunning || _mode != 'countdown'
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
                                            .onBackground,
                                      ),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: 'm',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
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
                      child: CustomCard(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 0,
                              child: SizedBox(
                                width: double.infinity,
                                height: _mathBox() * 0.25,
                                child: TextButton(
                                  onPressed: _isRunning || _mode != 'countdown'
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
                                            .onBackground,
                                      ),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: 's',
                                          style: TextStyle(fontSize: 10),
                                        ),
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomToggleButtons(
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
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
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
          ),
        ),
      ),
    );
  }
}
