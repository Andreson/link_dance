

import 'package:link_dance/core/rest/rest_template.dart';

class UserResponseDTO {

  late String message;
  late List<dynamic> errors;
  late UserDTO userDTO;
  late ResponseDTO httpResponse;

  UserResponseDTO.map({required Map<String,dynamic> data,required this.httpResponse }){
    _build(data:data);
  }

  bool hasError() {
    return httpResponse.httpStatus>300;
  }

  bool hasBussinessError() {
    return httpResponse.bussinessException!=null;
  }

  void _build({required Map<String, dynamic> data}) {
    message = data['message'] ??"";
    errors = data['erros'] ?? [];
    if (data['data'] != null && data['data']['user']!=null) {
      userDTO = UserDTO.fromJson(data['data']['user']);
    }

  }

}

class UserDTO {

  bool  completeRegistration;
  UserDTO({required this.completeRegistration});

  static UserDTO fromJson(Map<String, dynamic> json) {
    return UserDTO(completeRegistration: json['completeRegistration']=='true');
  }

  Map<String, dynamic>  body() {
    return  {"completeRegistration": completeRegistration};
  }

}