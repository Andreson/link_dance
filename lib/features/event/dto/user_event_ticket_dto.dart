import 'package:link_dance/features/event/ticket/event_ticket_model.dart';
import 'package:link_dance/model/user_event_model.dart';

class UserEventTicketResponseDTO {

    EventTicketModel? eventTicket;
   UserEventModel? userEvent;

  UserEventTicketResponseDTO({required this.eventTicket,required this.userEvent});
  UserEventTicketResponseDTO.map({required Map<String,dynamic> data}){
    _build(data:data);
  }

  void _build({required Map<String, dynamic> data}) {

    if ( data['data'] !=null) {
      eventTicket=  EventTicketModel.fromJson(data['data']['ticket']);
    }
    if ( data['data']!=null) {
      userEvent =  UserEventModel.fromJson(data['data']['userEvent']);
    }
  }

    @override
  String toString() {
    return 'UserEventTicketResponseDTO{eventTicket: $eventTicket, userEvent: $userEvent}';
  }
}
