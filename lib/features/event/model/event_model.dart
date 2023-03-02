import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/features/event/model/event_batch_ticket_model.dart';
import 'package:link_dance/features/event/model/event_batch_ticket_model.dart';
import 'package:link_dance/features/event/model/event_list_model.dart';
import 'package:link_dance/model/abastract_model.dart';
import 'package:flutter/material.dart';

class EventModel extends AbastractModel with ChangeNotifier {
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
  DateTime _eventDate;
  DateTime createDate;
  String? imageUrl;
  String? imageThumbUrl;
  String _rhythm;
  EventStatus status;
  EventListModel? listData;
  List<EventBatchTicketModel>? eventBatchTicket;

  @override
  String get id => _id ?? "";

  set id(id) => _id = id;

  DateTime get eventDate => _eventDate;

  set eventDate(date) => _eventDate = date;

  bool hasList() => listData != null;

  bool hasListDiscount() => listData != null && listData!.listType==EventListType.discount;

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
        this.eventBatchTicket,
      this.status = EventStatus.hidden,
      id = "",
      required this.place,
      this.paymentData,
      this.storageRef,
      required this.address,
      required this.contact,
      required this.description,
      required DateTime eventDate,
      this.tags,
      this.imageThumbUrl,
      required this.createDate,
      this.imageUrl})
      : _title = title,
        _rhythm = rhythm,
        _id = id,
        _eventDate = eventDate;

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
      "eventBatchTicket":eventBatchTicket?.map((e) => e.body()).toList(),
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


  void setImagensPath(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    imageThumbUrl = json['imageThumbUrl'];
    storageRef = json['storageRef']?.cast<String>();
  }

  static EventModel fromJson(Map<String, dynamic> json) {

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
          listData: json['listData']!=null? EventListModel.fromJson(json['listData']): null,
          eventBatchTicket: EventBatchTicketModel.fromJsonToList(json)
      );
    } catch (error, trace) {
      print("Erro ao carregar event model $trace");
      print(json);
      rethrow;
    }
  }
}

