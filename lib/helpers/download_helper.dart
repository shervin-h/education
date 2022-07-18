import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';


class Downloader {

  /// Available for Android Platform
  /// ```
  /// Directory? externalStorageDirectory = await getExternalStorageDirectory();
  /// externalStorageDirectory!.path -> /storage/emulated/0/Android/data/shervin.hasanzadeh.education/files
  /// ```
  ///
  /// Available for All Platforms
  /// ```
  /// Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
  /// appDocumentDirectory.path -> /data/user/0/shervin.hasanzadeh.education/app_flutter
  /// ```
  static Future<String> getFilePath(String fileName) async {
    Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentDirectory.path;
    String filePath = '$appDocumentsPath/education/$fileName';
    // filePath -> /data/user/0/shervin.hasanzadeh.education/app_flutter/education/videoName.mp4
    return filePath;
  }

  static Future<String> saveFile(String fileName, List<int> bytes) async {
    File file = File(await getFilePath(fileName));
    file = await file.writeAsBytes(bytes);
    return file.path;
  }

  static Future<File> readFile(String fileName) async {
    File file = File(await getFilePath(fileName));
    Uint8List fileContent = await file.readAsBytes();
    return File.fromRawPath(fileContent);
  }

  static Future<String> downloadFile(String url, String fileName) async {
    HttpClient httpClient = HttpClient();
    String filePath = '';
    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        filePath = await saveFile(fileName, bytes);
      } else {
        // filePath.contains('Error'); // true
        filePath = 'Error code: ${response.statusCode.toString()}';
      }
    }
    catch(e) {
      // filePath.contains('Error'); // true
      filePath = 'Error Can not fetch url';
    }
    // filePath.contains('Error'); // false
    return filePath;
  }

}

/*
import 'package:ext_storage/ext_storage.dart';

Future<String> _getPathToDownload() async {
  return ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
}

final String path = await _getPathToDownload();
print(path);
 */