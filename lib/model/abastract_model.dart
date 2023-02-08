import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/exception/exceptions.dart';
import 'package:link_dance/model/content_group_model.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/movie/model/movie_model.dart';
import 'package:link_dance/model/notify_message_model.dart';
import 'package:link_dance/model/teacher_model.dart';

abstract class AbastractModel {
  String get id;
  DateTime? updatedAt;

  static AbastractModel jsonData<T>(
      {required T type, required Map<String, dynamic> data}) {

    print("jsonData parseAbastract model ${type.toString()}");

    var id = data['id'];
    if ("ContentGroupModel" == type.toString()) {
      return ContentGroupModel.fromJson(data, id);
    }
    if ("EventModel" == type.toString()) {
      return EventModel.fromJson(data);
    }
    if ("MovieModel" == type.toString()) {
      return MovieModel.fromJson(data, id ??"");
    }
    if ("TeacherModel" == type.toString()) {
      return TeacherModel.fromJson(data, id);
    }
    if ("NotifyMessageModel" == type.toString()) {

      return NotifyMessageModel.fromJson(data, id);
    }

    throw NotImplementedException(
        "[ 'fromJson' parse model  nao implementado em AbastractModel para ${type}]");
  }

  static AbastractModel json<T>(
      {required T type,
      required DocumentSnapshot<Map<String, dynamic>> snapshot}) {
    var data = snapshot.data();
    data?['id'] = snapshot.id;
    return jsonData(type: type, data: data?? {});
  }

  DateTime parseCreateDate(Map json) {
    return (json['createDate'] as Timestamp).toDate();
  }

  /**
   * nao lê ou escreve o atributo de ID, q e o notNull, e gera erro nos cadastros
   * metodo para inserir os dados no firestore
   */
  Map<String, dynamic> body();

  /**
   * add o atributo ID, nas leituras, ja que esse atributo nao existe nas gravações, e um atributo notNull
   * Metodo para carregar os dados do firestore
   */
  Map<String, dynamic> deserialize() {
    var data = body();
    try {
      data["id"] = id;

    }
    catch(err) {
      print("err deserialize: $err");
      return data;
    }
    return data;
  }
}
