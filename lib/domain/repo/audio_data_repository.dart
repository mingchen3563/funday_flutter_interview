import 'dart:io';

abstract class AudioDataRepository {
  Future<String> saveAudio(String fileName, File audioFile);
  Future<String?> getAudioPath(String fileName);
  Future<File?> getAudioFileFromPath(String filePath);
  Future<bool> deleteAudio(String fileName);
}
