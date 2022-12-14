class ImagemModel {
  String url;
  String thumb;
  List<String> storageRef;

  ImagemModel(
      {required this.url, required this.thumb, required this.storageRef});

  Map<String, dynamic> body() {
    return {"url": url, "thumb": thumb, "storageRef": storageRef};
  }

  static ImagemModel fromJson(Map<String, dynamic> json) {
    return ImagemModel(
        url: json['url'],
        thumb: json['thumb'],
        storageRef: json['storageRef']?.cast<String>());
  }
}
