import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:link_dance/core/authentication/auth_email.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/base_repository.dart';

import '../model/login_model.dart';

class UserRepository extends BaseRepository<UserModel> {
  late EmailAuthentication emailAuth;

  AuthenticationFacate auth;

  UserRepository({required this.auth}) {
    emailAuth = EmailAuthentication(auth: auth);
    restTemplate = RestTemplate(auth: auth);
  }

  Future<UserModel?> createUser(UserModel user) async {
    var response = await restTemplate.post(targetFirebase: true,
        body: user.body(), url: "${ConstantsAPI.userDbUrl}.json?");

    user.id = response['name']; //recupera ID gerado pelo realtime database
    print("User ID return ${user.id}");
    return user;
  }

  Future<UserModel?> update(UserModel user) async {
    var response = await restTemplate.patch(
      body: user.deserialize(),
      url: "${ConstantsAPI.userDbUrl}/${user.id}.json?",
    );

    user.id = response['id']; //recupera ID gerado pelo realtime database
    print("User ID return ${user.id}");
    return user;
  }

  Future<UserModel?> findUserByEmail(UserModel user) async {

    return restTemplate.get(targetFirebase: true,
            url:
                "${ConstantsAPI.userDbUrl}.json?orderBy=\"email\"&equalTo=\"${user.email}\"")
        .then((response) {
      if (response.hasData()) {
        return UserModel.fromJson(response.mapEntity());
      } else {
        return null;
      }
    });
  }

  factory UserRepository.New() {
    return UserRepository(auth: AuthenticationFacate());
  }

  LoginModel? get login => auth.getLogin();
}
