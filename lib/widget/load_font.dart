import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

abstract class CustomLoadFont {
  static Future<ByteData> fetchFont(src) async {
    var font = await http.get(Uri.parse(src));
    return ByteData.sublistView(font.bodyBytes);
  }

  static Future loadFont(String src, String name) async {
    var fontLoader = FontLoader(name);
    fontLoader.addFont(fetchFont(src));
    await fontLoader.load();
  }
}
