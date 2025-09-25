import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AudioDataSource {
  final String? systemFolderPath;
  AudioDataSource({this.systemFolderPath});

  final String _audioDirectory = '/audio';
  Future<String> saveAudio(String fileName, File audioFile) async {
    final filePath = systemFolderPath ?? (await getTemporaryDirectory()).path;

    final file = File('$filePath$_audioDirectory/$fileName');
    await file.writeAsBytes(audioFile.readAsBytesSync());
    return file.path;
  }

  Future<String?> getAudioPath(String fileName) async {
    final filePath = systemFolderPath ?? (await getTemporaryDirectory()).path;
    final file = File('$filePath$_audioDirectory/$fileName');
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
    final filePath = systemFolderPath ?? (await getTemporaryDirectory()).path;
    final file = File('$filePath$_audioDirectory/$fileName');
    if (file.existsSync()) {
      await file.delete();
      return true;
    }
    return false;
  }
}
