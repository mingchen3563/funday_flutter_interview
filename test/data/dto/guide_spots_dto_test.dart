import 'package:flutter_test/flutter_test.dart';
import 'package:funday_flutter_interview/data/dto/guide_spots_dto.dart';

void main() {
  // "id": 27,
  //     "title": "臺北市立動物園",
  //     "summary": null,
  //     "url": "https://www.travel.taipei/audio/27",
  //     "file_ext": null,
  //     "modified": "2024-11-15 13:35:09 +08:00"
  group('guide spots dto ...', () {
    final Map<String, Object?> exampleJson = {
      'id': 27,
      'title': '臺北市立動物園',
      'summary': null,
      'url': 'https://www.travel.taipei/audio/27',
      'file_ext': null,
      'modified': '2024-11-15 13:35:09 +08:00',
    };
    test('fromJson', () async {
      final dto = GuideSpotsDto.fromJson(exampleJson);
      expect(dto.id, 27);
      expect(dto.title, '臺北市立動物園');
      expect(dto.summary, null);
      expect(dto.url, 'https://www.travel.taipei/audio/27');
      expect(dto.fileExt, null);
      expect(dto.modified, DateTime.utc(2024, 11, 15, 5, 35, 9));
    });
  });
}
