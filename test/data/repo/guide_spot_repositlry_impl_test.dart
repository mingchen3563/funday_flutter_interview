import 'package:flutter_test/flutter_test.dart';
import 'package:funday_flutter_interview/data/dto/guide_spots_dto.dart';
import 'package:funday_flutter_interview/data/remote_data_source/travel_taipei_open_api.dart';
import 'package:funday_flutter_interview/data/repo/guide_spot_repositlry_impl.dart';
import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';
import 'package:funday_flutter_interview/fund/lang.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'guide_spot_repositlry_impl_test.mocks.dart';

@GenerateMocks([TravelTaipeiOpenApi])
void main() {
  late TravelTaipeiOpenApi travelTaipeiOpenApi;
  late GuideSpotRepositoryImpl guideSpotRepositoryImpl;
  setUpAll(() {
    travelTaipeiOpenApi = MockTravelTaipeiOpenApi();
    guideSpotRepositoryImpl = GuideSpotRepositoryImpl(
      travelTaipeiOpenApi: travelTaipeiOpenApi,
    );
  });
  group('guide spot repositlry impl ...', () {
    test('getGuideSpots', () async {
      final testDateTime = DateTime.now();
      when(
        travelTaipeiOpenApi.getGuideSpots(lang: Lang.zhTw.value, page: 1),
      ).thenAnswer(
        (_) async => [
          GuideSpotsDto(
            id: 1,
            title: 'test_title',
            modified: testDateTime,
            url: 'test_url',
          ),
        ],
      );
      final List<GuideSpot> guideSpots = await guideSpotRepositoryImpl
          .getGuideSpots(lang: Lang.zhTw, page: 1);
      expect(guideSpots.length, 1);
      expect(guideSpots[0].title, 'test_title');
      expect(guideSpots[0].modifiedDate, testDateTime);
      expect(guideSpots[0].audioUrl, 'test_url');
    });
  });
}
