import 'dart:io';

import 'package:funday_flutter_interview/fund/api_handler.dart';

class DownloadAudioFromUrlUsecase {
  ApiHandler apiHandler;
  DownloadAudioFromUrlUsecase({ApiHandler? apiHandler})
    : apiHandler = apiHandler ?? ApiHandler();
  Future<File?> call({required String url}) async {
    return await apiHandler.getFile(url: url);
  }
}
