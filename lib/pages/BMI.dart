import 'package:flutter/material.dart';

class BMIPage extends StatefulWidget {
  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double _bmi = 0;
  String _bmiResult = '';
  String _heightUnit = 'cm';
  String _weightUnit = 'kg';

  void init() {
    _heightController.text = '0';
    _weightController.text = '0';
    _bmi = 0;
    _bmiResult = '';
    _heightUnit = 'cm';
    _weightUnit = 'kg';
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  void caculateBMI() {
    double height = double.parse(_heightController.text);
    double weight = double.parse(_weightController.text);
    if (_heightUnit == 'in') {
      height = height * 2.54;
    }
    if (_weightUnit == 'lb') {
      weight = weight * 0.453592;
    }
    setState(() {
      _bmi = weight / ((height / 100) * (height / 100));
      if (_bmi < 18.5) {
        _bmiResult = 'Underweight';
      } else if (_bmi >= 18.5 && _bmi < 24) {
        _bmiResult = 'Normal';
      } else if (_bmi >= 24 && _bmi < 27) {
        _bmiResult = 'Overweight';
      } else if (_bmi >= 27 && _bmi < 30) {
        _bmiResult = 'Midly Obese';
      } else if (_bmi >= 30 && _bmi < 35) {
        _bmiResult = 'Moderately Obese';
      } else if (_bmi >= 35) {
        _bmiResult = 'Severely Obese';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 700,
              minHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        
                        controller: _heightController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.height),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          labelText: 'Height',
                          suffixIcon: ToggleButtons(
                            borderRadius: BorderRadius.circular(16),
                            children: <Widget>[
                              Text('cm'),
                              Text('in'),
                            ],
                            isSelected: [
                              _heightUnit == 'cm',
                              _heightUnit == 'in'
                            ],
                            onPressed: (index) {
                              setState(() {
                                if (index == 0) {
                                  _heightUnit = 'cm';
                                } else {
                                  _heightUnit = 'in';
                                }
                              });
                              caculateBMI();
                            },
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (_formKey.currentState!.validate()) {
                              caculateBMI();
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.scale),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          labelText: 'Weight',
                          suffixIcon: ToggleButtons(
                            borderRadius: BorderRadius.circular(16),
                            children: <Widget>[
                              Text('kg'),
                              Text('lb'),
                            ],
                            isSelected: [
                              _weightUnit == 'kg',
                              _weightUnit == 'lb'
                            ],
                            onPressed: (index) {
                              setState(() {
                                if (index == 0) {
                                  _weightUnit = 'kg';
                                } else {
                                  _weightUnit = 'lb';
                                }
                              });
                              caculateBMI();
                            },
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (_formKey.currentState!.validate()) {
                              caculateBMI();
                            }
                          }
                        },
                      ),
                      Offstage(
                        offstage: _weightController.text == '' ||
                            _heightController.text == '',
                        child: SizedBox(
                          height: 10,
                        ),
                      ),
                      Offstage(
                        offstage: _weightController.text == '' ||
                            _heightController.text == '',
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            Chip(
                              label: Text('BMI: ${_bmi.toStringAsFixed(2)}'),
                            ),
                            Chip(
                              label: Text('Result: $_bmiResult'),
                            ),
                          ],
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
    );
  }
}
