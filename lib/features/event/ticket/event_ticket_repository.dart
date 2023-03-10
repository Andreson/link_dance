

import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:link_dance/features/event/dto/event_ticket_dto.dart';
import 'package:link_dance/features/event/model/event_ticket_model.dart';

class EventTicketRepository {

  late final AuthenticationFacate _auth;
  late final RestTemplate _client;

  EventTicketRepository({required AuthenticationFacate auth})
      : _auth = auth,
        _client = RestTemplate(auth: auth);

  Future<EventTicketResponseDTO> getEventTicket(
      {required EventTicketDTO requestParam}) async {


    var resp = await _client.get(
        url: "${ConstantsAPI.eventApi}/event/ticket",
        headers: {"Authorization": _auth.getToken()!});
    return EventTicketResponseDTO.map(data: resp.data);
  }

  Future<EventTicketModel> deleteEventTicket(
      {required EventTicketDTO requestParam}) async {
    var resp = await _client.get(
        url: "${ConstantsAPI.eventApi}/event/ticket",
        headers: {"Authorization": _auth.getToken()!});
    return EventTicketModel.fromJson(resp.data);
  }
}