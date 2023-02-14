import 'dart:convert';

import 'package:link_dance/core/dynamic_links/dynamic_links_helper.dart';
import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/features/event/ticket/event_ticket_model.dart';

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
    var temp = DynamicLinkHelper.queryToMap(params: queryParam)['ticket'];
    print("key base64 decode $temp");
    var decodeStr = utf8.decode(base64.decode(temp));
    var mapParam = DynamicLinkHelper.queryToMap(params: decodeStr);

    return EventTicketDTO(
        eventId: mapParam[_eventName],
        userId: mapParam[_userName],
        ticketId: mapParam[_ticketName],
        promoterId: mapParam[_promoterName]);
  }

  String rawBase64() {
    var temp = DynamicLinkHelper.mapToQuery(params: _shuffle());
    temp = base64.encode(utf8.encode(temp));
    var urlStr = "${ConstantsAPI.fakeUrl}?ticket=$temp";
    return urlStr;
  }

  @override
  String toString() {
    return 'EventTicketDTO{ticketId: $ticketId, eventId: $eventId, userId: $userId, promoterId: $promoterId}';
  }

  Map<String, dynamic> _shuffle() {
    return {
      _ticketName: ticketId,
      _eventName: eventId,
      _userName: userId,
      _promoterName: promoterId,
    };
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

class EventTicketRequestDTO {
  EventTicketDTO ticket;

  EventTicketRequestDTO(this.ticket);

  EventTicketRequestDTO.ticket(
      {required String eventId, required String userId})
      : ticket = EventTicketDTO(userId: userId, eventId: eventId);

  Map<String, dynamic> body() {
    return {"ticket": ticket.body()};
  }
}

class EventTicketResponseDTO {
  late String message;
  bool? hasTicket;
  late int httpStatus;
  EventTicketModel? ticket;

  EventTicketResponseDTO(
      {required this.message,
      required this.hasTicket,
      this.ticket,
      required this.httpStatus});

  EventTicketResponseDTO.map({required Map<String, dynamic> data}) {
    message = data['message'];
    hasTicket = data['data'] != null ? data['data']['hasTicket'] : null;
    httpStatus = data['httpStatus'];
    if (data['data'] != null && data['data']['ticket']!=null) {
      ticket = EventTicketModel.fromJson(data['data']['ticket']);
    }
  }

  @override
  String toString() {
    return 'EventTicketResponseDTO{message: $message, hasTicket: $hasTicket, httpStatus: $httpStatus}';
  }
}
