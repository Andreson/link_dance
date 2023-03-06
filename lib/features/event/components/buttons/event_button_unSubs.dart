import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/utils/dialog_functions.dart';
import 'package:link_dance/features/event/dto/event_ticket_dto.dart';
import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/features/event/model/event_ticket_model.dart';
import 'package:link_dance/model/user_event_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:provider/provider.dart';

class EventButtonUnSubscription extends StatelessWidget {
  Function({Object? onError})? onPressed;

  late BuildContext _context;
  Function()? showQrCode;
  late UserModel _user;
  late EventHelper _eventHelper;
  EventTicketModel? eventTicket;
  UserEventModel userEvent;
  bool showConfirmDialog;

  EventButtonUnSubscription(
      {this.onPressed,
      this.showQrCode,
      this.showConfirmDialog = true,
      this.eventTicket,
      required this.userEvent});

  @override
  Widget build(BuildContext context) {
    _context = context;
    _user = Provider.of<AuthenticationFacate>(context, listen: false).user!;
    _eventHelper = EventHelper.ctx(context: context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: _buildButton(context),
        ),
        if (showQrCode != null)
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

  void unSubscribe(BuildContext context) async {
    showConfirm(context,
        content:
            "Você esta cancelando a sua inscrição no evento. Isso irá cancelar qualquer VIP ou desconto que você tenha obtido."
                "\nDeseja prosseguir?",
        confirmAction: () {
          Navigator.of(context).pop();
          _callAPI(context);
        });
  }

  Future<void> _callAPI(BuildContext context) async {
    onLoading(context);
    _eventHelper
        .unSubscribeEvent(ticketId: eventTicket?.id, userEvent: userEvent.id)
        .catchError((onError) {
      Navigator.of(context).pop();
      print("Ocorreu um erro ao atualizar status inscrição no evento $onError");
      showError(_context);
      if (onPressed != null) onPressed!(onError: onError);
    }).then((value) {
      Navigator.of(context).pop();
      if (onPressed != null) onPressed!();
    });
  }

  Widget _buildButton(BuildContext context) {
    Text text = const Text("Inscrito",
        style: TextStyle(color: Colors.white, fontSize: 14));
    Color buttonBackgroud = Colors.blue;
    Icon icon =
        const Icon(FontAwesomeIcons.checkDouble, color: Colors.white, size: 14);

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
                      side: const BorderSide(color: Colors.white30))),
              backgroundColor: MaterialStateProperty.all(buttonBackgroud)),
          onPressed: () => unSubscribe(context),
          label: text),
    );
  }
}
