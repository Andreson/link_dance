import 'package:flutter/material.dart';
import 'package:link_dance/components/widgets/imagem_avatar_component.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';

import 'package:link_dance/core/helpers/constantes_images.dart';
import 'package:provider/provider.dart';

class TicketDetailComponent extends StatelessWidget {

   Function() onClose;

   TicketDetailComponent({required  this.onClose});
   late AuthenticationFacate auth;
  @override
  Widget build(BuildContext context) {


    return AlertDialog(
      title: const Text("Ingresso"),
      content: Column(children: [
        ImageAvatarComponent(
          readOnly: true,
          imageLocal: ConstantsImagens.defaultAvatar,
        )
      ]),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onClose();
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onClose();
          },
          child: const Text("Confirmar"),
        )
      ],
    );
  }



}
