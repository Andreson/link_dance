import 'dart:convert';
import 'dart:developer';
import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/features/authentication/auth_base.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../exception/exceptions.dart';

class RestTemplate {

  AuthenticationFacate auth;

  RestTemplate({required this.auth});



  Future<Map<String, dynamic>> Patch({required Object body,required String url, Map<String, String>? headers,Encoding? encoding}) async {
    String token=auth.user!.login!.token;
    url = "$url&auth=$token";
    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    );
    debugPrint("URL chamada $url");
    if (response.statusCode>=300) {
      print("Error Response post  call  ${response.statusCode}");


      throw HttpException(response);
    }
    if (response.body == 'null') return {};
    return jsonDecode(response.body);
  }


  Future<Map<String, dynamic>> Post({required Object body,required String url, Map<String, String>? headers,Encoding? encoding}) async {
    debugPrint("Body request ${jsonEncode(body)}");
    String token=auth.user!.login!.token;
    url = "$url&auth=$token";
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
        encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    );
    if (response.statusCode>=300) {
      print("Error Response post  call  ${response.statusCode}");
      debugPrint("URL chamada $url");

      debugPrint("Headers request $headers");

      throw HttpException(response);
    }
    if (response.body == 'null') return {};
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> Get({required String url, Map<String, String>? headers,Encoding? encoding}) async {

    // if ( auth.user!=null) {
    //   url = await refresthToken(url: url);
    // }

    String token=auth.user!.login!.token;
    url = "$url&auth=$token";
    debugPrint(url);
    final response = await http.get(
      Uri.parse(url),
    );


    if (response.statusCode>=300) {
      print("Error get call  ${response.body}");
      throw  HttpException(response);
    }
    if (response.body == 'null') return {};
    return jsonDecode(response.body);
  }


  Future<String> _refresthToken({required String url}) async{
    LoginModel loginModel = auth.user!.login!;
    TokenRefresh? tr;
    if ( loginModel.loginProvider==LoginProvider.email) {
      tr = await auth.authentication.refreshTokenIfExpired(
          token: loginModel.token,
          tokenRefresh: loginModel.refreshtoken ?? "");
    }

    if ( tr==null) {
      url = "$url&auth=${loginModel.token}";
    }else {
      url = "$url&auth=${tr.accessToken}";
      auth.user?.login?.refreshtoken =tr.refreshToken;
      auth.user?.login?.token =tr.accessToken;
    }
    return url;
  }


}

