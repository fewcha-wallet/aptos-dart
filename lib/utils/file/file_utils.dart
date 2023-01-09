import 'dart:io';

import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<File> createTemperateBinaryFile(Uint8List rawData) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      File file = File('$tempPath/temp.bin');
      await file.writeAsBytes(rawData);
      return file;
    } catch (e) {
      rethrow;
    }
  }
}
