class GuideSpotsDto {
  // "id": 27,
  //     "title": "臺北市立動物園",
  //     "summary": null,
  //     "url": "https://www.travel.taipei/audio/27",
  //     "file_ext": null,
  //     "modified": "2024-11-15 13:35:09 +08:00"
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
    return GuideSpotsDto(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      url: json['url'],
      fileExt: json['file_ext'],
      modified: DateTime.parse(json['modified']),
    );
  }
}
