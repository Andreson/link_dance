import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:link_dance/model/user_event_model.dart';
import 'package:provider/provider.dart';

class EventButtonUnSubscription extends StatelessWidget {

  Function(Object onError)? onPressed;
  EventModel event;
  late BuildContext context;
  late EventRepository eventRepository;
  Function()? showQrCode;

  EventButtonUnSubscription({ this.onPressed, this.showQrCode, required this.event});

  @override
  Widget build(BuildContext context) {
    this.context = context;
    eventRepository = Provider.of<EventRepository>(context, listen: false);



    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: _buildButton(),
        ),
        if (showQrCode!=null)
          Row(
            children: [
              TextButton.icon(
                onPressed: showQrCode,
                icon: const Icon(FontAwesomeIcons.qrcode),
                label: const Text("Ingresso"),
              ),
            ],
          )
      ],
    );
  }

  void unSubscribe() async {
    //TODO, ALTERAR ESSA CHAMADA PARA CHAMAR A API DE CRIAÇÃO DE EVENTO

    await eventRepository
        .unsubscribeEvent(userEvent: UserEventModel(userId: "userId", eventId: "eventId", userPhone: "", userEmail: "", status: EventRegisterStatus.subscribe, createDate: Timestamp.now() )!)
        .catchError((onError) {
      print("Ocorreu um erro ao atualizar status inscrição no evento $onError");
      showError(context);
      if (onPressed != null) onPressed!(onError);
    });



  }

  Widget _buildButton() {
    Text text = const Text(
        "Inscrito", style: TextStyle(color: Colors.white, fontSize: 14));
    Color buttonBackgroud = Colors.blue;
    Icon icon = const Icon(
        FontAwesomeIcons.checkDouble, color: Colors.white, size: 14);

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
          onPressed: unSubscribe,
          label: text),
    );
  }
}
