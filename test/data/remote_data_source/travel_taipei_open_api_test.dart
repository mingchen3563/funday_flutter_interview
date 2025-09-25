import 'package:flutter_test/flutter_test.dart';
import 'package:funday_flutter_interview/data/remote_data_source/travel_taipei_open_api.dart';
import 'package:funday_flutter_interview/fund/api_handler.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'example_json.dart';
import 'travel_taipei_open_api_test.mocks.dart';

@GenerateMocks([ApiHandler])
void main() {
  late ApiHandler apiHandler;
  late TravelTaipeiOpenApi travelTaipeiOpenApi;
  setUpAll(() {
    apiHandler = MockApiHandler();
    travelTaipeiOpenApi = TravelTaipeiOpenApi(apiHandler: apiHandler);
  });
  group('travel taipei open api ...', () {
    final Map<String, dynamic> exampleJson = {
      'total': 130,
      'data': [
        {
          'id': 27,
          'title': '臺北市立動物園',
          'summary': null,
          'url': 'https://www.travel.taipei/audio/27',
          'file_ext': null,
          'modified': '2024-11-15 13:35:09 +08:00',
        },
        {
          'id': 30,
          'title': '陽明公園',
          'summary': null,
          'url': 'https://www.travel.taipei/audio/30',
          'file_ext': null,
          'modified': '2024-11-15 13:35:05 +08:00',
        },
      ],
    };
    test('getGuideSpots', () async {
      when(
        apiHandler.get(
          'https://www.travel.taipei/open-api/zh-tw/Media/Audio?page=1',
        ),
      ).thenAnswer((_) async => exampleGuideSpotsJson);
      final guideSpots = await travelTaipeiOpenApi.getGuideSpots(
        lang: 'zh-tw',
        page: 1,
      );
      expect(guideSpots.length, 1);
    });
  });
}
