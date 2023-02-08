import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/model/abastract_model.dart';
import 'package:link_dance/model/imagem_model.dart';
import 'package:link_dance/model/login_model.dart';
import 'package:link_dance/model/teacher_model.dart';
import 'package:flutter/material.dart';

class UserModel extends AbastractModel {
  //user ID for authentication
  String id;
  String? name;
  String? email;
  String? phone;
  String? birthDate;
  String? postalCode;
  String? photoUrl;
  UserType userType;
  LoginModel? login;
  ImagemModel? imagemModel;
  GenderType? gender;
  TeacherModel? teacherProfile;
  bool fullRegistryCheck=false;

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
      this.imagemModel,
      this.login,
      this.name,
      this.email,
      this.teacherProfile,
      this.phone,
      this.birthDate,
      this.postalCode,
      required this.userType,
      this.photoUrl});

  Widget get photo {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return Image.network(photoUrl!);
    } else {
      return Image.asset("assets/images/perfil.png");
    }
  }

  factory UserModel.Mock({LoginModel? login}) {
    return UserModel(
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
        name: appUserData.name ?? name,
        email: appUserData.email ?? email,
        birthDate: appUserData.birthDate ?? birthDate,
        phone: appUserData.phone ?? phone,
        postalCode: appUserData.postalCode ?? postalCode,
        userType: appUserData.userType ?? userType,
        photoUrl: urlPhoto,
        gender:appUserData.gender,
        login: appUserData.login ?? login);
    return u;
  }

  Map<String, dynamic> body() {
    return {
      "imagem": imagemModel?.body(),
      "name": name,
      "gender":gender,
      "email": email,
      "birthDate": birthDate,
      "phone": phone,
      "postalCode": postalCode,
      "userType": userType?.name(),
      "photoUrl": photoUrl
    };
  }

  static UserModel fromJson(Map<String, dynamic> json, String id) {

    return UserModel(
        id: id,
        teacherProfile: json['teacherProfile'],
        name: json['name'],
        email: json['email'],
        birthDate: json['birthDate'],
        phone: json['phone'],
        photoUrl: json['photoUrl'],
        userType: UserType.values.byName(json['userType']),
        gender: GenderType.values.byName(json['gender'] ??"other"),
        postalCode: json['postalCode']);
  }

  static UserModel build(Map<String, dynamic> json, String id) {
    return UserModel(
        id: id,
        name: json['name'],
        photoUrl: json['photoUrl'],
        email: json['email'],
        birthDate: json['birthDate'],
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
