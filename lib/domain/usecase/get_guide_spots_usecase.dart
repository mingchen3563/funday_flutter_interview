import 'package:funday_flutter_interview/data/repo/guide_spot_repositlry_impl.dart';
import 'package:funday_flutter_interview/domain/repo/guide_spot_repository.dart';
import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';
import 'package:funday_flutter_interview/fund/lang.dart';

class GetGuideSpotsUsecase {
  final GuideSpotRepository guideSpotRepository;

  GetGuideSpotsUsecase({GuideSpotRepository? guideSpotRepository})
    : guideSpotRepository = guideSpotRepository ?? GuideSpotRepositoryImpl();

  Future<List<GuideSpot>> getGuideSpotsByPage({required Lang lang, required int page}) async {
    return await guideSpotRepository.getGuideSpots(lang: lang, page: page);
  }
}
