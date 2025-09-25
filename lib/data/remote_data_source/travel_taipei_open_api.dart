import 'package:flutter/material.dart';
import 'package:funday_flutter_interview/fund/api_handler.dart';
import 'package:http/http.dart' as http;

class TravelTaipeiOpenApi {
  final String _baseUrl = 'https://www.travel.taipei/open-api';
  final ApiHandler _apiHandler = ApiHandler();
  Future<List> getGuideSpots({
    required String lang,
    required int page,
  }) async {
    final String path = '/$lang/Media/Audio?page=$page';
    final url = '$_baseUrl$path';
    debugPrint('calling api: $url');

    final response = await _apiHandler.get(url);
    return [];
  }
}
