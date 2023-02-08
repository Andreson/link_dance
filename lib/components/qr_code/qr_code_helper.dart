import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:link_dance/features/event/ticket/event_ticket_model.dart';
import 'package:link_dance/features/event/ticket/event_ticket_repository.dart';

class QrCodeEventTicketHelper {
  late final AuthenticationFacate _auth;
  late final EventTicketRepository _client;

  QrCodeEventTicketHelper({required AuthenticationFacate auth})
      : _auth = auth,
        _client = EventTicketRepository(auth: auth);

  Future<EventTicketModel> getEventTicket(
      {required EventTicketDTO requestParam}) async {
    return _client.getEventTicket(requestParam: requestParam);
  }
}
