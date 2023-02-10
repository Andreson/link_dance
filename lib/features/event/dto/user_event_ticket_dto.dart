

import 'package:link_dance/features/event/ticket/event_ticket_model.dart';
import 'package:link_dance/model/user_event_model.dart';

class UserEventTickeResponseDTO {

  late EventTicketModel eventTicket;
  late UserEventModel userEvent;

  UserEventTickeResponseDTO({required this.eventTicket,required this.userEvent});

  UserEventTickeResponseDTO.map({required Map<String,dynamic> data}){
    _build(data:data);
  }

  void _build({required Map<String, dynamic> data}) {
    eventTicket=  EventTicketModel.fromJson(data['data']['ticket']);
    userEvent =  UserEventModel.fromJson(data['data']['userEvent']);
  }



}