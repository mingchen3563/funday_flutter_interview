import 'dart:io';
import 'package:funday_flutter_interview/data/local_data_source/audio_data_source.dart';
import 'package:funday_flutter_interview/domain/repo/audio_data_repository.dart';

class AudioDataRepositoryImpl extends AudioDataRepository {
  AudioDataRepositoryImpl(AudioDataSource? audioDataSource)
    : audioDataSource = audioDataSource ?? AudioDataSource();
  final AudioDataSource audioDataSource;

  @override
  Future<bool> deleteAudio(String fileName) {
    // TODO: implement deleteAudio
    throw UnimplementedError();
  }

  @override
  Future<File> getAudioFileFromPath(String filePath) {
    // TODO: implement getAudioFileFromPath
    throw UnimplementedError();
  }

  @override
  Future<String?> getAudioPath(String fileName) {
    // TODO: implement getAudioPath
    throw UnimplementedError();
  }

  @override
  Future<String> saveAudio(String fileName, File audioFile) {
    // TODO: implement saveAudio
    throw UnimplementedError();
  }
}
