import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  final Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  Future<Map<String, dynamic>> get(String url) async {
    debugPrint('GET $url');

    final response = await http.get(Uri.parse(url), headers: headers);
    // debugPrint('GET $url: ${response.statusCode}');
    // debugPrint('GET $url: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to load data: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    debugPrint('POST $url');
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
    // debugPrint('POST $url: ${response.statusCode}');
    // debugPrint('POST $url: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to post data: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<File?> getFile({required String url}) async {
    final tempDir = await Directory.systemTemp.createTemp('audio_temp');

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final file = File('${tempDir.path}/temp.mp3');
      await file.writeAsBytes(bytes);
      return file;
    }
    return null;
  }
}
