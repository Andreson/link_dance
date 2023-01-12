import 'dart:convert';

import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/exceptions.dart';
import 'package:link_dance/model/login_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'auth_base.dart';

class GoogleAuthentication extends BaseAuthentication {
  @override
  Future<UserModel> signup(UserModel user) async {
        return _signup();
  }

  @override
  Future<UserModel> login(String? login, String? password) async {
    return _signup();
  }

  Future<UserModel> _signup() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    var userCredential =await FirebaseAuth.instance.signInWithCredential(credential);
    try {
      var usermodel=  parseFireBaseUserToUserModel(userCredential: userCredential, loginProvider: LoginProvider.google);
      return usermodel;
    } on FirebaseAuthException {
      throw AuthenticationFailException("Ocorreu um erro ao realizar login google ");
    } catch (exception) {

      print("Error ############### $exception");
      throw AuthenticationFailException(
          "Ocorreu um erro ao realizar login google ");
    }
  }

  @override
  Future<void> logout() async {
    super.logout();
  }
}
