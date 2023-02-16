import 'package:link_dance/components/input_fields/mail_field.dart';
import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:link_dance/core/exception/exceptions.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/functions/dialog_functions.dart';

import 'package:link_dance/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ResetPasswordComponent extends StatelessWidget {
  late UserRepository userRepository;
  void Function()?  onComplete;
  final BuildContext context;
  ResetPasswordComponent(this.context);

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context, listen: false);

    return _buildPopupPasswordRecovery(context);
  }

  final _recoveryEmailController = TextEditingController();

  Widget _buildPopupPasswordRecovery(BuildContext context) {
    return AlertDialog(
      title: const Text('Recuperar Senha'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MailInputField(label: "Email", controller: _recoveryEmailController)
        ],
      ),
      actions: <Widget>[
        Row(
    mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Center(
              child: CustomTextButton(
                params:
                    CustomTextButtonParams(fontSize: 14, height: 35, width: 100),
                label: "Enviar",
                onPressed: () {
                  Navigator.of(context).pop();

                  _resetPass(_recoveryEmailController.text).then((value) {
                      showConfirm();
                  }).catchError((onError) {
                          throw onError;
                  });


                  //
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Center(
                child: CustomTextButton(
              params:
                  CustomTextButtonParams(fontSize: 14, height: 35, width: 100),
              onPressed: () {
                Navigator.of(context).pop();
              },
              label: 'Fechar',
            )),
          )
        ])
      ],
    );
  }

  void showConfirm() {

    showInfo(
        title: "Solicitação enviada com sucesso.",
        context: context,
        onPressed:() {
          Navigator.of(context).pop();
        },
        content:
            "Você recebera um email para recuperação da senha em até 5 minutos.");
  }

  Future<void> _resetPass(String email) async {
    onLoading(context);
    // var userRegistry = await userRepository
    //     .findUserByEmail(UserModel(email: email))
    //     .catchError((onError) {
    //   print("Ocorreu um erro ao verificar se o usuário ja existe");
    // });

    //nao me julgue!
    if (true) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
      throw UserNotFoundException(
          "Não foi encontrado nenhum cadastro para o email $email");
    }
  }
}
