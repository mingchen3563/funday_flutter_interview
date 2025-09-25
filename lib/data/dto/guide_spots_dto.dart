import 'package:funday_flutter_interview/fund/extensions/map_extension.dart';

class GuideSpotsDto {
  final int id;
  final String title;
  final String? summary;
  final String url;
  final String? fileExt;
  final DateTime modified;

  GuideSpotsDto({
    required this.id,
    required this.title,
    this.summary,
    required this.url,
    this.fileExt,
    required this.modified,
  });

  factory GuideSpotsDto.fromJson(Map<String, dynamic> json) {
    try {
      return GuideSpotsDto(
        id: json.getOrElse('id', 0),
        title: json.getOrElse('title', ''),
        summary: json.getOrElse('summary', null),
        url: json.getOrElse('url', ''),
        fileExt: json.getOrElse('file_ext', null),
        modified: DateTime.parse(json.getOrElse('modified', '')),
      );
    } catch (e) {
      throw Exception('Failed to decode response body: $e');
    }
  }
}
