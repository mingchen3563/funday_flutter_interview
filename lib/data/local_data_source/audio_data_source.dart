import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AudioDataSource {
  final String? systemFolderPath;
  AudioDataSource({this.systemFolderPath});

  final String _audioDirectory = '/audio';
  // Future<String> saveAudio(String fileName, File audioFile) async {
  //   final filePath = systemFolderPath ?? (await getApplicationDocumentsDirectory()).path;

  //   final file = File('$filePath$_audioDirectory/$fileName');

  //   await file.writeAsBytes(audioFile.readAsBytesSync());
  //   return file.path;
  // }
  Future<String> saveAudio(String fileName, File audioFile) async {
    // Get system folder path
    final basePath =
        systemFolderPath ?? (await getApplicationDocumentsDirectory()).path;
    log('basePath $basePath');
    // Build audio directory path
    final audioDir = Directory('$basePath$_audioDirectory');
    log('audioDir $audioDir');
    // Ensure directory exists
    if (!await audioDir.exists()) {
      log('create audio directory $audioDir');
      await audioDir.create(recursive: true);
    }

    // Ensure filename has extension (default to .mp3 if missing)
    if (!fileName.contains('.')) {
      fileName = '$fileName.mp3';
    }

    final filePath = '${audioDir.path}/$fileName';

    // Write asynchronously
    final bytes = await audioFile.readAsBytes();
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    log('saved audio to $filePath');
    return file.path;
  }

  Future<String?> getAudioPath(String fileName) async {
    final filePath =
        systemFolderPath ?? (await getApplicationDocumentsDirectory()).path;
    final file = File('$filePath$_audioDirectory/$fileName.mp3');
    if (file.existsSync()) {
      return file.path;
    }
    return null;
  }

  Future<File?> getAudioFileFromPath(String filePath) async {
    if (File(filePath).existsSync()) {
      return File(filePath);
    }
    return null;
  }

  Future<bool> deleteAudio(String fileName) async {
    final filePath =
        systemFolderPath ?? (await getApplicationDocumentsDirectory()).path;
    final file = File('$filePath$_audioDirectory/$fileName');
    if (file.existsSync()) {
      await file.delete();
      return true;
    }
    return false;
  }
}
