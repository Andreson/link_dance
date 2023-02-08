

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/model/abastract_model.dart';

class EventModel extends AbastractModel {
  String? _id;
  String ownerId;
  String description;
  String _title;
  String? paymentData;
  String address;
  String contact;
  String place;
  double? price;
  DateTime eventDate;
  DateTime createDate;
  String? uriBanner;
  String? uriBannerThumb;
  String _rhythm;
  EventStatus status;
  EventListModel? listData;

  @override
  String get id => _id ?? "";

  set id(id) => _id = id;

  bool hasList() => listData != null;

  //Caminho dos arquivos no firebase para que eles possam ser deletados caso o registro seja removido
  List<String>? storageRef;
  List<String>? tags;

  String shareLabel({required String link}) {

    final urlPreview=link;
    var date = eventDate.showString();
    var title = this.title.capitalizePhrase();
    return "$title\n$date\n$place\n $urlPreview";
  }

  EventModel(
      {required this.ownerId,
      required title,
      required rhythm,
      this.listData,
      this.status = EventStatus.hidden,
      id = "",
      this.price,
      required this.place,
      this.paymentData,
      this.storageRef,
      required this.address,
      required this.contact,
      required this.description,
      required this.eventDate,
      this.tags,
      this.uriBannerThumb,
      required this.createDate,
      this.uriBanner})
      : _title = title,
        _rhythm = rhythm,
        _id = id;

  String get title => _title.capitalizePhrase();
  String get rhythm => _rhythm;
  set rhythm(rhythm) => _rhythm = rhythm;
  set title(String title) => _title = title.trim();

  @override
  Map<String, dynamic> body() {
    return {
      "rhythm": rhythm,
      "ownerId": ownerId,
      "title": title.toLowerCase().trim(),
      "place": place,
      "description": description,
      "listData": listData?.body(),
      "tags": tags,
      "eventDate": eventDate,
      "contact": contact,
      "price": price,
      "address": address,
      "uriBanner": uriBanner,
      "uriBannerThumb": uriBannerThumb,
      "createDate": createDate,
      "storageRef": storageRef,
      "paymentData": paymentData,
    };
  }

  factory EventModel.New({String? id = ""}) {
    return EventModel(
        id: id,
        place: "",
        rhythm: "",
        ownerId: "",
        title: "",
        contact: "",
        address: "",
        tags: [],
        price: 0,
        description: "",
        eventDate: DateTime.now().add(Duration(days: 60)),
        createDate: DateTime.now(),
        uriBanner: "");
  }

  static EventModel fromJson(Map<String, dynamic> json) {
    var price =
        json['price'] == null ? null : double.parse(json['price'].toString());

    try {
      return EventModel(
        rhythm: json['rhythm'],
        id: json['id'],
        storageRef: json['storageRef']?.cast<String>(),
        address: json['address'],
        uriBannerThumb: json['uriBannerThumb'],
        title: json['title'],
        paymentData: json["paymentData"],
        place: json['place'],
        contact: json['contact'],
        ownerId: json['ownerId'],
        price: price,
        description: json['description'],
        eventDate: (json['eventDate'] as Timestamp).toDate(),
        uriBanner: json['uriBanner'],
        createDate: (json['createDate'] as Timestamp).toDate(), 
        listData: EventListModel.fromJson(json)

      );
    } catch (error) {
      print("Erro ao carregar event model $error");
      print(json);
      rethrow;
    }
  }
}

class EventListModel {
  EventListModel(
      {required this.vipTimeFemale,
      required this.vipTimeMale,
       required this.entriesUntil,
      this.maleVip = 0,
      this.femaleVip = 0,
      this.malePrice = 0,
      this.femalePrice = 0,
      this.malePriceDiscount = 0,
      this.femalePriceDiscount = 0,
      required this.listType});

  String? vipTimeFemale;
  String? vipTimeMale;
  int? maleVip;
  int? femaleVip;
  double malePrice;
  double femalePrice;
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
      "malePrice": malePrice,
      "femalePrice": femalePrice,
      "malePriceDiscount": malePriceDiscount,
      "listType": listType.name,
      "entriesUntil":entriesUntil
    };
  }

  static EventListModel? fromJson(Map<String, dynamic> json) {
    try {
      if(json['listData']!=null)  {
        json = json['listData'];
      }

      return EventListModel(
          vipTimeFemale: json['vipTimeFemale'],
          vipTimeMale: json['vipTimeMale']?? 0,
          listType: EventListType.values.byName(json['listType'] ?? "none"),
          maleVip: json['maleVip'] ?? 0,
          femalePrice: json['femalePrice'] ?? 0,
          femalePriceDiscount: json['femalePriceDiscount'] ?? 0,
          femaleVip: json['femaleVip'] ?? 0,
          malePrice: json['malePrice'] ?? 0,
          entriesUntil:  (json['entriesUntil'] as Timestamp).toDate(),
          malePriceDiscount: json['malePriceDiscount']);
    }
    catch(err, trace) {
      print("Erro ao carregar lista do evento $trace");
      return null;
    }
  }
}
