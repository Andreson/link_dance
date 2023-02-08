import 'dart:convert';

import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/exceptions.dart';
import 'package:link_dance/model/login_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'auth_base.dart';

class FacebookAuthentication extends BaseAuthentication {
  @override
  Future<UserModel> signup(UserModel user) async {

    return  UserModel.Mock();


  }

  @override
  Future<UserModel> login(String? login, String? password) async {
    return UserModel.Mock();

  }

  @override
  Future<void> logout() async {
    super.logout();
  }
}
