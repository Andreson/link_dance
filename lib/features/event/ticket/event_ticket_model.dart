import 'dart:convert';


import 'package:link_dance/core/enumerate.dart';

import 'package:link_dance/model/abastract_model.dart';

class EventTicketModel extends AbastractModel {
  final String _id;
  String eventId;
  String eventTitle;
  String eventDate;
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
      "isValid": isValid
    };
  }

  static EventTicketModel fromJson(Map<String, dynamic> json) {
    return EventTicketModel(
        id: json['id'],
        eventId: json['eventId'],
        eventTitle: json['eventTitle'],
        eventDate: json['eventDate'],
        linkerId: json['linkerId'] ??"", //TODO avalidar necessidade desse dado no registro
        linkerName: json['linkerName']??"",
        userId: json['userId'],
        userName: json['userName'],
        userGender: GenderType.values.byName(json['userGender']),
        wasUse: json['wasUse'],
        isValid: json['isValid'],
        type: EventListType.values.byName(json['type']));
  }
}

