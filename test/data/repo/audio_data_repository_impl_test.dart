import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:funday_flutter_interview/data/local_data_source/audio_data_source.dart';
import 'package:funday_flutter_interview/data/repo/audio_data_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'audio_data_repository_impl_test.mocks.dart';

@GenerateMocks([AudioDataSource])
void main() {
  late AudioDataRepositoryImpl audioDataRepositoryImpl;
  late AudioDataSource audioDataSource;
  setUpAll(() {
    audioDataSource = MockAudioDataSource();
    audioDataRepositoryImpl = AudioDataRepositoryImpl(
      audioDataSource: audioDataSource,
    );
  });
  group('audio data repository impl ...', () {
    test('saveAudio', () async {
      final audioFile = File('assets/audio/臺北市立動物園.mp3');
      final fileName = '臺北市立動物園.mp3';
      when(
        audioDataSource.saveAudio(fileName, audioFile),
      ).thenAnswer((_) async => fileName);
      final filePath = await audioDataRepositoryImpl.saveAudio(
        fileName,
        audioFile,
      );
      expect(filePath, isNotNull);
      expect(filePath, isA<String>());
      expect(filePath, contains('臺北市立動物園.mp3'));
    });
    test('getAudioPath', () async {
      final fileName = '臺北市立動物園.mp3';
      when(
        audioDataSource.getAudioPath(fileName),
      ).thenAnswer((_) async => 'assets/audio/臺北市立動物園.mp3');
      final filePath = await audioDataRepositoryImpl.getAudioPath(fileName);
      expect(filePath, isNotNull);
      expect(filePath, isA<String>());
      expect(filePath, equals('assets/audio/臺北市立動物園.mp3'));
    });
    test('getAudioFileFromPath', () async {
      final filePath = 'assets/audio/臺北市立動物園.mp3';
      when(
        audioDataSource.getAudioFileFromPath(filePath),
      ).thenAnswer((_) async => File('assets/audio/臺北市立動物園.mp3'));
      final audioFile = await audioDataRepositoryImpl.getAudioFileFromPath(
        filePath,
      );
      expect(audioFile, isNotNull);
      expect(audioFile, isA<File>());
      expect(audioFile?.path, equals('assets/audio/臺北市立動物園.mp3'));
    });
    test('deleteAudio', () async {
      final fileName = '臺北市立動物園.mp3';
      when(audioDataSource.deleteAudio(fileName)).thenAnswer((_) async => true);
      final result = await audioDataRepositoryImpl.deleteAudio(fileName);
      expect(result, isNotNull);
      expect(result, isA<bool>());
      expect(result, isTrue);
    });
  });
}
