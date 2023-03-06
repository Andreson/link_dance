

import 'package:flutter/cupertino.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:link_dance/features/user/dto/user_response_dto.dart';
import 'package:provider/provider.dart';

class UserHelper {
  late AuthenticationFacate auth;
  late RestTemplate _restTemplate;
  UserHelper({required BuildContext context}) {
      auth = Provider.of<AuthenticationFacate>(context, listen: false);
    _restTemplate = RestTemplate(auth: auth);
  }

  //Valida se o casdastro do usuario esta valido
  Future<UserResponseDTO> checkCompleteRegistration({String? userId}) async {

    var userIdParam =userId ?? auth.user!.id;
    var respose = await _restTemplate
        .get(
        targetFirebase: false,
        url:
        "${ConstantsAPI.eventApi}/user/$userIdParam/check")
        .catchError((onError, trace) {
      print(" ----  Erro checkCompleteRegistration $onError || $trace");
      throw onError;
    });

    return UserResponseDTO.map(data: respose.data,httpResponse: respose);
  }

}