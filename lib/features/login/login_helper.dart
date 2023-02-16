

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/exceptions.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:link_dance/core/functions/dialog_functions.dart';
class LoginHelper {

  BuildContext context;

  LoginHelper({required this.context});

  void tryAutoLogin() async {

    var authentication = Provider.of<AuthenticationFacate>(context, listen: false);
    var userData =
    await authentication.retrieveUserAuthData().catchError((onError) {
        //throw onError;
    });
    if (userData != null) {
      Navigator.pushNamed(context, RoutesPages.home.name, arguments: userData);
    }
  }


  Future<void> login(
      {required LoginProvider loginProvider,
      String username = "",
      String password = ""}) async {
    var authentication =
    Provider.of<AuthenticationFacate>(context, listen: false);

    onLoading(context);
    authentication
        .login(
        loginProvider: loginProvider, username: username, password: password)
        .then((userData) {
      Navigator.of(context).pop();

      if (userData != null && userData.email != null) {
        authentication.user = userData;

        FirebaseCrashlytics.instance.setUserIdentifier(userData.email!);

        Navigator.pushNamed(context, RoutesPages.home.name,
            arguments: userData);
      }else {
        Navigator.pushNamed(context, RoutesPages.registration.name,
            arguments: userData);
      }
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      print("trace error $stackTrace");
      _loginCatchError(error, context, loginProvider);
    }).catchError((onError,trace) {
      Navigator.of(context).pop();
      print("trace error $trace");
      _loginCatchError(onError, context, loginProvider);
    });
  }

  _loginCatchError(error, BuildContext context, LoginProvider loginProvider) {
    if (error is AuthenticationRuntimException) {
      showError(
        context,
        content: error.toString(),
      );
    } else if (error is AuthenticationFailException) {
      //caso o usuario volte na tela de login do Provider, ira gerar um erro, que nao precisa mostrar popup
      print("-------------------Erro de autenticação $error");
    } else {
      showError(
        context,
        content: _msgError(loginProvider.name),
      );
    }
  }

  String _msgError(String loginProvider) {
    return "Ocorreu algo nao esperado ao tentar fazer login via $loginProvider!"
        " Por favor, verifique os dados informados e tente novamente.";
  }

}