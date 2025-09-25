import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:funday_flutter_interview/domain/repo/audio_data_repository.dart';
import 'package:funday_flutter_interview/domain/usecase/save_file_with_name_usecase.dart';
import 'package:funday_flutter_interview/data/repo/audio_data_repository_impl.dart';

import 'save_file_with_name_usecase_test.mocks.dart';

@GenerateMocks([AudioDataRepository, File])
void main() {
  late SaveFileWithNameUsecase usecase;
  late MockAudioDataRepository mockRepository;
  late MockFile mockFile;

  setUp(() {
    mockRepository = MockAudioDataRepository();
    mockFile = MockFile();
    usecase = SaveFileWithNameUsecase(audioDataRepository: mockRepository);
  });

  group('SaveFileWithNameUsecase', () {
    group('constructor', () {
      test('should create instance with provided repository', () {
        // Arrange & Act
        final usecase = SaveFileWithNameUsecase(
          audioDataRepository: mockRepository,
        );

        // Assert
        expect(usecase, isNotNull);
        expect(usecase.audioDataRepository, equals(mockRepository));
      });

      test(
        'should create instance with default repository when none provided',
        () {
          // Arrange & Act
          final usecase = SaveFileWithNameUsecase();

          // Assert
          expect(usecase, isNotNull);
          expect(usecase.audioDataRepository, isA<AudioDataRepositoryImpl>());
        },
      );
    });

    group('call method', () {
      test(
        'should return saved file path when repository saves successfully',
        () async {
          // Arrange
          const fileName = 'test_audio.mp3';
          const expectedPath = '/documents/audio/test_audio.mp3';
          when(
            mockRepository.saveAudio(fileName, mockFile),
          ).thenAnswer((_) async => expectedPath);

          // Act
          final result = await usecase.call(
            fileName: fileName,
            audioFile: mockFile,
          );

          // Assert
          expect(result, equals(expectedPath));
          verify(mockRepository.saveAudio(fileName, mockFile)).called(1);
        },
      );

      test('should handle file names with special characters', () async {
        // Arrange
        const fileName = '測試_音檔_特殊字符.mp3';
        const expectedPath = '/documents/audio/測試_音檔_特殊字符.mp3';
        when(
          mockRepository.saveAudio(fileName, mockFile),
        ).thenAnswer((_) async => expectedPath);

        // Act
        final result = await usecase.call(
          fileName: fileName,
          audioFile: mockFile,
        );

        // Assert
        expect(result, equals(expectedPath));
        verify(mockRepository.saveAudio(fileName, mockFile)).called(1);
      });

      test('should handle empty file name', () async {
        // Arrange
        const fileName = '';
        const expectedPath = '/documents/audio/';
        when(
          mockRepository.saveAudio(fileName, mockFile),
        ).thenAnswer((_) async => expectedPath);

        // Act
        final result = await usecase.call(
          fileName: fileName,
          audioFile: mockFile,
        );

        // Assert
        expect(result, equals(expectedPath));
        verify(mockRepository.saveAudio(fileName, mockFile)).called(1);
      });

      test('should propagate exceptions from repository', () async {
        // Arrange
        const fileName = 'test_audio.mp3';
        final exception = Exception('Repository save error');
        when(mockRepository.saveAudio(fileName, mockFile)).thenThrow(exception);

        // Act & Assert
        expect(
          () async =>
              await usecase.call(fileName: fileName, audioFile: mockFile),
          throwsA(equals(exception)),
        );
        verify(mockRepository.saveAudio(fileName, mockFile)).called(1);
      });

      test('should handle various file extensions', () async {
        // Arrange
        const testCases = ['audio.mp3', 'sound.wav', 'music.m4a', 'voice.aac'];

        for (final fileName in testCases) {
          final expectedPath = '/documents/audio/$fileName';
          when(
            mockRepository.saveAudio(fileName, mockFile),
          ).thenAnswer((_) async => expectedPath);

          // Act
          final result = await usecase.call(
            fileName: fileName,
            audioFile: mockFile,
          );

          // Assert
          expect(result, equals(expectedPath));
        }

        // Verify all calls were made
        for (final fileName in testCases) {
          verify(mockRepository.saveAudio(fileName, mockFile)).called(1);
        }
      });

      test('should handle long file names', () async {
        // Arrange
        const fileName =
            'very_long_audio_file_name_with_many_characters_and_details.mp3';
        const expectedPath =
            '/documents/audio/very_long_audio_file_name_with_many_characters_and_details.mp3';
        when(
          mockRepository.saveAudio(fileName, mockFile),
        ).thenAnswer((_) async => expectedPath);

        // Act
        final result = await usecase.call(
          fileName: fileName,
          audioFile: mockFile,
        );

        // Assert
        expect(result, equals(expectedPath));
        verify(mockRepository.saveAudio(fileName, mockFile)).called(1);
      });

      test('should handle different File objects', () async {
        // Arrange
        final mockFile1 = MockFile();
        final mockFile2 = MockFile();
        const fileName = 'test_audio.mp3';
        const expectedPath1 = '/documents/audio/test_audio.mp3';
        const expectedPath2 = '/documents/audio/test_audio.mp3';

        when(
          mockRepository.saveAudio(fileName, mockFile1),
        ).thenAnswer((_) async => expectedPath1);
        when(
          mockRepository.saveAudio(fileName, mockFile2),
        ).thenAnswer((_) async => expectedPath2);

        // Act
        final result1 = await usecase.call(
          fileName: fileName,
          audioFile: mockFile1,
        );
        final result2 = await usecase.call(
          fileName: fileName,
          audioFile: mockFile2,
        );

        // Assert
        expect(result1, equals(expectedPath1));
        expect(result2, equals(expectedPath2));
        verify(mockRepository.saveAudio(fileName, mockFile1)).called(1);
        verify(mockRepository.saveAudio(fileName, mockFile2)).called(1);
      });

      test('should handle file system exceptions', () async {
        // Arrange
        const fileName = 'test_audio.mp3';
        final fileSystemException = FileSystemException(
          'No space left on device',
          '/documents/audio/test_audio.mp3',
        );
        when(
          mockRepository.saveAudio(fileName, mockFile),
        ).thenThrow(fileSystemException);

        // Act & Assert
        expect(
          () async =>
              await usecase.call(fileName: fileName, audioFile: mockFile),
          throwsA(isA<FileSystemException>()),
        );
        verify(mockRepository.saveAudio(fileName, mockFile)).called(1);
      });
    });

    group('integration behavior', () {
      test('should delegate to repository correctly', () async {
        // Arrange
        const fileName = 'integration_test.mp3';
        const expectedPath = '/documents/audio/integration_test.mp3';
        when(
          mockRepository.saveAudio(fileName, mockFile),
        ).thenAnswer((_) async => expectedPath);

        // Act
        final result = await usecase.call(
          fileName: fileName,
          audioFile: mockFile,
        );

        // Assert
        expect(result, equals(expectedPath));
        verify(mockRepository.saveAudio(fileName, mockFile)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should work with call operator', () async {
        // Arrange
        const fileName = 'call_operator_test.mp3';
        const expectedPath = '/documents/audio/call_operator_test.mp3';
        when(
          mockRepository.saveAudio(fileName, mockFile),
        ).thenAnswer((_) async => expectedPath);

        // Act - Using call operator
        final result = await usecase.call(
          fileName: fileName,
          audioFile: mockFile,
        );

        // Assert
        expect(result, equals(expectedPath));
        verify(mockRepository.saveAudio(fileName, mockFile)).called(1);
      });

      test(
        'should maintain consistent behavior across multiple calls',
        () async {
          // Arrange
          const fileName = 'consistent_test.mp3';
          const expectedPath = '/documents/audio/consistent_test.mp3';
          when(
            mockRepository.saveAudio(fileName, mockFile),
          ).thenAnswer((_) async => expectedPath);

          // Act - Multiple calls
          final result1 = await usecase.call(
            fileName: fileName,
            audioFile: mockFile,
          );
          final result2 = await usecase.call(
            fileName: fileName,
            audioFile: mockFile,
          );
          final result3 = await usecase.call(
            fileName: fileName,
            audioFile: mockFile,
          );

          // Assert
          expect(result1, equals(expectedPath));
          expect(result2, equals(expectedPath));
          expect(result3, equals(expectedPath));
          verify(mockRepository.saveAudio(fileName, mockFile)).called(3);
        },
      );
    });

    group('real world scenarios', () {
      test('should handle typical audio file save workflow', () async {
        // Arrange
        const fileName = '臺北市立動物園.mp3';
        const expectedPath = '/documents/audio/臺北市立動物園.mp3';
        when(
          mockRepository.saveAudio(fileName, mockFile),
        ).thenAnswer((_) async => expectedPath);

        // Act
        final result = await usecase.call(
          fileName: fileName,
          audioFile: mockFile,
        );

        // Assert
        expect(result, equals(expectedPath));
        expect(result, contains('臺北市立動物園.mp3'));
        verify(mockRepository.saveAudio(fileName, mockFile)).called(1);
      });

      test('should handle file replacement scenario', () async {
        // Arrange - First save
        const fileName = 'replaceable_audio.mp3';
        const expectedPath = '/documents/audio/replaceable_audio.mp3';
        when(
          mockRepository.saveAudio(fileName, mockFile),
        ).thenAnswer((_) async => expectedPath);

        // Act - Save same filename multiple times (simulating replacement)
        final result1 = await usecase.call(
          fileName: fileName,
          audioFile: mockFile,
        );
        final result2 = await usecase.call(
          fileName: fileName,
          audioFile: mockFile,
        );

        // Assert
        expect(result1, equals(expectedPath));
        expect(result2, equals(expectedPath));
        verify(mockRepository.saveAudio(fileName, mockFile)).called(2);
      });
    });
  });
}
