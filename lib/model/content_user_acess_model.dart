import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/model/abastract_model.dart';


/**
 * Classe que repŕesenta o acesso de um determinado aluno ao conteudo de uma turma
 */
class ContentUserAcessModel extends AbastractModel {
  String id;
  String userId;
  //registrar Id do usuario que concedeu a permissao
  String grantUserId;
  String contentGroupId;
  Timestamp createDate;

  ContentUserAcessModel(
      {required this.id,
      required this.userId,
      required this.grantUserId,
      required this.contentGroupId,
      required this.createDate});

  static ContentUserAcessModel fromJson(Map<String, dynamic> json, String id) {
    return ContentUserAcessModel(
        id: json['id'],
        userId: json['userId'],
        grantUserId: json['grantUserId'],
        contentGroupId: json['contentGroupId'],
        createDate: json['createDate']);
  }

  @override
  Map<String, dynamic> body() {
    return {
      "userId": userId,
      "contentGroupId": contentGroupId,
      "grantUserId": grantUserId,
      "createDate": createDate
    };
  }
}
