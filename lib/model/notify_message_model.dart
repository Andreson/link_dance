import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/model/abastract_model.dart';

class NotifyMessageModel extends AbastractModel {
  String _id;
  int countErros;
  DateTime? dateProcessed;
  String? bannerUrl;
  bool isProcessed;
  bool sendBanner;
  String message;
  NotifyMessageType type;
  DateTime sendDate;
  DateTime createDate;
  List<NotifyMessagePhone>? notifyErros;
  String typeId;

  NotifyMessageModel({
    required id,
    this.sendBanner = true,
    required this.createDate,
    required this.countErros,
    required this.sendDate,
    this.notifyErros,
     this.dateProcessed,
     this.bannerUrl,
    this.isProcessed=false,
    required this.message,
    required this.type,
    required this.typeId})
      : _id = id;

  @override
  Map<String, dynamic> body() {
    return {
      "id": id,
      "countErros": countErros,
      "notifyErros": notifyErros,
      "dateProcessed": dateProcessed,
      "bannerUrl": bannerUrl,
      "isProcessed": isProcessed,
      "message": message,
      "type": type,
      "sendDate":sendDate,
      "typeId": typeId};
  }

  static Map<String, dynamic> defaultData({required typeId}) {
    return {
      "isProcessed": false,
      "type": NotifyMessageType.teacher.name,
      "typeId": typeId,
      "createDate": DateTime.now()
    };
  }


  @override
  String get id => _id;

  static NotifyMessageModel fromJson(Map<String, dynamic> json, String id) {
    dynamic createDate;
    if (json['createDate'] is DateTime ){
       createDate  = json['createDate'];
    }else {
      createDate  = (json['createDate'] as Timestamp).toDate();
    }

    return NotifyMessageModel(
        id: json['id'],
        createDate: createDate,
        sendDate : (json['sendDate'] as Timestamp).toDate(),
        countErros: json['countErros'],
        dateProcessed: json['dateProcessed']!=null?(json['dateProcessed'] as Timestamp).toDate():null ,
        bannerUrl: json['bannerUrl'],
        isProcessed: json['isProcessed'],
        message: json['message'],
        type:NotifyMessageType.values.byName( json['type']),
        typeId: json['typeId']);
  }

}


class NotifyMessagePhone {
  String number;
  String description;

  NotifyMessagePhone({required this.number, required this.description});
}
