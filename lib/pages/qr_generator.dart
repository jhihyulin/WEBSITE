import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:universal_html/html.dart' as html;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../widget/expansion_tile.dart';
import '../widget/launch_url.dart';

class QRGeneratorPage extends StatefulWidget {
  const QRGeneratorPage({super.key});

  @override
  State<QRGeneratorPage> createState() => _QRGeneratorPageState();
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
  ImageProvider? _embeddedImage;
  final GlobalKey globalKey = GlobalKey();
  QrEmbeddedImageStyle _embeddedImageSize = const QrEmbeddedImageStyle(
    size: Size(30, 30),
  );
  final TextEditingController _textEditingController = TextEditingController();
  QrDataModuleShape _selectModuleShape = QrDataModuleShape.circle;

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
    final RenderRepaintBoundary boundary = renderKey.currentContext?.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final anchor = html.AnchorElement(href: 'data:image/png;base64,${base64Encode(byteData!.buffer.asUint8List())}');
    anchor.download = 'QRCode.png';
    anchor.click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Generator'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: BoxConstraints(
              maxWidth: 700,
              minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.description),
                    labelText: 'Input Data',
                    hintText: 'Enter data to generate QR code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _textEditingController.clear();
                        _generate();
                      },
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 10,
                  onChanged: (value) {
                    _generate();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: CustomExpansionTile(
                    title: const Text('Advanced'),
                    children: [
                      ListTile(
                        title: const Text('Version'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.help),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('What about version?'),
                                      content: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 700,
                                          minWidth: 700,
                                        ),
                                        child: SingleChildScrollView(
                                          physics: const BouncingScrollPhysics(),
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text:
                                                      'The symbol versions of QR Code range from Version 1 to Version 40. Each version has a different module configuration or number of modules. (The module refers to the black and white dots that make up QR Code.)"Module configuration" refers to the number of modules contained in a symbol, commencing with Version 1 (21 × 21 modules) up to Version 40 (177 × 177 modules). Each higher version number comprises 4 additional modules per side.\nSource: ',
                                                ),
                                                TextSpan(
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.primary,
                                                  ),
                                                  text: 'https://www.qrcode.com/en/about/version.html',
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      CustomLaunchUrl.launch(context, 'https://www.qrcode.com/en/about/version.html');
                                                    },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      actions: [
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
                              },
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: _versionSelect,
                                onChanged: (value) {
                                  setState(() {
                                    _version = value as int;
                                    _versionSelect = value;
                                    _generate();
                                  });
                                },
                                items: [
                                  const DropdownMenuItem(
                                    value: QrVersions.auto,
                                    child: Text('Auto'),
                                  ),
                                  for (var i = 1; i <= 40; i++)
                                    DropdownMenuItem(
                                      value: i,
                                      child: Text('$i'),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: const Text('Background Color'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                setState(() {
                                  _backgroundColor = Colors.white;
                                  _generate();
                                });
                              },
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _backgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Background Color'),
                                      content: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: ColorPicker(
                                          pickerColor: _backgroundColor,
                                          onColorChanged: (color) {
                                            setState(() {
                                              _backgroundColor = color;
                                            });
                                          },
                                          pickerAreaHeightPercent: 0.8,
                                          enableAlpha: true,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _generate();
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: const Text('Foreground Color'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                setState(() {
                                  _foregroundColor = Colors.black;
                                  _generate();
                                });
                              },
                            ),
                            InkWell(
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
                                      title: const Text('Foreground Color'),
                                      content: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: ColorPicker(
                                          pickerColor: _foregroundColor,
                                          onColorChanged: (color) {
                                            setState(() {
                                              _foregroundColor = color;
                                            });
                                          },
                                          pickerAreaHeightPercent: 0.8,
                                          enableAlpha: false,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _generate();
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: const Text('Gapless'),
                        subtitle: const Text('Adds an extra pixel in size to prevent gaps'),
                        trailing: Switch(
                          value: _gapless,
                          onChanged: (value) {
                            setState(() {
                              _gapless = value;
                              _generate();
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Padding'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                setState(() {
                                  _padding = 10;
                                  _generate();
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
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
                              icon: const Icon(Icons.add),
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
                        ),
                      ),
                      ListTile(
                        title: const Text('Use Embedded Image'),
                        trailing: Switch(
                          value: _useEmbeddedImage,
                          onChanged: (value) {
                            setState(() {
                              _useEmbeddedImage = value;
                              _generate();
                            });
                          },
                        ),
                      ),
                      Offstage(
                        offstage: !_useEmbeddedImage,
                        child: ListTile(
                          title: const Text('Embedded Image Size'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  setState(() {
                                    _embeddedImageSize = const QrEmbeddedImageStyle(
                                      size: Size(30, 30),
                                    );
                                    _generate();
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: _embeddedImageSize.size != const Size(0, 0)
                                    ? () {
                                        setState(() {
                                          _embeddedImageSize = (_embeddedImageSize.size != const Size(0, 0)
                                              ? QrEmbeddedImageStyle(
                                                  size: Size(
                                                    _embeddedImageSize.size!.width - 1,
                                                    _embeddedImageSize.size!.height - 1,
                                                  ),
                                                )
                                              : null)!;
                                          _generate();
                                        });
                                      }
                                    : null,
                              ),
                              Text('${_embeddedImageSize.size!.width.toInt()}x${_embeddedImageSize.size!.height.toInt()}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _embeddedImageSize = QrEmbeddedImageStyle(
                                      size: Size(
                                        _embeddedImageSize.size!.width + 1,
                                        _embeddedImageSize.size!.height + 1,
                                      ),
                                    );
                                    _generate();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: !_useEmbeddedImage,
                        child: ListTile(
                          title: const Text('Embedded Image'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  setState(() {
                                    _embeddedImage = null;
                                    _generate();
                                  });
                                },
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.image),
                                label: const Text('Select Image'),
                                onPressed: () async {
                                  var pickedFile = await _imagePicker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (pickedFile != null) {
                                    setState(() {
                                      _embeddedImage = NetworkImage(pickedFile.path);
                                      _generate();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Module Shape'),
                        trailing: ToggleButtons(
                          borderRadius: BorderRadius.circular(16),
                          isSelected: [
                            _selectModuleShape == QrDataModuleShape.circle,
                            _selectModuleShape == QrDataModuleShape.square,
                          ],
                          onPressed: (index) {
                            setState(() {
                              _selectModuleShape = index == 0 ? QrDataModuleShape.circle : QrDataModuleShape.square;
                              _generate();
                            });
                          },
                          children: const <Widget>[
                            Icon(Icons.circle),
                            Icon(Icons.square),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Offstage(
                  offstage: _data.isEmpty,
                  child: RepaintBoundary(
                    key: globalKey,
                    child: QrImageView(
                      data: _data,
                      version: _version,
                      size: 200,
                      gapless: _gapless,
                      backgroundColor: _backgroundColor,
                      dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: _selectModuleShape,
                        color: _foregroundColor,
                      ),
                      padding: EdgeInsets.all(_padding.toDouble()),
                      embeddedImage: _useEmbeddedImage ? _embeddedImage ?? const AssetImage('assets/images/logo-512x512.png') : null,
                      embeddedImageStyle: _useEmbeddedImage ? _embeddedImageSize : null,
                      errorStateBuilder: (cxt, err) {
                        return Center(
                          child: Text(
                            "Uh oh! Something went wrong...\n\n$err",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                      embeddedImageEmitsError: true,
                    ),
                  ),
                ),
                Offstage(
                  offstage: _data.isEmpty,
                  child: const SizedBox(
                    height: 20,
                  ),
                ),
                Offstage(
                  offstage: _data.isEmpty,
                  child: ElevatedButton.icon(
                    label: const Text('Save QR Code'),
                    icon: const Icon(Icons.save),
                    onPressed: _createImageFromRenderKey,
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
