import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/model/abastract_model.dart';

class EventBatchTicketModel {

  EventBatchTicketModel({
    required this.priceMale,
    required this.priceFemale,
    required this.startDate,
    required this.endDate,
  });

  double priceMale;
  double priceFemale;
  DateTime startDate;
  DateTime endDate;
  final String batchType = "byDate";

  Map<String, dynamic> body() {
    return {
      "priceMale": priceMale,
      "priceFemale": priceFemale,
      "startDate": startDate,
      "endDate": endDate,
      "batchType": batchType,
    };
  }

  static List<EventBatchTicketModel>? fromJsonToList(Map<String, dynamic> json) {
    if ( json['eventBatchTicket']==null) {
      return null;
    }
    List jsonList =  json['eventBatchTicket'];
    List<EventBatchTicketModel> resp = [];
    jsonList.forEach((data) {
      resp.add(EventBatchTicketModel.fromJson(data));
    });
    return resp;
  }

  static EventBatchTicketModel fromJson(Map<String, dynamic> json) {
    try {
      if (json['batchTicket'] != null) {
        json = json['batchTicket'];
      }
      return EventBatchTicketModel(
        priceMale: json['priceMale'],
        priceFemale: json['priceFemale'],
        endDate: AbastractModel.parseDate(json['endDate']),
        startDate: AbastractModel.parseDate(json['startDate']),
      );
    } catch (err, trace) {
      print("Erro ao fazer parse EventBatchTicketModel $trace");
      rethrow;
    }
  }
}
