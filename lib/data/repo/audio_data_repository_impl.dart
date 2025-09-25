import 'dart:io';
import 'package:funday_flutter_interview/data/local_data_source/audio_data_source.dart';
import 'package:funday_flutter_interview/domain/repo/audio_data_repository.dart';

class AudioDataRepositoryImpl extends AudioDataRepository {
  AudioDataRepositoryImpl({AudioDataSource? audioDataSource})
    : audioDataSource = audioDataSource ?? AudioDataSource();
  final AudioDataSource audioDataSource;

  @override
  Future<bool> deleteAudio(String fileName) async {
    return await audioDataSource.deleteAudio(fileName);
  }

  @override
  Future<File?> getAudioFileFromPath(String filePath) async {
    return await audioDataSource.getAudioFileFromPath(filePath);
  }

  @override
  Future<String?> getAudioPath(String fileName) {
    return audioDataSource.getAudioPath(fileName);
  }

  @override
  Future<String> saveAudio(String fileName, File audioFile) {
    return audioDataSource.saveAudio(fileName, audioFile);
  }
}
