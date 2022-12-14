import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/model/abastract_model.dart';

class UserFollowTeacherModel extends AbastractModel  {
  String id;
  String userId;
  String teacherId;
  String userPhone;
  String? userEmail;
  FollowStatusStatus status;
  Timestamp? createDate;

  UserFollowTeacherModel(
      {required this.userId,
      required this.teacherId,
        required this.userPhone,
        required this.userEmail,
      required this.status,
        this.createDate,
      this.id=""});

  @override
  Map<String, dynamic> body() {
    return {
      "userId": userId,
      "teacherId": teacherId,
      "userPhone": userPhone,
      "userEmail": userEmail,
      "status": status.name,
      "createDate": createDate,
    };
  }

  static UserFollowTeacherModel fromJson(Map<String, dynamic> json, String id) {

    return UserFollowTeacherModel(
      id: id,
      userId: json['userId'],
        teacherId: json['teacherId'],
      userEmail: json['userEmail'],
      userPhone: json['userPhone'],
      status:FollowStatusStatus.values.byName(json['status']) ,
      createDate: json['createDate']);
  }

  @override
  String toString() {
    return 'UserEventModel{id: $id, userId: $userId, teacherId: $teacherId, status: $status, createDate: $createDate}';
  }
}

