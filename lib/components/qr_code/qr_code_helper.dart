import 'package:flutter/cupertino.dart';

import 'package:link_dance/features/event/dto/event_ticket_dto.dart';
import 'package:link_dance/features/event/dto/user_event_ticket_dto.dart';
import 'package:link_dance/features/event/event_helper.dart';

class QrCodeEventTicketHelper {
  
  late final EventHelper _client;

  QrCodeEventTicketHelper({required BuildContext context}):_client =EventHelper.ctx(context: context) ;
       

  Future<UserEventTicketResponseDTO> getEventTicket(
      {required EventTicketDTO requestParam}) async {
      return await _client.getEventTicketAvailable(eventId: requestParam.eventId).catchError((onError,trace) {
        print(" ----  Erro ao buscar ticket disponivel $onError || $trace");
        throw onError;
      } );
  }

}
