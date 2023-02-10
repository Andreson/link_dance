import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/model/abastract_model.dart';


class UserEventModel extends AbastractModel {
  String id;
  String userId;
  String eventId;
  String userPhone;
  String? userEmail;
  EventRegisterStatus status;
  Timestamp createDate;

  UserEventModel(
      {required this.userId,
      required this.eventId,
      required this.userPhone,
      required this.userEmail,
      required this.status,
      required this.createDate,
      this.id=""});

  @override
  Map<String, dynamic> body() {
    return {
      "userId": userId,
      "eventId": eventId,
      "userPhone": userPhone,
      "userEmail": userEmail,
      "status": status.name,
      "createDate": createDate,
    };
  }


  static UserEventModel fromJson(Map<String, dynamic> json) {
    return UserEventModel(
        id: json['id'] ?? "",
        userId: json['userId'],
        eventId: json['eventId'],
        userEmail: json['userEmail'],
        userPhone: json['userPhone'],
        status: EventRegisterStatus.values.byName(json['status'] ?? "unsubscribe"),
        createDate: json['createDate'].toString().toTimestamp() );
  }

  @override
  String toString() {
    return 'UserEventModel{id: $id, userId: $userId, eventId: $eventId, status: $status, createDate: $createDate}';
  }
}

