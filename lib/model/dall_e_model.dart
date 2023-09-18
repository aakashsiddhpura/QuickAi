/// model
class DallEImageData {
  final int created;
  final List<DallEImage> data;

  DallEImageData({
    required this.created,
    required this.data,
  });

  factory DallEImageData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonData = json['data'];

    List<DallEImage> images = jsonData.map((item) {
      return DallEImage.fromJson(item);
    }).toList();

    return DallEImageData(
      created: json['created'],
      data: images,
    );
  }
}

class DallEImage {
  final String url;

  DallEImage({
    required this.url,
  });

  factory DallEImage.fromJson(Map<String, dynamic> json) {
    return DallEImage(
      url: json['url'],
    );
  }
}