import 'dart:async';
import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_base.dart';

class EmailAuthentication extends BaseAuthentication {
  AuthenticationFacate auth;

  EmailAuthentication({required this.auth});

  @override
  Future<UserModel> signup(UserModel user) async {
    var l = user.login!;

    return authenticate(l.email, l.password ?? "", Constants.authUrl('signUp'))
        .then((value) => UserModel(login: value));
  }

  @override
  Future<UserModel> login(String? login, String? password) async {

    return  await authenticate(login!, password! , Constants.authUrl('signInWithPassword'))
        .then((value) => UserModel(login: value, email: login));

  }

  @override
  Future<void> logout() async {
    super.logout();
  }
}
