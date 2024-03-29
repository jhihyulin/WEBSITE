import 'package:flutter/material.dart';

import '../widget/text_form_field.dart';
import '../widget/toggle_buttons.dart';

class BMIPage extends StatefulWidget {
  const BMIPage({super.key});

  @override
  State<BMIPage> createState() => _BMIPageState();
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
        title: const Text('BMI'),
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
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: _heightController,
                        prefixIcon: const Icon(Icons.height),
                        labelText: 'Height',
                        suffixIcon: CustomToggleButtons(
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
                          children: const <Widget>[
                            Text('cm'),
                            Text('in'),
                          ],
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
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: _weightController,
                        prefixIcon: const Icon(Icons.scale),
                        labelText: 'Weight',
                        suffixIcon: CustomToggleButtons(
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
                          children: const <Widget>[
                            Text('kg'),
                            Text('lb'),
                          ],
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
                        child: const SizedBox(
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
