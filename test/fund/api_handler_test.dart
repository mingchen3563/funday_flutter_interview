import 'package:flutter_test/flutter_test.dart';
import 'package:funday_flutter_interview/fund/api_handler.dart';

void main() {
  group('api handler ...', () {
    test('get', () async {
      final apiHandler = ApiHandler();
      final String path =
          'https://www.travel.taipei/open-api/zh-tw/Media/Audio?page=1';
      final response = await apiHandler.get(path);
      expect(response, isNotEmpty);
    });
  });
}
