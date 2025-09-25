import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:funday_flutter_interview/domain/usecase/download_audio_from_url_usecase.dart';
import 'package:funday_flutter_interview/fund/api_handler.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../data/remote_data_source/travel_taipei_open_api_test.mocks.dart';

@GenerateMocks([ApiHandler])
void main() {
  late ApiHandler apiHandler;
  late DownloadAudioFromUrlUsecase downloadAudioFromUrlUsecase;
  setUpAll(() {
    apiHandler = MockApiHandler();
    downloadAudioFromUrlUsecase = DownloadAudioFromUrlUsecase(
      apiHandler: apiHandler,
    );
  });
  test('download audio from url usecase ...', () async {
    when(
      apiHandler.getFile(url: 'https://www.travel.taipei/audio/27'),
    ).thenAnswer((_) async => File('assets/audio/27.mp3'));
    final file = await downloadAudioFromUrlUsecase.call(
      url: 'https://www.travel.taipei/audio/27',
    );
    expect(file, isNotNull);
    expect(file?.path, isNotEmpty);
  });
}
