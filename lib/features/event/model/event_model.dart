import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/enumerate.dart';
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
  String? place;
  double? price;
  double? malePrice;
  double? femalePrice;
  DateTime eventDate;
  DateTime createDate;
  String? uriBanner;
  String? uriBannerThumb;
  String _rhythm;
  String? vipTimeFemale;
  String? vipTimeMale;
  int? maleVip;
  int? femaleVip;
  bool hasVip;
  EventStatus status;

  @override
  String get id => _id ?? "";

   set id(id)  => _id =id;

  //Caminho dos arquivos no firebase para que eles possam ser deletados caso o registro seja removido
  List<String>? storageRef;
  List<String>? tags;

  EventModel(
      {required this.ownerId,
      required title,
      required rhythm,
      this.status = EventStatus.hidden,
      id = "",
      this.vipTimeFemale,
      this.vipTimeMale,
      this.maleVip = 0,
      this.femaleVip = 0,
      this.hasVip = false,
      this.price,
      this.place,
      this.paymentData,
      this.storageRef,
      required this.address,
      required this.contact,
      required this.description,
      required this.eventDate,
      this.tags,
      this.uriBannerThumb,
      required this.createDate,
      this.femalePrice,
      this.malePrice,
      this.uriBanner})
      : _title = title,
        _rhythm = rhythm,
        _id = id;

  String get title => _title.capitalizePhrase();

  String get rhythm => _rhythm;

  set rhythm(rhythm) => _rhythm = rhythm;

  void set title(String title) => _title = title.trim();

  @override
  Map<String, dynamic> body() {
    return {
      "rhythm": rhythm,
      "ownerId": ownerId,
      "title": title.toLowerCase().trim(),
      "place": place,
      "description": description,
      "vipTimeFemale": vipTimeFemale,
      "vipTimeMale": vipTimeMale,
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
      "femaleVip": femaleVip,
      "femalePrice": femalePrice,
      "malePrice": malePrice,
      "maleVip": maleVip,
      "hasVip": hasVip
    };
  }

  factory EventModel.New({String? id = ""}) {
    return EventModel(
        id: id,
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
        hasVip: json['hasVip'] ?? false,
        femalePrice: json['femalePrice'],
        femaleVip: json['femaleVip'],
        malePrice: json['malePrice'],
        maleVip: json['maleVip'],
        vipTimeFemale: json['vipTimeFemale'],
        vipTimeMale: json['vipTimeMale'],
      );
    } catch (error) {
      print("Erro ao carregar event model $error");
      print(json);
      rethrow;
    }
  }
}

class EventVipData {}
