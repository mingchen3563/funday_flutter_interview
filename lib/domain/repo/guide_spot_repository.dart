import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';
import 'package:funday_flutter_interview/fund/lang.dart';

abstract class GuideSpotRepository {
  Future<List<GuideSpot>> getGuideSpots({
    required Lang lang,
    required int page,
  });
}
