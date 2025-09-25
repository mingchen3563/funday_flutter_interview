import 'package:funday_flutter_interview/data/repo/audio_data_repository_impl.dart';
import 'package:funday_flutter_interview/domain/repo/audio_data_repository.dart';

class GetFilePathWithNameUsecase {
  final AudioDataRepository audioDataRepository;

  GetFilePathWithNameUsecase({AudioDataRepository? audioDataRepository})
    : audioDataRepository = audioDataRepository ?? AudioDataRepositoryImpl();

  Future<String?> call({required String fileName}) async {
    return await audioDataRepository.getAudioPath(fileName);
  }
}
