import 'package:flutter/material.dart';
import 'package:link_dance/components/widgets/imagem_avatar_component.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/functions/dialog_functions.dart';

import 'package:link_dance/core/helpers/constantes_images.dart';
import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/features/event/ticket/event_ticket_model.dart';
import 'package:provider/provider.dart';

class TicketDetailComponent extends StatelessWidget {
  Function() onCloseCallBack;
  EventTicketModel eventTicket;
  late EventHelper eventHelper;

  TicketDetailComponent(
      {required this.onCloseCallBack, required this.eventTicket});

  Widget bodyTicket() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Row(children: [
            const Text("Nome: "),
            Text(eventTicket.userName),
          ]),
          Row(children: [
            const Text("Evento: "),
            Text(eventTicket.eventTitle),
          ]),
          Row(children: [
            const Text("Local: "),
            Text(eventTicket.eventPlace),
          ]),
          Row(children: [
            const Text("Data evento: "),
            Text(eventTicket.eventDate.showString()),
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthenticationFacate>(context, listen: false).user!;
    eventHelper = EventHelper.ctx(context: context);

    return AlertDialog(
      title: Center(child: const Text("Ingresso")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageAvatarComponent(
            readOnly: true,
            imageUrl: user!.photoUrl,
            imageLocal: ConstantsImagens.defaultAvatar,
          ),
          const Text("Dados do evento "),
          sizedBox15(),
          bodyTicket()
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCloseCallBack();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
          child: const Text(
            "Fechar",
            style: TextStyle(color: Colors.black),
          ),
        ),
        sizedBoxH15(),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  eventTicket.isValid
                      ? Colors.green[400]!
                      : Colors.grey[400]!)),
          onPressed: eventTicket.isValid
              ? () {
                  eventHelper
                      .checkInTicket(ticketId: eventTicket.id)
                      .then((value) => showSuccess(context))
                      .catchError((onError,trace) {
                        print("Erro ao fazer checkin app $onError | $trace");
                        showError(context);
                  });
                  onCloseCallBack();
                }
              : null,
          child: const Text("Confirmar"),
        )
      ],
    );
  }
}
