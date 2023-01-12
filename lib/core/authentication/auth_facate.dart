import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/exceptions.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:link_dance/core/authentication/auth_base.dart';
import 'package:link_dance/core/authentication/auth_email.dart';
import 'package:link_dance/core/authentication/auth_facebook.dart';
import 'package:link_dance/core/authentication/auth_google.dart';
import 'package:link_dance/model/login_model.dart';
import 'package:link_dance/model/teacher_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/local_store_repository.dart';
import 'package:link_dance/repository/teacher_repository.dart';
import 'package:link_dance/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../core/extensions/string_extensions.dart.dart';

class AuthenticationFacate with ChangeNotifier {
  UserModel? user;
  late BaseAuthentication authentication;
  late UserRepository userRepository;

  late TeacherRepository teacherRepository;

  AuthenticationFacate() {
    userRepository = UserRepository(auth: this);
    teacherRepository = TeacherRepository(auth: this);
  }

  Future<UserModel?> login(
      {required LoginProvider loginProvider,
      String? username,
      String? password}) async {
    username = username?.trim();
    if (username != null) {
      //impede a tentativa de renovar o token caso seja um novo login
      var userModel = await _logar(loginProvider, username, password);
      if (userModel?.userType == UserType.professor) {
        var teacherProfile = await _getTeacherProfile(userId: userModel!.id);
        userModel.teacherProfile = teacherProfile;
      }
      user =userModel;
      return userModel;
    }
    return retrieveUserAuthData().then((userModel) async {
      if (userModel == null) {
        userModel = await _logar(loginProvider, username, password);
        if (userModel?.userType == UserType.professor) {
          userModel?.teacherProfile =
              await _getTeacherProfile(userId: userModel.id);
        }
        return userModel;
      } else {
        return userModel;
      }
    });
  }

  Future<TeacherModel?> _getTeacherProfile({required String userId}) async {
    return await teacherRepository.findByUserId(userId: userId);
    //  return TeacherModel(danceRhythms: [],description: "",id:"-NBoYtBVGmGPMNulrvvz",name: "",userId: "-NB-Gt8CnxYp-sHRK0gb");
  }

  LoginModel? getLogin() {
    return user?.login;
  }

  Future<UserModel?> _logar(
      LoginProvider loginProvider, String? username, String? password) async {
    authentication = _buildAuthType(loginProvider);

    user =
        await authentication.login(username, password).catchError((onError) {
      print("onError in _logar facate ${onError}");
      throw AuthenticationRuntimException(onError.code);
    });

    if (user == null || user!.login == null) {
      throw Exception("Erro ao recuperar usuario durante a autenticação  ");
    }
    var dataUserApp = await userRepository.findUserByEmail(user!);
    if(dataUserApp==null) {
      user!.userType = UserType.aluno;
      await userRepository.createUser(user!);
    }else {
      user = user!.enrich(dataUserApp);
    }

    _writeUserAuthData(user!);
    return user;

  }

  void _writeUserAuthData(UserModel dataUserLogin) {
    print(
        " dataUserLogin.login?.loginProvider.name ${dataUserLogin.login?.loginProvider.name}");

    LocalStoreRepository.saveMap(Constants.userAuthData, {
      "email": dataUserLogin.email,
      "id": dataUserLogin.id,
      "token": dataUserLogin.login?.token,
      "refreshtoken": dataUserLogin.login?.refreshtoken,
      "expiryDate": dataUserLogin.login?.expiryDate?.toIso8601String(),
      "loginProvider": dataUserLogin.login?.loginProvider.name,
      "name": dataUserLogin.name,
      "email": dataUserLogin.email,
      "userType": dataUserLogin.userType.toString().split('.').last,
      "postalCode": dataUserLogin.postalCode,
      "phone": dataUserLogin.phone,
      "birthDate": dataUserLogin.birthDate,
      "photoUrl": dataUserLogin.photoUrl,
      "password": dataUserLogin.login?.password ?? "",
    });
  }

  void _clearUserAuthData() {
    LocalStoreRepository.remove(Constants.userAuthData);
  }

  /**
   * Retorna os dados gravados do ultimo login realizado, sem que tenha sido efetuado o logout
   */
  Future<UserModel?> retrieveUserAuthData() async {
    return await LocalStoreRepository.getMap(Constants.userAuthData)
        .then((data) async {
      if (data.isNotEmpty) {
        user = UserModel.build(data, data['id']);

        if (user?.userType == UserType.professor) {
          user?.teacherProfile =await _getTeacherProfile(userId: user!.id);
        }
        authentication = _buildAuthType(user!.login!.loginProvider);
        var login = user?.login;
        // if (login?.loginProvider == LoginProvider.email) {
        //   TokenRefresh token =
        //       await authentication.refreshToken(login!.refreshtoken!);
        //   String? tokenStr =
        //       await FirebaseAuth.instance.currentUser?.getIdToken(true);
        //   user?.login?.setToken(token);
        // } else {
        // erro login google aconteceu uma vez aqui
          String? token =
              await FirebaseAuth.instance.currentUser?.getIdToken(true);
          user?.login?.token = token!;
        //}
        //  notifyListeners();
        return user;
      } else {
        return null;
      }
    }).onError((error, stackTrace) {
      print("Erro ao fazer autologin ${error}");
      print("stackTrace ${stackTrace}");
      //  _clearUserAuthData();
    });
  }

  Future<void> logout() async {
    user = null;
    await FirebaseAuth.instance.signOut();
    _clearUserAuthData();
    //authentication.logout();
  }

  Future<UserModel?> signup(UserModel user) async {
    authentication = _buildAuthType(user.login?.loginProvider ?? LoginProvider.email);
    user.login =
        (await
        authentication.signup(user))
            .login;

    this.user = user;

    await userRepository.createUser(this.user!).catchError((onError) {
      throw onError;
    });
    return this.user;
  }

  BaseAuthentication _buildAuthType(LoginProvider loginProvider) {
    switch (loginProvider) {
      case LoginProvider.email:
        return EmailAuthentication(auth: this);
        break;
      case LoginProvider.facebook:
        return FacebookAuthentication();
        break;
      case LoginProvider.google:
        return GoogleAuthentication();
        break;
      default:
        return EmailAuthentication(auth: this);
    }
  }
}
