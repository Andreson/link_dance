import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:provider/provider.dart';

class EventButtonSubscription extends StatelessWidget {

  Function(Object onError)? onPressed;
  EventModel event;
  late BuildContext context;
  late EventRepository eventRepository;
  late String title;
  EventButtonSubscription(
      { this.onPressed, required this.event});

  @override
  Widget build(BuildContext context) {
    this.context = context;
    eventRepository = Provider.of<EventRepository>(context, listen: false);

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
    //TODO, ALTERAR ESSA CHAMADA PARA CHAMAR A API DE CRIAÇÃO DE EVENTO
    var userEvent = await eventRepository
        .subscribeEvent(event: event)
        .catchError((onError) {
      print("Ocorreu um erro ao atualizar status inscrição no evento $onError");
      showError(context);
      if (onPressed != null) onPressed!(onError);
    });

  }

  Widget _buildButton(
      {required Function() onPressed,
      required Text text,
      required Color buttonBackgroud,
      required Icon icon}) {
    return SizedBox(
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
