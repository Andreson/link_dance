
import 'dart:convert';

import 'package:http/http.dart' as http;
class AuthenticationFailException implements Exception{
  String cause;

  AuthenticationFailException(this.cause);
}

class NotImplementedException implements Exception{
  String cause;
  NotImplementedException(this.cause);

  @override
  String toString() {
    return 'NotImplementedException{cause: $cause}';
  }
}

class InvalidFormException implements Exception{
  String cause;
  InvalidFormException(this.cause);

  @override
  String toString() {
    return 'NotImplementedException{cause: $cause}';
  }
}

class AuthenticationUserExistsException implements Exception{
  String cause;
  AuthenticationUserExistsException(this.cause);
}

class UserNotFoundException implements Exception{
  String cause;
  UserNotFoundException(this.cause);
}


class HttpException implements Exception {
  http.Response cause;
  late int statusCode;
  HttpException(this.cause):statusCode = cause.statusCode;
}

class HttpBussinessException implements Exception {
  http.Response cause;
  late int statusCode;
  late String message;
  HttpBussinessException({required this.cause}){
    var mapData = jsonDecode( utf8.decode(cause.bodyBytes));
    message =mapData['message'] ??"Ocorreu um erro nao esperado.";
    statusCode = cause.statusCode;
  }
}



/**
 * Exception para tratar erros esperados durante a autenticação
 */
class AuthenticationRuntimException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Você informou as credenciais incorretas muitas vezes seguidas. Seu login foi  bloqueado temporariamente.Você pode resetar a sua senha ou tente mais tarde.',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado.',
    'INVALID_PASSWORD': 'Senha informada não incorreta.',
    "invalid-email":"Formato de email  inválido",
    "user-not-found": "Cadastro de usuario não encontrado. Voces ja possui cadastro ?",
    'USER_DISABLED': 'A conta do usuário foi desabilitada.',
    "wrong-password": "Usuário ou senha inválidos. Favor verificar os dados do login e tentar novamente. ",
    "REFRESH_TOKEN_ERROR": "Ocorreu um erro ao renovar seu token de login.Por favor, saia do app e entre novamente."
  };

  final String key;

  AuthenticationRuntimException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro nao esperando durante a  autenticação.';
  }
}
