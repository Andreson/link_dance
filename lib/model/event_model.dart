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
  DateTime eventDate;
  DateTime createDate;
  String? uriBanner;
  String? uriBannerThumb;
  String _rhythm;
  EventStatus status;

  String get id=> _id!;

  //Caminho dos arquivos no firebase para que eles possam ser deletados caso o registro seja removido
  List<String>? storageRef;
  List<String> tags;

  EventModel({required this.ownerId,
    required title,
    required rhythm,
    this.status = EventStatus.hidden,
    id="",

    this.price,
    this.place,
    this.paymentData,
    this.storageRef,
    required this.address,
    required this.contact,
    required this.description,
    required this.eventDate,
    required this.tags,
    this.uriBannerThumb,
    required this.createDate,
    this.uriBanner})
      : _title = title, _rhythm=rhythm, _id=id;

  String get title => _title.capitalizePhrase();

  String get rhythm => _rhythm ;

  set rhythm(rhythm) => _rhythm =rhythm;


  void set title(String title) => _title = title.trim();

  @override
  Map<String, dynamic> body() {
    return {
      "rhythm":rhythm,
      "ownerId": ownerId,
      "title": title.toLowerCase().trim(),
      "place": place,
      "description": description,
      "tags": tags,
      "eventDate": eventDate,
      "contact": contact,
      "price": price,
      "address": address,
      "uriBanner": uriBanner,
      "uriBannerThumb": uriBannerThumb,
      "createDate": createDate,
      "storageRef": storageRef,
      "paymentData": paymentData
    };
  }

  Map<String, dynamic> bodyToUpdate() {
    var data = <String, dynamic>{};
    data['ownerId'] = ownerId;
    data['eventDate'] = eventDate;
    if (title.isNotEmpty) {
      data['title'] = title;
    }
    if (place != null && place!.isNotEmpty) {
      data['place'] = place;
    }
    if (contact.isNotEmpty) {
      data['contact'] = contact;
    }
    if (description.isNotEmpty) {
      data['description'] = description;
    }
    if (tags.isNotEmpty) {
      data['tags'] = tags;
    }
    if (price != null) {
      data['price'] = price;
    }
    if (address.isNotEmpty) {
      data['address'] = address;
    }
    if(rhythm.isNotEmpty){
      data['rhythm'] = rhythm;
    }


    if (uriBanner != null && uriBanner!.isNotEmpty) {
      data['uriBanner'] = uriBanner;
    }

    if (paymentData != null && paymentData!.isNotEmpty) {
      data['paymentData'] = paymentData;
    }

    if (storageRef != null && storageRef!.isNotEmpty) {
      data['storageRef'] = storageRef;
    }

    if (uriBannerThumb != null && uriBannerThumb!.isNotEmpty) {
      data['uriBannerThumb'] = uriBannerThumb;
    }

    return data;
  }

  factory EventModel.New( {String? id=""}) {
    var temp =id!.isEmpty ? null: id;
    
    return EventModel(
        id:temp ,
        rhythm:"",
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

  static EventModel fromJson(Map<String, dynamic> json, String id) {
    try {
      return EventModel(
          rhythm: json['rhythm'],
          id: id,
          tags: json['tags'].cast<String>(),
          storageRef: json['storageRef']?.cast<String>(),
          address: json['address'],
          uriBannerThumb: json['uriBannerThumb'],
          title: json['title'],
          paymentData: json["paymentData"],
          place: json['place'],
          contact: json['contact'],
          ownerId: json['ownerId'],
          price: double.parse(json['price'].toString()),
          description: json['description'],
          eventDate: (json['eventDate'] as Timestamp).toDate(),
          uriBanner: json['uriBanner'],
          createDate: (json['createDate'] as Timestamp).toDate());
    }
    catch (error) {
      print("Erro ao carregar event model $error");
      print(json);
      return EventModel.New(id: id);
    }
  }
}