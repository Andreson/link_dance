import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/authentication/auth_base.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../exception/http_exceptions.dart';

class RestTemplate {
  AuthenticationFacate auth;

  RestTemplate({required this.auth});

  Future<Map<String, dynamic>> patch(
      {   Object? body,
      required String url,
      Map<String, String>? headers,
        bool targetFirebase=false,
      Encoding? encoding}) async {

    var config = await preCallConfig(
        headers: headers, url: url, targetFiresbase: targetFirebase);
    url = config['url'];
    headers = config['header'];

    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    );
    return postCallConfig(response: response);
  }

  Future<Map<String, dynamic>> put(
      {  required Object body,
        required String url,
        Map<String, String>? headers,
        bool targetFirebase=false,
        Encoding? encoding}) async {

    var config = await preCallConfig(
        headers: headers, url: url, targetFiresbase: targetFirebase);
    url = config['url'];
    headers = config['header'];

    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    );
    return postCallConfig(response: response);
  }

  Future<Map<String, dynamic>> post(
      {required Object body,
      required String url,
      Map<String, String>? headers,
      Encoding? encoding,
      bool targetFirebase = false}) async {
    var config = await preCallConfig(
        headers: headers, url: url, targetFiresbase: targetFirebase);
    url = config['url'];
    headers = config['header'];
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    );
    return postCallConfig(response: response);
  }


  Future<Map<String, dynamic>> get(
      {required String url,
      Map<String, String>? headers,
      Encoding? encoding,
      bool targetFirebase = false}) async {
    var config =await preCallConfig(
        headers: headers, url: url, targetFiresbase: targetFirebase);
    url = config['url'];
    headers = config['header'];
    final response = await http.get(
      headers: headers,
      Uri.parse(url),
    );

    return postCallConfig(response: response);
  }

  Future<Map<String, dynamic>> delete(
      {Object? body,
      required String url,
      Map<String, String>? headers,
      Encoding? encoding,
      bool targetFirebase = false}) async {

    var config = await preCallConfig(
        headers: headers, url: url, targetFiresbase: targetFirebase);
    url = config['url'];
    headers = config['header'];
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    );

    return postCallConfig(response: response);
  }

  Future<String> _refreshToken( ) async {
    LoginModel loginModel = auth.user!.login!;
    if ( JwtDecoder.isExpired(loginModel.token) ) {
      String? tokenStr =
      await FirebaseAuth.instance.currentUser?.getIdToken(true);
      if ( tokenStr==null) {
        throw AuthenticationRuntimException("REFRESH_TOKEN_ERROR");
      }

      auth.user?.login?.refreshtoken = tokenStr;
      auth.user?.login?.token = tokenStr!;
      return tokenStr;
    }
    return loginModel.token;
  }

 Future<Map<String, dynamic>> preCallConfig(
      {required Map<String, String>? headers,
      required String url,
      required bool targetFiresbase}) async {

   String token = auth.user!.login!.token;
   if (!targetFiresbase) {
      token = await _refreshToken( );
    }
    headers ??= {};
    debugPrint(url);
    if (targetFiresbase) {
      url = "$url&auth=$token";
    } else {
      headers!['Authorization'] = token;
    }
    return {"url": url, "header": headers};
  }

  Map<String, dynamic> postCallConfig({required http.Response response}) {

    if ( response.statusCode>460 && response.statusCode<499){
      throw HttpBussinessException(response: response);
    }
    if (response.statusCode >= 300) {
      throw HttpException(response);
    }
    if (response.body == 'null') return {};

    var responseData =   jsonDecode( utf8.decode(response.bodyBytes));
    responseData['httpStatus']  = response.statusCode;
    return responseData;
  }



}
