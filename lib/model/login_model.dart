import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/authentication/auth_base.dart';

import 'abastract_model.dart';


class LoginModel extends AbastractModel  {
  String token;
  String? refreshtoken;
  String email;
  String? password;
  @deprecated
  String? uid;
  String? _id;
  DateTime? expiryDate;
  LoginProvider loginProvider;

  LoginModel(
      {required this.token,
      required this.email,
      required this.loginProvider,
        this.password,
      this.uid,
        id="",
      this.refreshtoken,
      this.expiryDate}):_id=id! ;

  @override
  String get id=> _id!;

  @override
  String toString() {
    return 'LoginModel{token: $token, email: $email, uid: $uid, expiryDate: $expiryDate}';
  }

  void setToken(TokenRefresh token, {LoginProvider loginProvider= LoginProvider.email}) {
      refreshtoken = token.refreshToken;
      this.token = token.idToken;
      expiryDate = DateTime.now().add(Duration(seconds: token.expires));
      this.loginProvider= loginProvider;
  }


  @override
  static LoginModel json(Map<String, dynamic> json){
         var temp = json['expiryDate'].toString();
    var expires = temp==null ? DateTime.parse(json['expiryDate']) : DateTime.now().add(Duration(days: 360));
    return LoginModel(
      token: json['token'],
      email: json['email'],
      password: json['password'],
      loginProvider: LoginProvider.values.byName(json['loginProvider']),
      refreshtoken: json['refreshtoken'],
      expiryDate: expires,
    );
  }

  @override
  LoginModel fromJson(Map<String, dynamic> json, String id) {
    var temp = json['expiryDate'].toString();
    var expires = temp==null ? DateTime.parse(json['expiryDate']) : DateTime.now().add(Duration(days: 360));
    return LoginModel(
      id: id,
      token: json['token'],
      email: json['email'],
      password: json['password'],
      loginProvider: LoginProvider.values.byName(json['loginProvider']),
      refreshtoken: json['refreshtoken'],
      expiryDate: expires,
    );
  }

  factory LoginModel.New({String? token}) {
    return LoginModel(
        token: token ?? "",
        email: "",
        password:"",
        uid: "",
        loginProvider: LoginProvider.email,
        refreshtoken: "",
        expiryDate: null);
  }

  @override
  Map<String, dynamic> body() {
    return {
      "token": token ,
      "email": email,
      "id": id,
      "password": password,
      "loginProvider": loginProvider,
      "refreshtoken": refreshtoken,
      "expiryDate": expiryDate
    };
  }




}
