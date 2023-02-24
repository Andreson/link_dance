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
  double priceMale;
  double priceFemale;
  DateTime eventDate;
  DateTime createDate;
  String? imageUrl;
  String? imageThumbUrl;
  String _rhythm;
  EventStatus status;
  EventListModel? listData;

  @override
  String get id => _id ?? "";

  set id(id) => _id = id;

  bool hasList() => listData != null;

  bool allowsToSubscribe() {
    var tomorrow = DateTime.now().subtract(const Duration(days: 1));
    if (hasList()) {
      return listData!.entriesUntil.isAfter(tomorrow);
    }
    return eventDate.isAfter(tomorrow!);
  }

  //Caminho dos arquivos no firebase para que eles possam ser deletados caso o registro seja removido
  List<String>? storageRef;
  List<String>? tags;

  String shareLabel({required String link}) {
    final urlPreview = link;
    var date = eventDate.showString();
    var title = this.title.capitalizePhrase();
    return "$title\n$date\n$place\n $urlPreview";
  }

  EventModel(
      {required this.ownerId,
      required title,
      required this.priceFemale,
      required this.priceMale,
      required rhythm,
      this.listData,
      this.status = EventStatus.hidden,
      id = "",
      required this.place,
      this.paymentData,
      this.storageRef,
      required this.address,
      required this.contact,
      required this.description,
      required this.eventDate,
      this.tags,
      this.imageThumbUrl,
      required this.createDate,
      this.imageUrl})
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
      "address": address,
      "imageUrl": imageUrl,
      "imageThumbUrl": imageThumbUrl,
      "createDate": createDate,
      "storageRef": storageRef,
      "paymentData": paymentData,
      "priceMale": priceMale,
      "priceFemale": priceFemale
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
        priceFemale: 0,
        priceMale: 0,
        description: "",
        eventDate: DateTime.now().add(Duration(days: 60)),
        createDate: DateTime.now(),
        imageUrl: "");
  }
  void setImagensPath(Map<String, dynamic> json) {
    imageUrl= json['imageUrl'];
    imageThumbUrl= json['imageThumbUrl'];
    storageRef= json['storageRef']?.cast<String>();
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
          imageThumbUrl: json['imageThumbUrl'],
          title: json['title'],
          paymentData: json["paymentData"],
          place: json['place'],
          contact: json['contact'],
          ownerId: json['ownerId'],
          priceMale: json['priceMale'] ?? 0,
          priceFemale: json['priceFemale'] ?? 0,
          description: json['description'],
          eventDate: AbastractModel.parseDate(json['eventDate']),
          imageUrl: json['imageUrl'],
          createDate: AbastractModel.parseDate(json['createDate']),
          listData: EventListModel.fromJson(json));
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
      "entriesUntil": entriesUntil
    };
  }

  static EventListModel? fromJson(Map<String, dynamic> json) {
    try {
      if (json['listData'] != null) {
        json = json['listData'];
      } else {
        return null;
      }

      return EventListModel(
          vipTimeFemale: json['vipTimeFemale'],
          vipTimeMale: json['vipTimeMale'] ?? 0,
          listType: EventListType.values.byName(json['listType'] ?? "none"),
          maleVip: json['maleVip'] ?? 0,
          femalePrice: json['femalePrice'] ?? 0,
          femalePriceDiscount: json['femalePriceDiscount'] ?? 0,
          femaleVip: json['femaleVip'] ?? 0,
          malePrice: json['malePrice'] ?? 0,
          entriesUntil: (json['entriesUntil'] as Timestamp).toDate(),
          malePriceDiscount: json['malePriceDiscount']);
    } catch (err, trace) {
      print("Erro ao carregar lista do evento $trace");
      return null;
    }
  }
}
