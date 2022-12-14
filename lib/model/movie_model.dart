import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/model/abastract_model.dart';
import '../core/extensions/string_extensions.dart.dart';

class MovieModel extends AbastractModel {
  String _id;
  String uri;
  String? thumb;
  String ownerId;
  String? description;
  DateTime createDate;
  String rhythm;
  String? fingerPrint;
  String? contentGroupId;
  String? contentGroupLabel;
  List<String>? storageRef;
  bool public;

  MovieModel(
      {required this.uri,
      required this.rhythm,
      required this.ownerId,
        this.public=true,
      this.contentGroupLabel,
      this.contentGroupId,
      this.storageRef,
      this.fingerPrint,
      this.thumb,
      id = "",
      required this.createDate,
      this.description = "Passo de Dança"})
      : _id = id;

  String? getYoutubeCode() {
    return MovieModel.youtubeCode(urlMovie: uri);
  }

  static String? youtubeCode({required String urlMovie}) {

    if ( urlMovie==null)
      return null;
    if (!urlMovie.startsWith("https://yout")) {
      return null;
    }
    if (!urlMovie.contains("=v")) {
      var index = urlMovie.lastIndexOf("/");
      return urlMovie.substring(index + 1, urlMovie.length);
    }
    var indexInit = urlMovie.indexOf("v=") + 2;
    var indexEnd = urlMovie.indexOf("&", indexInit);
    indexEnd = indexEnd > 0 ? indexEnd : urlMovie.length;
    return urlMovie.substring(indexInit, indexEnd);
  }

  static MovieModel fromJson(Map<String, dynamic> json, String id) {
    var createDate = DateTime.now();
    if (json['createDate'] != null) {
      createDate = (json['createDate'] as Timestamp).toDate();
    }

    var m =  MovieModel(
        id: id,
        uri: json['uri'],
        contentGroupId: json['contentGroupId'],
        ownerId: json['ownerId'],
        thumb: json['thumb'],

        public: json['public'],
        description: json['description']?.toString()?.capitalizePhrase(),
        fingerPrint: json['fingerPrint'],
        rhythm: json['rhythm'],
        contentGroupLabel: json['contentGroupLabel'],
        createDate: createDate);

    return m;
  }

  //work around por causa das frescuras do null safe do dart
  factory MovieModel.New() {
    return MovieModel(
        id: "",
        uri: "",
        ownerId: "",
        description: "",
        rhythm: "",
        fingerPrint: "",
        createDate: DateTime.now());
  }

  String get id => _id;

  @override
  Map<String, dynamic> body() {
    return {
      "contentGroupId": contentGroupId,
      "uri": uri,
      "public":public,
      "contentGroupLabel": contentGroupLabel,
      "thumb": thumb,
      "ownerId": ownerId,
      "description": description?.toLowerCase(),
      "rhythm": rhythm,
      "fingerPrint": fingerPrint,
      "storageRef": storageRef,
      "createDate": Timestamp.now()
    };
  }


  @override
  String toString() {
    return 'MovieModel{id: $id, ownerId: $ownerId, description: $description, uri: $uri}';
  }
}
