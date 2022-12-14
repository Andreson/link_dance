import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/model/abastract_model.dart';

class ContentUserAcessModel extends AbastractModel {
  String id;
  String userId;
  String contentGroupId;
  Timestamp createDate;

  ContentUserAcessModel(
      {required this.id,
      required this.userId,
      required this.contentGroupId,
      required this.createDate});

  static ContentUserAcessModel fromJson(Map<String, dynamic> json, String id) {
    return ContentUserAcessModel(
        id: json['id'],
        userId: json['userId'],
        contentGroupId: json['contentGroupId'],
        createDate: json['createDate']);
  }


  @override
  Map<String, dynamic> body() {
    return {
        "userId": userId,
        "contentGroupId": contentGroupId,
        "createDate": createDate};
  }
}
