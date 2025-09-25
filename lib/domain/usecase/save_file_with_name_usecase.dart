import 'dart:io';

import 'package:funday_flutter_interview/data/repo/audio_data_repository_impl.dart';
import 'package:funday_flutter_interview/domain/repo/audio_data_repository.dart';

class SaveFileWithNameUsecase {
  final AudioDataRepository audioDataRepository;

  SaveFileWithNameUsecase({AudioDataRepository? audioDataRepository})
    : audioDataRepository = audioDataRepository ?? AudioDataRepositoryImpl();

  Future<String> call({required String fileName, required File audioFile}) async {
    return await audioDataRepository.saveAudio(fileName, audioFile);
  }
}
