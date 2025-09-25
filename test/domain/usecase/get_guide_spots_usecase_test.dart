import 'package:flutter_test/flutter_test.dart';
import 'package:funday_flutter_interview/domain/repo/guide_spot_repository.dart';
import 'package:funday_flutter_interview/domain/usecase/get_guide_spots_usecase.dart';
import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';
import 'package:funday_flutter_interview/fund/lang.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_guide_spots_usecase_test.mocks.dart';

@GenerateMocks([GuideSpotRepository])
void main() {
  late GuideSpotRepository guideSpotRepository;
  late GetGuideSpotsUsecase getGuideSpotsUsecase;
  setUpAll(() {
    guideSpotRepository = MockGuideSpotRepository();
    getGuideSpotsUsecase = GetGuideSpotsUsecase(
      guideSpotRepository: guideSpotRepository,
    );
  });
  group('get guide spots usecase ...', () {
    test('get guide spots by page', () async {
      final testDateTime = DateTime.now();
      when(
        guideSpotRepository.getGuideSpots(lang: Lang.zhTw, page: 1),
      ).thenAnswer(
        (_) async => [
          GuideSpot(
            title: 'test',
            modifiedDate: testDateTime,
            audioUrl: 'test',
          ),
        ],
      );
      final guideSpots = await getGuideSpotsUsecase.getGuideSpotsByPage(
        lang: Lang.zhTw,
        page: 1,
      );
      expect(guideSpots.length, 1);
      expect(guideSpots[0].title, 'test');
      expect(guideSpots[0].modifiedDate, testDateTime);
      expect(guideSpots[0].audioUrl, 'test');
    });
  });
}
