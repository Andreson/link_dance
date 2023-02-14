import 'package:flutter/cupertino.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:link_dance/features/event/dto/event_ticket_dto.dart';
import 'package:link_dance/features/event/dto/user_event_ticket_dto.dart';
import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/features/event/ticket/event_ticket_model.dart';
import 'package:link_dance/features/event/ticket/event_ticket_repository.dart';

class QrCodeEventTicketHelper {
  
  late final EventHelper _client;

  QrCodeEventTicketHelper({required BuildContext context}):_client =EventHelper.ctx(context: context) ;
       

  Future<UserEventTicketResponseDTO> getEventTicket(
      {required EventTicketDTO requestParam}) async {
    return await _client.getEventTicket(eventId: requestParam.eventId);
  }

}
