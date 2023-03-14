import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/helpers/constantes_images.dart';
import 'package:link_dance/model/abastract_model.dart';
import 'package:link_dance/model/imagem_model.dart';
import 'package:link_dance/model/login_model.dart';
import 'package:link_dance/model/teacher_model.dart';
import 'package:flutter/material.dart';

class UserModel extends AbastractModel {
  //user ID for authentication
  String id;
  String name;
  String email;
  String? phone;
  String? birthDate;
  String? postalCode;

  UserType userType;
  LoginModel? login;
  ImagemModel? image;
  GenderType? gender;
  TeacherModel? teacherProfile;
  bool completeRegistration=false;

  String get photoUrl =>image==null? ConstantsImagens.defaultAvatar: image!.url;


  String emailKey() {
    return email!.replaceAll(".", "").replaceAll("@", "");
  }

  String userTypeLabel() {
    if (userType == UserType.student) {
      return "Dançudis";
    } else {
      return userType!.name().toString();
    }
  }

  UserModel(
      {this.id = "",
        this.gender,
        this.completeRegistration=false,
        this.image,
      this.login,
    required  this.name,
        required this.email,
      this.teacherProfile,
      this.phone,
      this.birthDate,
      this.postalCode,
      required this.userType,
      }) ;

  Widget get photo {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return Image.network(photoUrl!);
    } else {
      return Image.asset("assets/images/perfil.png");
    }
  }

  factory UserModel.Mock({LoginModel? login, String? email}) {
    return UserModel(
      email: email ??"",
      name: "",
      userType: UserType.student,
      login: LoginModel.New(),
    );
  }

  /**
   * Atualiza dados do objeto recuperado da rede social, com dados que foram gravados
   * pelo usuario no cadastro
   */
  UserModel enrich(UserModel appUserData) {
    var urlPhoto =
        appUserData.photoUrl != null && appUserData.photoUrl!.isNotEmpty
            ? appUserData.photoUrl
            : photoUrl;
    var u = UserModel(
        id: appUserData.id,
        name: appUserData.name,
        email: appUserData.email,
        birthDate: appUserData.birthDate ?? birthDate,
        phone: appUserData.phone ?? phone,
        postalCode: appUserData.postalCode ?? postalCode,
        userType: appUserData.userType ?? userType,

        image: appUserData.image,
        gender:appUserData.gender,
        login: appUserData.login ?? login);
    return u;
  }

  Map<String, dynamic> body() {
    return {
      "image": image?.body(),
      "name": name,
      "gender":gender?.name,
      "email": email,
      "birthDate": birthDate,
      "phone": phone,
      "postalCode": postalCode,
      "userType": userType?.name(),
      "photoUrl": photoUrl,
      "photoThumbUrl": photoThumbUrl,

    };
  }

  static UserModel fromJson(Map<String, dynamic> json) {

    return UserModel(
        id: json['id'],
        teacherProfile: json['teacherProfile'],
        name: json['name'],
        email: json['email'],
        image:ImagemModel.fromJson( json['image']),
        birthDate: json['birthDate'],
        phone: json['phone'],
        userType: UserType.values.byName(json['userType']),
        completeRegistration :json['completeRegistration'],
        gender: GenderType.values.byName(json['gender'] ??"other"),
        postalCode: json['postalCode']);
  }

  @deprecated
  static UserModel build(Map<String, dynamic> json, String id) {
    return UserModel(
        id: id,
        name: json['name'],
        image: json['image'],
        email: json['email'],
        birthDate: json['birthDate'],
        completeRegistration: json['completeRegistration'],
        phone: json['phone'],
        userType: UserType.values.byName(json['userType']),
        postalCode: json['postalCode'],
        login: LoginModel.json(json));
  }

  @override
  String toString() {
    return 'UserModel{id: $id,  name: $name, mail: $email, phone: $phone, birthDate: $birthDate, postalCode: $postalCode, userType: $userType, login: $login}';
  }
}
