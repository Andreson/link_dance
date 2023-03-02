
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/model/abastract_model.dart';

class EventListModel {
  EventListModel(
      {required this.vipTimeFemale,
        required this.vipTimeMale,
        required this.entriesUntil,
        this.maleVip = 0,
        this.femaleVip = 0,
        this.malePriceDiscount = 0,
        this.femalePriceDiscount = 0,
        required this.listType});

  String? vipTimeFemale;
  String? vipTimeMale;
  int? maleVip;
  int? femaleVip;
  double? malePriceDiscount;
  double? femalePriceDiscount;
  DateTime entriesUntil;
  late EventListType listType;

  Map<String, dynamic> body() {
    return {
      "vipTimeFemale": vipTimeFemale,
      "vipTimeMale": vipTimeMale,
      "maleVip": maleVip,
      "femaleVip": femaleVip,
      "femalePriceDiscount":femalePriceDiscount,
      "malePriceDiscount": malePriceDiscount,
      "listType": listType.name,
      "entriesUntil": entriesUntil
    };
  }

  static EventListModel fromJson(Map<String, dynamic> json) {
    try {

      return EventListModel(
        vipTimeFemale: json['vipTimeFemale'],
        vipTimeMale: json['vipTimeMale'] ?? 0,
        listType: EventListType.values.byName(json['listType'] ?? "none"),
        maleVip: json['maleVip'] ?? 0,
        femaleVip: json['femaleVip'] ?? 0,
        femalePriceDiscount: json['femalePriceDiscount'] ?? 0,
        malePriceDiscount: json['malePriceDiscount'],
        entriesUntil: AbastractModel.parseDate(json['entriesUntil']) ,
      );
    } catch (err, trace) {
      print("Erro ao fazer parse event list model $err");
     rethrow;
    }
  }
}