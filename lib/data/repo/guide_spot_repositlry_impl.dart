import 'package:funday_flutter_interview/data/mapper/guide_spot_mapper.dart';
import 'package:funday_flutter_interview/data/remote_data_source/travel_taipei_open_api.dart';
import 'package:funday_flutter_interview/domain/repo/guide_spot_repository.dart';
import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';
import 'package:funday_flutter_interview/fund/lang.dart';

class GuideSpotRepositoryImpl extends GuideSpotRepository {
  final TravelTaipeiOpenApi travelTaipeiOpenApi;
  GuideSpotRepositoryImpl({TravelTaipeiOpenApi? travelTaipeiOpenApi})
    : travelTaipeiOpenApi = travelTaipeiOpenApi ?? TravelTaipeiOpenApi();
  @override
  Future<List<GuideSpot>> getGuideSpots({
    required Lang lang,
    required int page,
  }) async {
    final guideSpots = await travelTaipeiOpenApi.getGuideSpots(
      lang: lang.value,
      page: page,
    );
    return guideSpots.map((e) => GuideSpotMapper.fromDto(e)).toList();
  }
}
