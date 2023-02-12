import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class QRGeneratorPage extends StatefulWidget {
  @override
  _QRGeneratorPageState createState() => _QRGeneratorPageState();
}

class _QRGeneratorPageState extends State<QRGeneratorPage> {
  bool _generated = false;
  String _data = '';
  int _version = QrVersions.auto;
  int _versionSelect = QrVersions.auto;
  bool _gapless = true;
  Color _backgroundColor = Colors.white;
  Color _foregroundColor = Colors.black;
  int _padding = 10;
  bool _useEmbeddedImage = false;
  ImagePicker _imagePicker = ImagePicker();
  var _embeddedImage = null;
  final GlobalKey globalKey = GlobalKey();
  QrEmbeddedImageStyle _embeddedImageSize = QrEmbeddedImageStyle(
    size: Size(30, 30),
  );
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _generate() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _data = _textEditingController.text;
        _generated = true;
      });
    }
  }

  void _createImageFromRenderKey() async {
    var renderKey = globalKey;
    final RenderRepaintBoundary boundary =
        renderKey.currentContext?.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final anchor = html.AnchorElement(
        href:
            'data:image/png;base64,${base64Encode(byteData!.buffer.asUint8List())}');
    anchor.download = 'QRCode.png';
    anchor.click();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
        appBar: AppBar(
          title: Text('QR Generator'),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Container(
                    padding: EdgeInsets.all(20),
                    constraints: BoxConstraints(
                      maxWidth: 700,
                      minHeight: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: TextFormField(
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                labelText: 'Data',
                                hintText: 'Enter data to generate QR code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _generate();
                              }),
                        ),
                        Theme(
                          data: theme,
                          child: ExpansionTile(
                            title: Text('Advanced'),
                            children: [
                              ListTile(
                                  title: Text('Version'),
                                  trailing: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          value: _versionSelect,
                                          onChanged: (value) {
                                            setState(() {
                                              _version = value as int;
                                              _versionSelect = value as int;
                                              _generate();
                                            });
                                          },
                                          items: [
                                        DropdownMenuItem(
                                          child: Text('Auto'),
                                          value: QrVersions.auto,
                                        ),
                                        for (var i = 1; i <= 40; i++)
                                          DropdownMenuItem(
                                            child: Text('$i'),
                                            value: i,
                                          ),
                                      ]))),
                              ListTile(
                                  title: Text('Background Color'),
                                  subtitle: Text('Defaults to transparent'),
                                  trailing: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: _backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  title:
                                                      Text('Background Color'),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ColorPicker(
                                                      pickerColor:
                                                          _backgroundColor,
                                                      onColorChanged: (color) {
                                                        setState(() {
                                                          _backgroundColor =
                                                              color;
                                                        });
                                                      },
                                                      pickerAreaHeightPercent:
                                                          0.8,
                                                      enableAlpha: true,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _generate();
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('OK'))
                                                  ]);
                                            });
                                      })),
                              ListTile(
                                title: Text('Foreground Color'),
                                subtitle: Text('Defaults to black'),
                                trailing: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: _foregroundColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                                title: Text('Foreground Color'),
                                                content: SingleChildScrollView(
                                                  child: ColorPicker(
                                                    pickerColor:
                                                        _foregroundColor,
                                                    onColorChanged: (color) {
                                                      setState(() {
                                                        _foregroundColor =
                                                            color;
                                                      });
                                                    },
                                                    pickerAreaHeightPercent:
                                                        0.8,
                                                    enableAlpha: false,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          _generate();
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('OK'))
                                                ]);
                                          });
                                    }),
                              ),
                              ListTile(
                                  title: Text('Gapless'),
                                  subtitle: Text(
                                      'Adds an extra pixel in size to prevent gaps'),
                                  trailing: Switch(
                                    value: _gapless,
                                    onChanged: (value) {
                                      setState(() {
                                        _gapless = value;
                                        _generate();
                                      });
                                    },
                                  )),
                              ListTile(
                                  title: Text('Padding'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.refresh),
                                        onPressed: () {
                                          setState(() {
                                            _padding = 10;
                                            _generate();
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: _padding > 0
                                            ? () {
                                                setState(() {
                                                  _padding--;
                                                  _generate();
                                                });
                                              }
                                            : null,
                                      ),
                                      Text('$_padding'),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: _padding < 100
                                            ? () {
                                                setState(() {
                                                  _padding++;
                                                  _generate();
                                                });
                                              }
                                            : null,
                                      ),
                                    ],
                                  )),
                              ListTile(
                                  title: Text('Use Embedded Image'),
                                  trailing: Switch(
                                    value: _useEmbeddedImage,
                                    onChanged: (value) {
                                      setState(() {
                                        _useEmbeddedImage = value;
                                        _generate();
                                      });
                                    },
                                  )),
                              Offstage(
                                offstage: !_useEmbeddedImage,
                                child: ListTile(
                                    title: Text('Embedded Image Size'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.refresh),
                                          onPressed: () {
                                            setState(() {
                                              _embeddedImageSize =
                                                  QrEmbeddedImageStyle(
                                                      size: Size(30, 30));
                                              _generate();
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: _embeddedImageSize.size !=
                                                  Size(0, 0)
                                              ? () {
                                                  setState(() {
                                                    _embeddedImageSize = (_embeddedImageSize
                                                                .size !=
                                                            Size(0, 0)
                                                        ? QrEmbeddedImageStyle(
                                                            size: Size(
                                                                _embeddedImageSize
                                                                        .size!
                                                                        .width -
                                                                    1,
                                                                _embeddedImageSize
                                                                        .size!
                                                                        .height -
                                                                    1))
                                                        : null)!;
                                                    _generate();
                                                  });
                                                }
                                              : null,
                                        ),
                                        Text(
                                            '${_embeddedImageSize.size!.width.toInt()}x${_embeddedImageSize.size!.height.toInt()}'),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              _embeddedImageSize =
                                                  QrEmbeddedImageStyle(
                                                      size: Size(
                                                          _embeddedImageSize
                                                                  .size!.width +
                                                              1,
                                                          _embeddedImageSize
                                                                  .size!
                                                                  .height +
                                                              1));
                                              _generate();
                                            });
                                          },
                                        ),
                                      ],
                                    )),
                              ),
                              Offstage(
                                offstage: !_useEmbeddedImage,
                                child: ListTile(
                                    title: Text('Embedded Image'),
                                    trailing: ElevatedButton.icon(
                                        icon: Icon(Icons.image),
                                        label: Text('Select Image'),
                                        onPressed: () async {
                                          var pickedFile =
                                              await _imagePicker.pickImage(
                                                  source: ImageSource.gallery);
                                          if (pickedFile != null) {
                                            setState(() {
                                              _embeddedImage =
                                                  NetworkImage(pickedFile.path);
                                              _generate();
                                            });
                                          }
                                        })),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Offstage(
                          offstage: _data.isEmpty,
                          child: Container(
                              child: RepaintBoundary(
                            key: globalKey,
                            child: QrImage(
                              data: _data,
                              version: _version,
                              size: 200,
                              gapless: _gapless,
                              backgroundColor: _backgroundColor,
                              foregroundColor: _foregroundColor,
                              padding: EdgeInsets.all(_padding.toDouble()),
                              embeddedImage: _useEmbeddedImage
                                  ? _embeddedImage != null
                                      ? _embeddedImage
                                      : AssetImage(
                                          'assets/images/logo-512x512.png')
                                  : null,
                              embeddedImageStyle:
                                  _useEmbeddedImage ? _embeddedImageSize : null,
                              errorStateBuilder: (cxt, err) {
                                return Container(
                                  child: Center(
                                    child: Text(
                                      "Uh oh! Something went wrong...\n\n$err",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              embeddedImageEmitsError: true,
                            ),
                          )),
                        ),
                        Offstage(
                          offstage: _data.isEmpty,
                          child: Container(
                            child: SizedBox(height: 20),
                          ),
                        ),
                        Offstage(
                            offstage: _data.isEmpty,
                            child: ElevatedButton.icon(
                              label: Text('Save QR Code'),
                              icon: Icon(Icons.save),
                              onPressed: _createImageFromRenderKey,
                            ))
                      ],
                    )))));
  }
}
