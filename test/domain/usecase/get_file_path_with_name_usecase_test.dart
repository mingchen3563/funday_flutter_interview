import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:funday_flutter_interview/domain/repo/audio_data_repository.dart';
import 'package:funday_flutter_interview/domain/usecase/get_file_path_with_name_usecase.dart';
import 'package:funday_flutter_interview/data/repo/audio_data_repository_impl.dart';

import 'get_file_path_with_name_usecase_test.mocks.dart';

@GenerateMocks([AudioDataRepository])
void main() {
  late GetFilePathWithNameUsecase usecase;
  late MockAudioDataRepository mockRepository;

  setUp(() {
    mockRepository = MockAudioDataRepository();
    usecase = GetFilePathWithNameUsecase(audioDataRepository: mockRepository);
  });

  group('GetFilePathWithNameUsecase', () {
    group('constructor', () {
      test('should create instance with provided repository', () {
        // Arrange & Act
        final usecase = GetFilePathWithNameUsecase(
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
          final usecase = GetFilePathWithNameUsecase();

          // Assert
          expect(usecase, isNotNull);
          expect(usecase.audioDataRepository, isA<AudioDataRepositoryImpl>());
        },
      );
    });

    group('call method', () {
      test(
        'should return file path when repository returns valid path',
        () async {
          // Arrange
          const fileName = 'test_audio.mp3';
          const expectedPath = '/documents/audio/test_audio.mp3';
          when(
            mockRepository.getAudioPath(fileName),
          ).thenAnswer((_) async => expectedPath);

          // Act
          final result = await usecase.call(fileName: fileName);

          // Assert
          expect(result, equals(expectedPath));
          verify(mockRepository.getAudioPath(fileName)).called(1);
        },
      );

      test('should return null when repository returns null', () async {
        // Arrange
        const fileName = 'non_existent_audio.mp3';
        when(
          mockRepository.getAudioPath(fileName),
        ).thenAnswer((_) async => null);

        // Act
        final result = await usecase.call(fileName: fileName);

        // Assert
        expect(result, isNull);
        verify(mockRepository.getAudioPath(fileName)).called(1);
      });

      test('should handle file names with special characters', () async {
        // Arrange
        const fileName = '測試_音檔_特殊字符.mp3';
        const expectedPath = '/documents/audio/測試_音檔_特殊字符.mp3';
        when(
          mockRepository.getAudioPath(fileName),
        ).thenAnswer((_) async => expectedPath);

        // Act
        final result = await usecase.call(fileName: fileName);

        // Assert
        expect(result, equals(expectedPath));
        verify(mockRepository.getAudioPath(fileName)).called(1);
      });

      test('should handle empty file name', () async {
        // Arrange
        const fileName = '';
        when(
          mockRepository.getAudioPath(fileName),
        ).thenAnswer((_) async => null);

        // Act
        final result = await usecase.call(fileName: fileName);

        // Assert
        expect(result, isNull);
        verify(mockRepository.getAudioPath(fileName)).called(1);
      });

      test('should propagate exceptions from repository', () async {
        // Arrange
        const fileName = 'test_audio.mp3';
        final exception = Exception('Repository error');
        when(mockRepository.getAudioPath(fileName)).thenThrow(exception);

        // Act & Assert
        expect(
          () async => await usecase.call(fileName: fileName),
          throwsA(equals(exception)),
        );
        verify(mockRepository.getAudioPath(fileName)).called(1);
      });

      test('should handle various file extensions', () async {
        // Arrange
        const testCases = ['audio.mp3', 'sound.wav', 'music.m4a', 'voice.aac'];

        for (final fileName in testCases) {
          final expectedPath = '/documents/audio/$fileName';
          when(
            mockRepository.getAudioPath(fileName),
          ).thenAnswer((_) async => expectedPath);

          // Act
          final result = await usecase.call(fileName: fileName);

          // Assert
          expect(result, equals(expectedPath));
        }

        // Verify all calls were made
        for (final fileName in testCases) {
          verify(mockRepository.getAudioPath(fileName)).called(1);
        }
      });

      test('should handle long file names', () async {
        // Arrange
        const fileName =
            'very_long_audio_file_name_with_many_characters_and_details.mp3';
        const expectedPath =
            '/documents/audio/very_long_audio_file_name_with_many_characters_and_details.mp3';
        when(
          mockRepository.getAudioPath(fileName),
        ).thenAnswer((_) async => expectedPath);

        // Act
        final result = await usecase.call(fileName: fileName);

        // Assert
        expect(result, equals(expectedPath));
        verify(mockRepository.getAudioPath(fileName)).called(1);
      });
    });

    group('integration behavior', () {
      test('should delegate to repository correctly', () async {
        // Arrange
        const fileName = 'integration_test.mp3';
        const expectedPath = '/documents/audio/integration_test.mp3';
        when(
          mockRepository.getAudioPath(fileName),
        ).thenAnswer((_) async => expectedPath);

        // Act
        final result = await usecase(fileName: fileName);

        // Assert
        expect(result, equals(expectedPath));
        verify(mockRepository.getAudioPath(fileName)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      test('should work with call operator', () async {
        // Arrange
        const fileName = 'call_operator_test.mp3';
        const expectedPath = '/documents/audio/call_operator_test.mp3';
        when(
          mockRepository.getAudioPath(fileName),
        ).thenAnswer((_) async => expectedPath);

        // Act - Using call operator
        final result = await usecase(fileName: fileName);

        // Assert
        expect(result, equals(expectedPath));
        verify(mockRepository.getAudioPath(fileName)).called(1);
      });
    });
  });
}
