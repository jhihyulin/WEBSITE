import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart';

class ZHSH3DMapPage extends StatefulWidget {
  @override
  _ZHSH3DMapPageState createState() => _ZHSH3DMapPageState();
}

class _ZHSH3DMapPageState extends State<ZHSH3DMapPage> {
  late DiTreDiController controller;
  double _zoomVariable = 1.0;
  bool _zoomMode = true;

  @override
  void initState() {
    super.initState();
    controller = DiTreDiController();
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_zoomMode) {
        _zoomVariable += 0.1;
        if (_zoomVariable >= 2) {
          setState(() {
            _zoomMode = false;
          });
        }
      } else {
        _zoomVariable -= 0.1;
        if (_zoomVariable <= 1) {
          setState(() {
            _zoomMode = true;
          });
        }
      }
      setState(() {
        _zoomVariable = _zoomVariable;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ZHSH 3D Map'),
        ),
        body: DiTreDiDraggable(
          controller: controller,
          child: DiTreDi(
            figures: [
              for (var i = 0; i < 10; i++)
                for (var j = 0; j < 10; j++)
                  for (var k = 0; k < 10; k++)
                    Cube3D(1, Vector3(i * _zoomVariable, j * _zoomVariable, k * _zoomVariable)),
            ],
            controller: controller,
          ),
        ));
  }
}
