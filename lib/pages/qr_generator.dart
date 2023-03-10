import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:html' as html;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:url_launcher/url_launcher.dart';

class QRGeneratorPage extends StatefulWidget {
  @override
  _QRGeneratorPageState createState() => _QRGeneratorPageState();
}

class _QRGeneratorPageState extends State<QRGeneratorPage> {
  String _data = '';
  int _version = QrVersions.auto;
  int _versionSelect = QrVersions.auto;
  bool _gapless = true;
  Color _backgroundColor = Colors.white;
  Color _foregroundColor = Colors.black;
  int _padding = 10;
  bool _useEmbeddedImage = false;
  final ImagePicker _imagePicker = ImagePicker();
  var _embeddedImage = null;
  final GlobalKey globalKey = GlobalKey();
  QrEmbeddedImageStyle _embeddedImageSize = QrEmbeddedImageStyle(
    size: Size(30, 30),
  );
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _generate() {
    setState(() {
      _data = _textEditingController.text;
    });
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
                        TextFormField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              labelText: 'Data',
                              hintText: 'Enter data to generate QR code',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            onChanged: (value) {
                              _generate();
                            }),
                        Theme(
                          data: theme,
                          child: ExpansionTile(
                            title: Text('Advanced'),
                            children: [
                              ListTile(
                                  title: Text('Version'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.help),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title: Text(
                                                          'What about version?'),
                                                      content: Container(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: 700,
                                                            minWidth: 700,
                                                          ),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Text.rich(
                                                                TextSpan(
                                                                    children: [
                                                                  TextSpan(
                                                                      text:
                                                                          'The symbol versions of QR Code range from Version 1 to Version 40. Each version has a different module configuration or number of modules. (The module refers to the black and white dots that make up QR Code.)"Module configuration" refers to the number of modules contained in a symbol, commencing with Version 1 (21 ?? 21 modules) up to Version 40 (177 ?? 177 modules). Each higher version number comprises 4 additional modules per side.\nSource: '),
                                                                  TextSpan(
                                                                    style:
                                                                        TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .primary,
                                                                    ),
                                                                    text:
                                                                        'https://www.qrcode.com/en/about/version.html',
                                                                    recognizer:
                                                                        TapGestureRecognizer()
                                                                          ..onTap =
                                                                              () {
                                                                            launchUrl(Uri.parse('https://www.qrcode.com/en/about/version.html'));
                                                                          },
                                                                  )
                                                                ])),
                                                          )),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('OK'))
                                                      ]);
                                                });
                                          }),
                                      DropdownButtonHideUnderline(
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
                                          ]))
                                    ],
                                  )),
                              ListTile(
                                  title: Text('Background Color'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.refresh),
                                          onPressed: () {
                                            setState(() {
                                              _backgroundColor = Colors.white;
                                              _generate();
                                            });
                                          }),
                                      InkWell(
                                          borderRadius:
                                              BorderRadius.circular(16),
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
                                                      title: Text(
                                                          'Background Color'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ColorPicker(
                                                          pickerColor:
                                                              _backgroundColor,
                                                          onColorChanged:
                                                              (color) {
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
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('OK'))
                                                      ]);
                                                });
                                          })
                                    ],
                                  )),
                              ListTile(
                                  title: Text('Foreground Color'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.refresh),
                                          onPressed: () {
                                            setState(() {
                                              _foregroundColor = Colors.black;
                                              _generate();
                                            });
                                          }),
                                      InkWell(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: _foregroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title: Text(
                                                          'Foreground Color'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ColorPicker(
                                                          pickerColor:
                                                              _foregroundColor,
                                                          onColorChanged:
                                                              (color) {
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
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('OK'))
                                                      ]);
                                                });
                                          }),
                                    ],
                                  )),
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
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.refresh),
                                          onPressed: () {
                                            setState(() {
                                              _embeddedImage = null;
                                              _generate();
                                            });
                                          },
                                        ),
                                        ElevatedButton.icon(
                                            icon: Icon(Icons.image),
                                            label: Text('Select Image'),
                                            onPressed: () async {
                                              var pickedFile =
                                                  await _imagePicker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (pickedFile != null) {
                                                setState(() {
                                                  _embeddedImage = NetworkImage(
                                                      pickedFile.path);
                                                  _generate();
                                                });
                                              }
                                            })
                                      ],
                                    )),
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
