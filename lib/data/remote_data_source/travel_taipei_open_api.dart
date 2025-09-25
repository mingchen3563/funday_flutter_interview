import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:funday_flutter_interview/data/dto/guide_spots_dto.dart';
import 'package:funday_flutter_interview/fund/api_handler.dart';

class TravelTaipeiOpenApi {
  final String _baseUrl = 'https://www.travel.taipei/open-api';
  TravelTaipeiOpenApi({ApiHandler? apiHandler})
    : _apiHandler = apiHandler ?? ApiHandler();
  final ApiHandler _apiHandler;
  Future<List<GuideSpotsDto>> getGuideSpots({
    required String lang,
    required int page,
  }) async {
    final String path = '/$lang/Media/Audio?page=$page';
    final url = '$_baseUrl$path';
    debugPrint('calling api: $url');

    final Map<String, dynamic> response = await _apiHandler.get(url);

    try {
      final List<dynamic> data = response['data'];
      debugPrint('data: $data');
      return data.map((e) => GuideSpotsDto.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to decode response body: $e');
    }
  }
}
