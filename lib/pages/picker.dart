import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class PickerPage extends StatefulWidget {
  const PickerPage({Key? key}) : super(key: key);

  @override
  State<PickerPage> createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  final TextEditingController _controller = TextEditingController();

  List<String> _textList = [];

  void onChange() {
    if (_controller.text.isEmpty) {
      setState(() {
        _textList = [];
      });
      return;
    }
    setState(() {
      _textList = _controller.text.split('\n');
    });
  }

  double _rotate = 0;
  bool _spined = false;
  String? _spinedString;
  Timer? _spinTimer;
  bool _spinning = false;

  void spin() {
    setState(() {
      _spinning = true;
    });
    var textList = _textList;
    var textLength = _textList.length;
    var random = Random();
    var randomInt = random.nextInt(textLength);
    var spinNumber = random.nextInt(3) + 3;
    var anAngle = 360 ~/ textLength;
    var halfAngle = anAngle ~/ 2;
    var speed = 10;
    var ramdomValue = random.nextDouble() * halfAngle;
    _spinTimer?.cancel();
    _spinTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (_rotate >= 360) {
        setState(() {
          _rotate = 0;
        });
        spinNumber--;
      } else {
        if (spinNumber <= 0 &&
            _rotate >= randomInt * 360 ~/ textLength &&
            _rotate <= randomInt * 360 ~/ textLength + anAngle) {
          setState(() {
            _rotate = randomInt * anAngle + ramdomValue;
            _spinedString = textList[randomInt];
            _spined = true;
            _spinning = false;
          });
          _spinTimer?.cancel();
          return;
        } else {
          setState(() {
            _rotate += speed;
          });
        }
      }
    });
  }

  bool _isDesktop() {
    return MediaQuery.of(context).size.width >= 640;
  }

  double mathSquare() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var appBarHeight = AppBar().preferredSize.height;
    if (_isDesktop()) {
      if (width / 32 * 19 > height - appBarHeight) {
        return height - appBarHeight;
      } else {
        return width / 32 * 19;
      }
    } else {
      return width / 24 * 19;
    }
  }

  double mathPin() {
    var width = MediaQuery.of(context).size.width;
    if (_isDesktop()) {
      return width / 32 * 5;
    } else {
      return width / 24 * 5;
    }
  }

  double mathActionArea() {
    var width = MediaQuery.of(context).size.width;
    if (_isDesktop()) {
      return width / 32 * 8;
    } else {
      return width;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _spinTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Picker'),
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
                child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              width: mathSquare() + mathPin(),
                              height: mathSquare(),
                              child: Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0))),
                                  child: Row(children: [
                                    SizedBox(
                                      width: mathSquare() - 20,
                                      height: mathSquare() - 20,
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                              child: RotationTransition(
                                            turns: AlwaysStoppedAnimation(
                                                -_rotate / 360),
                                            child: CustomPaint(
                                              size: Size(mathSquare() - 40,
                                                  mathSquare() - 40),
                                              painter: MyPainter(
                                                  context: context,
                                                  textList: _textList),
                                            ),
                                          ))),
                                    ),
                                    SizedBox(
                                        width: mathPin() - 20,
                                        height: mathPin() - 20,
                                        child: Center(
                                            child: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: CustomPaint(
                                            size: Size(
                                                mathPin() - 40, mathPin() - 40),
                                            painter:
                                                PinPainter(context: context),
                                          ),
                                        )))
                                  ])),
                            ),
                            Container(
                                padding: const EdgeInsets.all(10),
                                width: mathActionArea(),
                                child: Card(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0))),
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Wrap(
                                              alignment: WrapAlignment.center,
                                              children: [
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    height: (mathActionArea() -
                                                            20) /
                                                        3,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton.icon(
                                                            onPressed: _spinning
                                                                ? () {
                                                                    _spinTimer
                                                                        ?.cancel();
                                                                    setState(
                                                                        () {
                                                                      _spinning =
                                                                          false;
                                                                    });
                                                                  }
                                                                : () {
                                                                    spin();
                                                                  },
                                                            icon: _spinning
                                                                ? const Icon(
                                                                    Icons.stop,
                                                                    color: Colors
                                                                        .red)
                                                                : const Icon(Icons
                                                                    .play_arrow),
                                                            label: _spinning
                                                                ? const Text(
                                                                    'Stop',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red))
                                                                : const Text(
                                                                    'Spin'))
                                                      ],
                                                    )),
                                                SizedBox(
                                                    width: (mathActionArea() -
                                                            20) /
                                                        3,
                                                    height: (mathActionArea() -
                                                            20) /
                                                        3,
                                                    child: Offstage(
                                                      offstage: !_spined,
                                                      child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: FittedBox(
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                              child: Chip(
                                                                  label: Text(
                                                                '$_spinedString',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            48),
                                                                maxLines: 1,
                                                              )))),
                                                    ))
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            TextField(
                                              controller: _controller,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 15,
                                              minLines: 5,
                                              decoration: InputDecoration(
                                                  enabled: !_spinning,
                                                  labelText: 'Name List',
                                                  hintText:
                                                      'Newline to separate',
                                                  prefixIcon: const Icon(
                                                      Icons.text_fields),
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      16.0)))),
                                              onChanged: (value) => onChange(),
                                            ),
                                          ],
                                        )))),
                          ],
                        ),
                      ],
                    )))));
  }
}

class MyPainter extends CustomPainter {
  BuildContext context;
  List<String> textList = [];

  MyPainter({required this.context, required this.textList});

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);

    List<MaterialColor> colors = [
      Colors.amber,
      Colors.blue,
      Colors.blueGrey,
      Colors.brown,
      Colors.cyan,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.green,
      Colors.indigo,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.lime,
      Colors.orange,
      Colors.pink,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.yellow,
    ];

    var textLength = textList.length;
    if (textLength != 0) {
      for (var i = 0; i < textList.length; i++) {
        var color = colors[i >= colors.length ? i % colors.length : i];
        var textLength = textList.length;
        var preAngle = (2 * pi / textLength) * (i - 1);
        var angle = (2 * pi / textLength) * i;
        // split circle
        final splitCirclePainter = Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.fill;
        canvas.drawArc(
            Rect.fromCircle(center: center, radius: size.width / 2 - 10),
            preAngle,
            angle - preAngle,
            true, // use center
            splitCirclePainter);
      }
      canvas.translate(size.width / 2, size.height / 2);
      for (var i = 0; i < textList.length; i++) {
        var textLength = textList.length;
        var angle = (2 * pi / textLength) * i;
        var aAngle = (2 * pi / textLength);
        // text
        canvas.save();
        canvas.rotate(angle + aAngle / 2);
        final textPainter = TextPainter(
          textAlign: TextAlign.end,
          text: TextSpan(
            text: textList[i],
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: textLength > 20
                    ? textLength > 40
                        ? textLength > 80
                            ? textLength > 160
                                ? 2
                                : 4
                            : 8
                        : 16
                    : 32),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
            canvas,
            center.translate(-textPainter.width - 20,
                -size.height / 2 - textPainter.height / 2));
        canvas.restore();
      }
    } else {
      // retuen a Colors.amber circle
      final splitCirclePainter = Paint()
        ..color = colors[0]
        ..strokeWidth = 2
        ..style = PaintingStyle.fill;
      canvas.drawArc(
          Rect.fromCircle(center: center, radius: size.width / 2 - 10),
          0,
          2 * pi,
          true, // use center
          splitCirclePainter);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PinPainter extends CustomPainter {
  BuildContext context;

  PinPainter({required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;

    var paint = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    // generate left pointing pointer
    var leftPointerPath = Path();
    leftPointerPath.moveTo(width, height / 2 - 10);
    leftPointerPath.lineTo(width, height / 2 + 10);
    leftPointerPath.lineTo(0, height / 2);
    leftPointerPath.close();
    canvas.drawPath(leftPointerPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
