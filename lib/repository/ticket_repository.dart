

import 'package:link_dance/model/ticket_event.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'dart:convert';

class TicketRepository extends BaseRepository<TicketEventModel> {




  Future<void> save({required TicketEventModel  ticket}) {
    ticket.checkSum = checkSum(ticket: ticket);
    ticket.createDate = DateTime.now();
    return super.saveSimple(data: ticket.body());
  }

  String checkSum({required TicketEventModel ticket}){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode("${ticket.eventId}${ticket.userId}${ticket.userEventOwnerId}");
  }

}