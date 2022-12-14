import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/model/abastract_model.dart';
import 'package:flutter/material.dart';

class TeacherModel extends AbastractModel  {
  late final String _name;
  String id;
  String? photo;
  String? thumbPhoto;
  String description;
  Map<String,String>? contacts;
  String? nickname;
  final List<String> danceRhythms;
  List<String>? storageRef;
  String userId;
  AccountStatus? status = AccountStatus.disable;

  String get name=>_name.trim().capitalizePhrase(allWord: true);

  set name(String name) => _name = name;

  TeacherModel(
      {required name,
      required this.description,
      required this.danceRhythms,
        this.thumbPhoto,
        this.storageRef,
      this.photo,
      this.contacts,
      this.nickname,
      this.id="",
      this.status,
      required this.userId }): _name= name;

  Widget get photoAvatar {
    if (photo != null && photo!.isNotEmpty) {
      return Image.network(photo!);
    } else {
      return Image.asset("assets/images/perfil.png");
    }
  }

  static TeacherModel fromJson(Map<String, dynamic> json, String id) {

    return TeacherModel(
        id: id,
        name: json['name'],
        photo: json['photo'],
        thumbPhoto: json['photo'],
        storageRef: json['storageRef'],
        contacts: json['contacts']?.cast<String,String>(),
        description: json['description'],
        nickname: json['nickname'],
        userId: json['userId'],
        danceRhythms: json['danceRhythms'].cast<String>(),
        status: AccountStatus.values.byName(json['status'] ?? "disable"  ));
  }

  Map<String, dynamic> body() {
    return {
      "id": id,
      "name": name,
      "nickname":nickname,
      "description": description,
      "contacts": contacts,
      "userId": userId,
      "photo": photo,
      "danceRhythms": danceRhythms,
      "status": status?.name()
    };
  }
}
