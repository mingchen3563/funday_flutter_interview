import 'package:flutter_test/flutter_test.dart';
import 'package:funday_flutter_interview/data/dto/guide_spots_dto.dart';
import 'package:funday_flutter_interview/data/mapper/guide_spot_mapper.dart';

void main() {
  group('guide spot mapper ...', () {
    final dto = GuideSpotsDto(
      id: 1,
      title: 'test',
      modified: DateTime.now(),
      url: 'test',
    );
    test('fromDto', () {
      final guideSpot = GuideSpotMapper.fromDto(dto);
      expect(guideSpot.title, dto.title);
      expect(guideSpot.modifiedDate, dto.modified);
      expect(guideSpot.audioUrl, dto.url);
    });
  });
}
