import 'dart:convert';

import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/model/abastract_model.dart';

class EventTicketModel extends AbastractModel {
  final String _id;
  String eventId;
  String eventTitle;
  String eventPlace;
  DateTime eventDate;
  String linkerId;
  String linkerName;
  String userId;
  String userName;
  GenderType userGender;
  EventListType type;
  bool wasUse;
  bool isValid;

  @override
  String get id => _id;

  EventTicketModel(
      {String id = "",
      required this.eventId,
      required this.eventPlace,
      required this.eventTitle,
      required this.eventDate,
      required this.linkerId,
      required this.linkerName,
      required this.userId,
      required this.userName,
      required this.userGender,
      required this.type,
      required this.wasUse,
      required this.isValid})
      : _id = id;

  @override
  Map<String, dynamic> body() {
    return {
      "id": id,
      "eventId": eventId,
      "eventTitle": eventTitle,
      "eventDate": eventDate,
      "linkerId": linkerId,
      "linkerName": linkerName,
      "userId": userId,
      "userName": userName,
      "userGender": userGender,
      "wasUse": wasUse,
      "isValid": isValid,
      "eventPlace":eventPlace
    };
  }

  static EventTicketModel fromJson(Map<String, dynamic> json) {
    return EventTicketModel(
        id: json['id'],
        eventId: json['eventId'],
        eventPlace: json['eventPlace'],
        eventTitle: json['eventTitle'],
        eventDate: json['eventDate'].toString().parse(),
        linkerId: json['linkerId'] ?? "",
        //TODO avalidar necessidade desse dado no registro
        linkerName: json['linkerName'] ?? "",
        userId: json['userId'],
        userName: json['userName'],
        userGender: GenderType.values.byName(json['userGender']),
        wasUse: json['wasUse'],
        isValid: json['isValid'],
        type: EventListType.values.byName(json['type']));
  }

  @override
  String toString() {
    return 'EventTicketModel{eventTitle: $eventTitle, eventPlace: $eventPlace, eventDate: $eventDate, userId: $userId, userName: $userName, type: $type, wasUse: $wasUse, isValid: $isValid}';
  }
}
