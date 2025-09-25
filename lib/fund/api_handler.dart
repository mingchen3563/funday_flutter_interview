import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  Future<Map<String, dynamic>> get(String url) async {
    debugPrint('GET $url');

    final response = await http.get(Uri.parse(url));
    debugPrint('GET $url: ${response.statusCode}');
    debugPrint('GET $url: ${response.body}');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    debugPrint('POST $url');
    final response = await http.post(Uri.parse(url), body: body);
    debugPrint('POST $url: ${response.statusCode}');
    debugPrint('POST $url: ${response.body}');
    return jsonDecode(response.body);
  }
}
