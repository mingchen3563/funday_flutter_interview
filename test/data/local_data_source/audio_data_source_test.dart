import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:funday_flutter_interview/data/local_data_source/audio_data_source.dart';

void main() {
  late AudioDataSource audioDataSource;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    audioDataSource = AudioDataSource();
  });

  group('AudioDataSource', () {
    group('getAudioFileFromPath', () {
      test(
        'should return File object when file exists at given path',
        () async {
          // Arrange
          final tempDir = await Directory.systemTemp.createTemp('audio_test');
          final testFile = File('${tempDir.path}/test_audio.mp3');
          await testFile.writeAsBytes([1, 2, 3, 4, 5]);

          try {
            // Act
            final result = await audioDataSource.getAudioFileFromPath(
              testFile.path,
            );

            // Assert
            expect(result, isNotNull);
            expect(result, isA<File>());
            expect(result!.path, equals(testFile.path));
            expect(await result.exists(), isTrue);
          } finally {
            if (await tempDir.exists()) {
              await tempDir.delete(recursive: true);
            }
          }
        },
      );

      test(
        'should return null when file does not exist at given path',
        () async {
          // Arrange
          const nonExistentPath = '/path/to/non/existent/file.mp3';

          // Act
          final result = await audioDataSource.getAudioFileFromPath(
            nonExistentPath,
          );

          // Assert
          expect(result, isNull);
        },
      );

      test('should return null when given empty path', () async {
        // Act
        final result = await audioDataSource.getAudioFileFromPath('');

        // Assert
        expect(result, isNull);
      });

      test('should handle file paths with special characters', () async {
        // Arrange
        final tempDir = await Directory.systemTemp.createTemp('audio_test');
        final testFile = File('${tempDir.path}/測試_音檔_特殊字符.mp3');
        await testFile.writeAsBytes([10, 20, 30]);

        try {
          // Act
          final result = await audioDataSource.getAudioFileFromPath(
            testFile.path,
          );

          // Assert
          expect(result, isNotNull);
          expect(result!.path, equals(testFile.path));
          expect(await result.exists(), isTrue);
        } finally {
          if (await tempDir.exists()) {
            await tempDir.delete(recursive: true);
          }
        }
      });

      test('should return File object that can read correct content', () async {
        // Arrange
        final tempDir = await Directory.systemTemp.createTemp('audio_test');
        final testFile = File('${tempDir.path}/content_test.mp3');
        const expectedContent = [100, 200, 50, 75, 125];
        await testFile.writeAsBytes(expectedContent);

        try {
          // Act
          final result = await audioDataSource.getAudioFileFromPath(
            testFile.path,
          );

          // Assert
          expect(result, isNotNull);
          final actualContent = await result!.readAsBytes();
          expect(actualContent, equals(expectedContent));
        } finally {
          if (await tempDir.exists()) {
            await tempDir.delete(recursive: true);
          }
        }
      });
    });

    group('AudioDataSource class properties', () {
      test('should be properly instantiated', () {
        // Assert
        expect(audioDataSource, isNotNull);
        expect(audioDataSource, isA<AudioDataSource>());
      });

      test('should have all required methods', () {
        // Assert - Check that all methods exist
        expect(audioDataSource.saveAudio, isA<Function>());
        expect(audioDataSource.getAudioPath, isA<Function>());
        expect(audioDataSource.getAudioFileFromPath, isA<Function>());
        expect(audioDataSource.deleteAudio, isA<Function>());
      });
    });
  });
}
