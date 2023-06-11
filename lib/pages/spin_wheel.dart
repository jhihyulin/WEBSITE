import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../widget/scaffold_messenger.dart';
import '../widget/expansion_tile.dart';
import '../widget/card.dart';
import '../widget/text_form_field.dart';

class SpinWheelPage extends StatefulWidget {
  const SpinWheelPage({Key? key}) : super(key: key);

  @override
  State<SpinWheelPage> createState() => _SpinWheelPageState();
}

class _SpinWheelPageState extends State<SpinWheelPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

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
  static const int _rotateSpeed = 30;

  void spin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    onChange();
    setState(() {});
    setState(() {
      _spinning = true;
    });
    final textList = _textList;
    var textLength = _textList.length;
    var random = Random();
    var randomInt = random.nextInt(textLength);
    var spinNumber = random.nextInt(3) + 3;
    var originalSpinNumber = spinNumber;
    var anAngle = 360 / textLength;
    var targetAngle = anAngle * randomInt + random.nextDouble() * anAngle;
    var allNeedToRotateAngle = originalSpinNumber * 360 + targetAngle;
    _spinTimer?.cancel();
    var currentRotateSpeed = _rotateSpeed.toDouble();
    _spinTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      var needToRotateAngle = allNeedToRotateAngle - (originalSpinNumber - spinNumber) * 360 - _rotate;
      currentRotateSpeed = sqrt((needToRotateAngle / 360) < 0.0001 ? 0.0001 : (needToRotateAngle / 360)) * _rotateSpeed;
      if (_rotate >= 360) {
        setState(() {
          _rotate = 0;
        });
        spinNumber--;
        setState(() {
          _rotate += currentRotateSpeed;
        });
      } else {
        if (spinNumber <= 0) {
          if (_rotate >= targetAngle) {
            var st = textList[randomInt];
            var newList = [];
            for (var i = 0; i < textList.length; i++) {
              if (i != randomInt) {
                newList.add(textList[i]);
              }
            }
            setState(() {
              _spinedString = st;
              _controller.text = newList.join('\n');
              _spined = true;
              _spinning = false;
            });
            _spinTimer?.cancel();
            return;
          } else {
            setState(() {
              _rotate += currentRotateSpeed;
            });
          }
        } else {
          setState(() {
            _rotate += currentRotateSpeed;
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
        title: const Text('Spin Wheel'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
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
                      child: CustomCard(
                        child: Row(
                          children: [
                            SizedBox(
                              width: mathSquare() - 20,
                              height: mathSquare() - 20,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                child: Center(
                                  child: RotationTransition(
                                    turns: AlwaysStoppedAnimation(-_rotate / 360),
                                    child: CustomPaint(
                                      size: Size(mathSquare() - 60, mathSquare() - 60),
                                      painter: MyPainter(
                                        context: context,
                                        textList: _textList,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: mathPin() - 20,
                              height: mathPin() - 20,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                  child: CustomPaint(
                                    size: Size(mathPin() - 30, mathPin() - 40),
                                    painter: PinPainter(
                                      context: context,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: mathActionArea(),
                      child: CustomCard(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: mathActionArea() / 2 - 30,
                                    height: mathActionArea() / 2 - 30,
                                    child: IconButton(
                                      onPressed: _spinning
                                          ? () {
                                              _spinTimer?.cancel();
                                              setState(() {
                                                _spinning = false;
                                                _spined = false;
                                                _spinedString = '';
                                              });
                                            }
                                          : () {
                                              spin();
                                            },
                                      icon: _spinning ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
                                      iconSize: 64,
                                      color: _spinning ? Colors.red : Colors.green,
                                      tooltip: _spinning
                                          ? 'Stop'
                                          : _spined
                                              ? _textList.isNotEmpty && _spined
                                                  ? 'Next'
                                                  : 'Spin'
                                              : 'Spin',
                                    ),
                                  ),
                                  Offstage(
                                    offstage: !_spinning && !_spined,
                                    child: Container(
                                      width: mathActionArea() / 2 - 30,
                                      height: mathActionArea() / 2 - 30,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(10),
                                      child: _spinning
                                          ? const CircularProgressIndicator()
                                          : FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Chip(
                                                label: Text(
                                                  _spinedString ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 128,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Form(
                                key: _formKey,
                                child: CustomTextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  controller: _controller,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 10,
                                  minLines: 5,
                                  suffix: IconButton(
                                    onPressed: () {
                                      _controller.clear();
                                      _textList = [];
                                      _spinedString = '';
                                      _spined = false;
                                      onChange();
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                                  enabled: !_spinning,
                                  labelText: 'Name List',
                                  hintText: 'Newline to split',
                                  prefixIcon: const Icon(Icons.text_fields),
                                  onChanged: (value) => onChange(),
                                ),
                              ),
                              // const SizedBo
                              const SizedBox(
                                height: 10,
                              ),
                              CustomCard(
                                child: CustomExpansionTile(
                                  title: const Text('Generate Number'),
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Form(
                                        key: _formKey2,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: CustomTextFormField(
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Required';
                                                  } else if (int.tryParse(value) == null) {
                                                    return 'Only number';
                                                  }
                                                  return null;
                                                },
                                                controller: _controller2,
                                                keyboardType: TextInputType.number,
                                                enabled: !_spinning,
                                                labelText: 'Min',
                                                hintText: 'Min',
                                                onChanged: (value) => onChange(),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              flex: 2,
                                              child: CustomTextFormField(
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return 'Required';
                                                  } else if (int.tryParse(value) == null) {
                                                    return 'Only number';
                                                  }
                                                  return null;
                                                },
                                                controller: _controller3,
                                                keyboardType: TextInputType.number,
                                                enabled: !_spinning,
                                                labelText: 'Max',
                                                hintText: 'Max',
                                                onChanged: (value) => onChange(),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: IconButton(
                                                tooltip: 'Add',
                                                onPressed: _spinning
                                                    ? null
                                                    : () {
                                                        if (_formKey2.currentState!.validate()) {
                                                          if (int.parse(_controller2.text) > int.parse(_controller3.text)) {
                                                            CustomScaffoldMessenger.showErrorMessageSnackBar(context, 'Error: Min must be less than Max');
                                                            return;
                                                          }
                                                          var tL = [];
                                                          for (int i = int.parse(_controller2.text); i <= int.parse(_controller3.text); i++) {
                                                            tL.add(i.toString());
                                                          }
                                                          _controller.text = _controller.text == '' ? tL.join('\n') : '${_controller.text}\n${tL.join('\n')}';
                                                          onChange();
                                                          setState(() {});
                                                        }
                                                      },
                                                icon: const Icon(Icons.add),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

class MyPainter extends CustomPainter {
  BuildContext context;
  List<String> textList = [];

  MyPainter({required this.context, required this.textList});

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(
      size.width / 2,
      size.height / 2,
    );

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

    // shadow
    canvas.drawShadow(
      Path()
        ..moveTo(0, 0)
        ..addArc(
          Rect.fromCircle(center: center, radius: size.width / 2),
          0,
          2 * pi,
        ),
      Colors.black,
      10,
      true,
    );

    var textLength = textList.length;
    if (textLength != 0) {
      // split circle
      for (var i = 0; i < textList.length; i++) {
        var color = colors[i >= colors.length ? i % colors.length : i];
        if (i % colors.length == 0 && i >= colors.length) {
          color = colors[2];
        }
        var textLength = textList.length;
        var preAngle = (2 * pi / textLength) * (i - 1);
        var angle = (2 * pi / textLength) * i;
        // split circle
        final splitCirclePainter = Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.fill;
        canvas.drawArc(
          Rect.fromCircle(
            center: center,
            radius: size.width / 2,
          ),
          preAngle,
          angle - preAngle,
          true, // use center
          splitCirclePainter,
        );
      }
      canvas.translate(
        size.width / 2,
        size.height / 2,
      );
      // text
      for (var i = 0; i < textList.length; i++) {
        var angle = (2 * pi / textLength) * i;
        var aAngle = (2 * pi / textLength);
        double fontSize = textList[i].isEmpty
            ? 0
            : (2 / textList.length * size.width) > size.width / 2
                ? size.width / 2 * 1 / textList[i].length * 0.8
                : (2 / textList.length * size.width) * 1 / textList[i].length * 0.8;
        // text
        canvas.save();
        canvas.rotate(angle + aAngle / 2);
        final textPainter = TextPainter(
          textAlign: TextAlign.end,
          text: TextSpan(
            text: textList[i],
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: fontSize,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          center.translate(-textPainter.width - 10, -size.height / 2 - textPainter.height / 2),
        );
        canvas.restore();
      }
    } else {
      // retuen a Colors.amber circle
      final splitCirclePainter = Paint()
        ..color = colors[0]
        ..strokeWidth = 2
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: size.width / 2,
        ),
        0,
        2 * pi,
        true, // use center
        splitCirclePainter,
      );
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

    // left pointing pointer
    var leftPointerPath = Path();
    leftPointerPath.moveTo(width, height / 2 - 10);
    leftPointerPath.lineTo(width, height / 2 + 10);
    leftPointerPath.lineTo(0, height / 2);
    leftPointerPath.close();
    // shadow
    canvas.drawShadow(leftPointerPath, Colors.black, 10, true);
    // draw pointer
    canvas.drawPath(leftPointerPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
