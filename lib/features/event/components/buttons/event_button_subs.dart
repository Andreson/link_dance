import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:link_dance/features/event/dto/event_ticket_dto.dart';
import 'package:link_dance/features/event/ticket/event_ticket_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:provider/provider.dart';

class EventButtonSubscription extends StatelessWidget {

  Function({Object? onError})? onPressed;
  EventModel event;
  late BuildContext _context;

  late UserModel _user;
  late EventHelper _eventHelper;

  EventButtonSubscription(
      { this.onPressed, required this.event});

  @override
  Widget build(BuildContext context) {
    _context = context;
    _user = Provider.of<AuthenticationFacate>(context, listen: false).user!;
    _eventHelper = EventHelper.ctx(context: context);

    String  title="";
    if (event.hasList()) {
      title = "Pegar meu vip";
    } else {
      title = "Inscrever-se";
    }

    return _buildButton(
      onPressed: subscribe,
      text:
          Text(title, style: const TextStyle(color: Colors.blue, fontSize: 14)),
      buttonBackgroud: Colors.white,
      icon: const Icon(FontAwesomeIcons.check, color: Colors.blue, size: 14),
    );
  }

  void subscribe() async {

    _eventHelper.subscribeEvent(eventTicketParam: EventTicketDTO(eventId: event.id, userId: _user.id)).catchError((onError){
      print("Ocorreu um erro ao se inscrever no evento $onError");
      showError(_context);
      if (onPressed != null) onPressed!(onError: onError);
    });
    if (onPressed != null) onPressed!( );
  }

  Widget _buildButton(
      {required Function() onPressed,
      required Text text,
      required Color buttonBackgroud,
      required Icon icon}) {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      width: 150,
      child: TextButton.icon(
          icon: icon,
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsets.zero,
              ),
              minimumSize: MaterialStateProperty.all(Size(50, 30)),
              shadowColor: MaterialStateProperty.all<Color>(Colors.black),
              elevation: MaterialStateProperty.all(5),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.white30))),
              backgroundColor: MaterialStateProperty.all(buttonBackgroud)),
          onPressed: onPressed,
          label: text),
    );
  }
}
