import 'package:link_dance/core/constants.dart';
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
    var response = await restTemplate.Post(
        body: user.body(), url: "${Constants.userDbUrl}.json?");

    user.id = response['name']; //recupera ID gerado pelo realtime database
    print("User ID return ${user.id}");
    return user;
  }

  Future<UserModel?> update(UserModel user) async {
    var response = await restTemplate.Patch(
      body: user.deserialize(),
      url: "${Constants.userDbUrl}/${user.id}.json?",
    );

    user.id = response['id']; //recupera ID gerado pelo realtime database
    print("User ID return ${user.id}");
    return user;
  }

  Future<UserModel?> findUserByEmail(UserModel user) async {

    return restTemplate.Get(
            url:
                "${Constants.userDbUrl}.json?orderBy=\"email\"&equalTo=\"${user.email}\"")
        .then((response) {
      if (response.values.isNotEmpty) {
        return UserModel.fromJson(response.values.first, response.keys.first);
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
