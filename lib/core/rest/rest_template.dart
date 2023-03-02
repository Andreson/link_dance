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
    return postCallConfig(responseParam: response);
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
    return postCallConfig(responseParam: response);
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
    return postCallConfig(responseParam: response);
  }


  Future<ResponseDTO> get(
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

    var temp =postCallConfig(responseParam: response);

    return ResponseDTO(httpStatus: temp['httpStatus'], data: temp['data']);

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

    return postCallConfig(responseParam: response);
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

  Map<String, dynamic> postCallConfig({required http.Response responseParam}) {
    Map<String, dynamic> response = {};
    if ( responseParam.statusCode>460 && responseParam.statusCode<499){
      throw HttpBussinessException(response: responseParam);
    }
    if (responseParam.statusCode >= 300) {
      throw HttpException(responseParam);
    }
    var responseData =   jsonDecode( utf8.decode(responseParam.bodyBytes));
    response['httpStatus']  = responseParam.statusCode;
    response['data']  = responseData;

    return response;
  }



}

class ResponseDTO {
  int httpStatus;
  Map<String, dynamic>? _data ;

  Map<String, dynamic> get data=> _data ??{};

  ResponseDTO({required this.httpStatus,required Map<String, dynamic>? data}):_data = data;

  bool hasData() {
    return _data!=null && data!.isNotEmpty!;
  }
}
