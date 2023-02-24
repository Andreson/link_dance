import 'dart:convert';

import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/http_exceptions.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:link_dance/model/login_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

abstract class BaseAuthentication with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  String? _email;
  String? _uid;
  DateTime? _expiryDate;

  Future<void> logout() async {
    _cleanAuthData();
  }

  Future<UserModel> signup(UserModel user);

  Future<UserModel> login(String? login, String? password);

  void _cleanAuthData() {
    _token = null;
    _uid = null;
    _email = null;
    _refreshToken = null;
    _expiryDate = DateTime.now();
  }

  Future<TokenRefresh?> refreshTokenIfExpired(
      {required String token, required String tokenRefresh}) async {
    if (tokenRefresh.isEmpty) {
      throw AuthenticationRuntimException("REFRESH_TOKEN_ERROR");
    }

    if (tokenExpired(jtwToken: token)) {
      debugPrint(
          "Token expirado, tentando renovar token ------------------------------");
      return refreshToken(tokenRefresh);
    }
    return null;
  }

  bool tokenExpired({required String jtwToken}) {
    return JwtDecoder.isExpired(jtwToken);
  }

  Future<TokenRefresh> refreshToken(String refreshToken) async {
    var bodyRequest = {
      "grant_type": "refresh_token",
      "refresh_token": refreshToken
    };

    final dio = Dio();
    final res = await dio.post(
      ConstantsAPI.refreshToken,
      data: bodyRequest,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (res.statusCode! > 300) {
      throw HttpException(res.data);
    }
    var response = res.data;
    return TokenRefresh(
        expires: int.parse(response['expires_in']),
        refreshToken: response['refresh_token'],
        idToken: response['id_token'],
        accessToken: response['access_token']);
  }

  Future<UserModel> parseFireBaseUserToUserModel(
      {required LoginProvider loginProvider,
      required UserCredential userCredential}) async {
    var token = await FirebaseAuth.instance.currentUser!.getIdTokenResult(true);
    var tempUser = userCredential.user;

    var login = LoginModel(
        loginProvider: loginProvider,
        token: token.token ?? "",
        expiryDate: token.expirationTime,
        email: userCredential.user!.email ?? "");
    return UserModel(
        userType: UserType.student,
        email: userCredential.user!.email,
        name: userCredential.user!.displayName,
        phone: userCredential.user!.phoneNumber ?? "",
        photoUrl: userCredential.user!.photoURL,
        login: login);
  }

  String? get token => isAuth ? _token : null;

  String? get email => isAuth ? _email : null;

  String? get uid => isAuth ? _uid : null;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  @deprecated
  Future<LoginModel> authenticate(
      String email, String password, String url) async {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final body = jsonDecode(response.body);
    if (body['error'] != null) {
      var message = body['error']['message'];

      if (message.toString().contains("TOO_MANY_ATTEMPTS_TRY_LATER")) {
        throw AuthenticationRuntimException("TOO_MANY_ATTEMPTS_TRY_LATER");
      }
      if (message.toString().contains("EMAIL_EXISTS")) {
        throw AuthenticationUserExistsException("Usuario já existe!");
      }

      throw AuthenticationRuntimException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _uid = body['localId'];
      _refreshToken = body['refreshToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );
      notifyListeners();
      return LoginModel(
          email: _email!,
          expiryDate: _expiryDate!,
          token: _token!,
          uid: _uid!,
          refreshtoken: _refreshToken,
          loginProvider: LoginProvider.email);
    }
  }
}

class TokenRefresh {
  /**
   *  tempo de expiração em segundos
   */
  int expires;
  String refreshToken;
  String idToken;
  String accessToken;

  TokenRefresh(
      {required this.expires,
      required this.refreshToken,
      required this.idToken,
      required this.accessToken});
}


