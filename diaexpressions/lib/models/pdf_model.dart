class PdfModel {
  final String name;
  final String fileName;
  final String url;

  PdfModel({
    required this.name,
    required this.fileName,
    required this.url,
  });

  factory PdfModel.fromJson(Map<String, dynamic> json) {
    return PdfModel(
      name: json['name'] as String? ?? '',
      fileName: json['file_name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'file_name': fileName,
      'url': url,
    };
  }
}
