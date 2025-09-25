import 'package:funday_flutter_interview/data/dto/guide_spots_dto.dart';
import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';

class GuideSpotMapper {
  static GuideSpot fromDto(GuideSpotsDto guideSpot) {
    return GuideSpot(
      title: guideSpot.title,
      modifiedDate: guideSpot.modified,
      audioUrl: guideSpot.url,
    );
  }
}
