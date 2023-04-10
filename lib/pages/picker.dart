import 'dart:math';

import 'package:flutter/material.dart';

class PickerPage extends StatefulWidget {
  PickerPage({Key? key}) : super(key: key);

  @override
  State<PickerPage> createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  final TextEditingController _controller = TextEditingController();

  double mathSquare() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var appBarHeight = AppBar().preferredSize.height;
    var padding = 20;
    if (width >= 640) {
      if (width / 2 < 320) {
        return (320 - padding).toDouble();
      } else if (width / 2 > height - appBarHeight - padding) {
        return height - appBarHeight - padding;
      } else {
        return width / 2 - padding;
      }
    } else {
      return width - padding;
    }
  }

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

  void spin() {}

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
                              constraints: BoxConstraints(
                                minWidth:
                                    MediaQuery.of(context).size.width < 320
                                        ? MediaQuery.of(context).size.width
                                        : 320,
                                maxWidth: MediaQuery.of(context).size.width >=
                                        640
                                    ? MediaQuery.of(context).size.width / 2 <
                                            320
                                        ? 320
                                        : MediaQuery.of(context).size.width / 2
                                    : MediaQuery.of(context).size.width,
                              ),
                              child: SizedBox(
                                  width: mathSquare(),
                                  height: mathSquare(),
                                  child: Card(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0))),
                                    child: Container(
                                        padding: const EdgeInsets.all(30),
                                        child: Center(
                                          child: CustomPaint(
                                            size: Size(mathSquare() - 60,
                                                mathSquare() - 60),
                                            painter: MyPainter(
                                                context: context,
                                                textList: _textList),
                                          ),
                                        )),
                                  )),
                            ),
                            Container(
                                padding: const EdgeInsets.all(10),
                                constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(context).size.width < 320
                                          ? MediaQuery.of(context).size.width
                                          : 320,
                                  maxWidth: MediaQuery.of(context).size.width >=
                                          640
                                      ? MediaQuery.of(context).size.width / 3 <
                                              320
                                          ? 320
                                          : MediaQuery.of(context).size.width /
                                              3
                                      : MediaQuery.of(context).size.width,
                                ),
                                child: Card(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0))),
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: _controller,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 15,
                                              minLines: 5,
                                              decoration: const InputDecoration(
                                                  labelText: 'Data',
                                                  hintText:
                                                      'Use newline to separate',
                                                  prefixIcon:
                                                      Icon(Icons.text_fields),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  16.0)))),
                                              onChanged: (value) => onChange(),
                                            ),
                                            const SizedBox(height: 20),
                                            Wrap(
                                              spacing: 10,
                                              children: [
                                                // TODO: add in batch future
                                                ElevatedButton.icon(
                                                    onPressed: () {},
                                                    icon:
                                                        const Icon(Icons.start),
                                                    label: const Text('Spin'))
                                              ],
                                            )
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
    // final paint = Paint()
    //   ..color = Theme.of(context).buttonTheme.colorScheme!.primary
    //   ..strokeWidth = 5
    //   ..style = PaintingStyle.fill;
    // canvas.drawCircle(
    //     Offset(size.width / 2, size.height / 2), size.height / 2, paint);

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
        var nextAngle = (2 * pi / textLength) * (i + 1);
        // split circle
        final splitCirclePainter = Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.fill;
        canvas.drawArc(
            Rect.fromCircle(center: center, radius: size.width / 2 - 10),
            preAngle, // start angle
            angle - preAngle, // sweep angle
            true, // use center
            splitCirclePainter);
      }
      canvas.translate(size.width / 2, size.height / 2);
      for (var i = 0; i < textList.length; i++) {
        var textLength = textList.length;
        var preAngle = (2 * pi / textLength) * (i - 1);
        var angle = (2 * pi / textLength) * i;
        var aAngle = (2 * pi / textLength);
        var nextAngle = (2 * pi / textLength) * (i + 1);
        // text
        canvas.save();
        canvas.rotate(angle + aAngle / 2);
        final textPainter = TextPainter(
          text: TextSpan(
            text: textList[i],
            style: TextStyle(color: Colors.black, fontSize: textLength > 20 ? textLength > 40 ? textLength > 80 ? textLength > 160 ? 2 : 4 : 8 : 16 : 32),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, center.translate(0, -size.height / 2 - textPainter.height / 2));
        canvas.restore();
      }
    } else {
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'No Data',
          style: TextStyle(color: Colors.black, fontSize: 32),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, center.translate(-textPainter.width / 2, -textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
