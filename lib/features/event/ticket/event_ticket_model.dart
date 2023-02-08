import 'dart:convert';

import 'package:link_dance/core/dynamic_links/dynamic_links_helper.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/helpers/constants_api.dart';
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
        linkerId: json['linkerId'],
        linkerName: json['linkerName'],
        userId: json['userId'],
        userName: json['userName'],
        userGender: GenderType.values.byName(json['userGender']),
        wasUse: json['wasUse'],
        isValid: json['isValid'],
        type: EventListType.values.byName(json['type']));
  }
}

class EventTicketDTO {
  String ticketId;
  String eventId;
  String userId;
  String promoterId;

  static const String _ticketName = "ditic";
  static const String _eventName = "edi";
  static const String _userName = "usdi";
  static const String _promoterName = "dipr";

  EventTicketDTO({
    this.ticketId = "",
    this.eventId = "",
    this.userId = "",
    this.promoterId = "",
  });

  //Recebe os dados da URL, transforma e decodifica os parametros para a chamada da API
  //os nomes dos paraemtros foram alterados na geração do code para dificultar chamadas indesejadas
  static EventTicketDTO parseToModel({required String queryParam}) {
    var temp = DynamicLinkHelper.queryToMap(params: queryParam)['eventCode'];
    var decodeStr = utf8.decode(base64.decode(temp));
    var mapParam = DynamicLinkHelper.queryToMap(params: decodeStr)['eventCode'];

    return EventTicketDTO(
        eventId: mapParam[_eventName],
        userId: mapParam[_userName],
        ticketId: mapParam[_ticketName],
        promoterId: mapParam[_promoterName]);
  }

  String rawBase64() {
    var temp = DynamicLinkHelper.mapToQuery(params: body());
    var urlStr = "${ConstantsAPI.fakeUrl}$temp";
    return base64.encode(utf8.encode(urlStr));
  }

  @override
  String toString() {
    return 'EventTicketDTO{ticketId: $ticketId, eventId: $eventId, userId: $userId, promoterId: $promoterId}';
  }

  Map<String, dynamic> body() {
    return {
      "ticketId": ticketId,
      "eventId": eventId,
      "userId": userId,
      "promoterId": promoterId,
    };
  }
}
