import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:link_dance/features/event/dto/event_ticket_dto.dart';
import 'package:link_dance/features/event/ticket/event_ticket_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:provider/provider.dart';

class EventButtonSubscription extends StatelessWidget {
  Function({Object? onError, EventTicketResponseDTO? data})? onPressed;
  EventModel event;
  late BuildContext _context;

  late UserModel _user;
  late EventHelper _eventHelper;

  EventButtonSubscription({this.onPressed, required this.event});

  @override
  Widget build(BuildContext context) {
    _context = context;
    _user = Provider.of<AuthenticationFacate>(context, listen: false).user!;
    _eventHelper = EventHelper.ctx(context: context);

    Map<String,dynamic> textAndIcon  = configButtons();
    return _buildButton(
      onPressed: () => subscribe(context),
      text: textAndIcon['text'],
      buttonBackgroud: Colors.white,
      icon: textAndIcon['icon'],
    );
  }

  Future<void> subscribe(BuildContext context) async {
    onLoading(context);
    _eventHelper
        .subscribeEvent(
            eventTicketParam:
                EventTicketDTO(eventId: event.id, userId: _user.id))
        .catchError((onError, trace) {
      print("Erro ao se inscrever no evento $onError | $trace");
      Navigator.of(context).pop();
      if (onPressed != null) onPressed!(onError: onError);
    }).then((value) {
      Navigator.of(context).pop();
      if (onPressed != null) onPressed!(data: value);
    });
  }

  Widget _buildButton(
      {required Function() onPressed,
      required Text text,
      required Color buttonBackgroud,
      required Icon icon}) {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      width: 160,
      child: TextButton.icon(
          icon: icon,
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsets.zero,
              ),
              minimumSize: MaterialStateProperty.all(const Size(50, 30)),
              shadowColor: MaterialStateProperty.all<Color>(Colors.black),
              elevation: MaterialStateProperty.all(5),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: const BorderSide(color: Colors.white30))),
              backgroundColor: MaterialStateProperty.all(buttonBackgroud)),
          onPressed: event.allowsToSubscribe() ? onPressed : null,
          label: text),
    );
  }

  Map<String, Widget> configButtons() {
    final IconData? icon;
    String title = "";
    if (event.hasList()) {
      if (!event.allowsToSubscribe()) {
        title = "Lista encerrada";
      } else {

        title = "Pegar meu ${event.listData!.listType.label}";
      }
    } else {
      title = "Eu vou";
    }
    Color buttonColor;
    if (!event.allowsToSubscribe()) {
      buttonColor = Colors.grey;
      icon = Icons.pin_end_outlined;
    } else {
      buttonColor = Colors.blue;
      icon = FontAwesomeIcons.check;
    }
    return {
      "text":Text(title, style: TextStyle(color: buttonColor, fontSize: 13)),
      "icon":Icon(icon, color: buttonColor, size: 14)
    };
  }
}
