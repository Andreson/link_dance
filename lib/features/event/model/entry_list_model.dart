import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/helpers/constantes_images.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/event/model/guest_list_entry_model.dart';
import 'package:link_dance/model/abastract_model.dart';

class EntryListEventModel extends AbastractModel {

  late String _id;
  late String label;
  late String ownerId;
  late String ownerImageUrl;
  late String ownerEmail;
  late String ownerPhone;
  late UserType ownerUserType;
  late String eventId;
  late String eventTitle;
  late String eventPlace;
  late DateTime eventDate;
  late String dynamicLink;
  late List<GuestEntryListModel> guests;
  late  EntryListType entryListType;

  EntryListEventModel(
      {id = "",required this.ownerUserType, required this.entryListType, required this.ownerPhone, required this.ownerEmail, required this.ownerImageUrl, required this.label, required this.ownerId,
        required this.eventId, required this.eventTitle, required this.eventPlace, required this.dynamicLink,
        required this.eventDate, required this.guests}) :_id = id;



  EntryListEventModel.event({required EventModel event}) {
    _fromEvent(event: event);
    entryListType = EntryListType.birthday;
    label="";
  }

  String eventLabel() {
    return "${eventTitle.capitalizePhrase()} - ${eventPlace
        .capitalizePhrase()} - ${eventDate.showString()}";
  }

  @override
  Map<String, dynamic> body() {
    return {
      "label": label,
      "ownerId": ownerId,
      "ownerUserType": ownerUserType.name(),
      "eventId": eventId,
      "dynamicLink": dynamicLink,
      "guests": guests.map((e) => e.body()).toList(),
      "entryListType": entryListType.name,
      "ownerPhone": ownerPhone,
      "ownerEmail": ownerEmail,
      "ownerImageUrl": ownerImageUrl
    };
  }

  void  _fromEvent({required EventModel event}) {
     eventTitle = event.title;
     eventDate = event.eventDate;
     eventPlace = event.place;
     eventId = event.id;
      id="";
  }

  static EntryListEventModel fromJson(Map<String, dynamic> json) {
    return EntryListEventModel(id: json['id'] ?? "",
        entryListType: EntryListType.values.byName("birthday"),
        label: json['label'],
        ownerUserType : UserType.values.byName(json['ownerUserType'] ?? "student"),
        ownerId: json['ownerId'] ?? "",
        ownerEmail: json["ownerEmail"] ?? "",
        ownerImageUrl: json["ownerImageUrl"] ?? ConstantsImagens.defaultAvatar,
        ownerPhone: json["ownerPhone"] ?? "",
        eventId: json['eventId'],
        eventTitle: json['eventTitle'],
        eventPlace: json['eventPlace'],
        dynamicLink: json['dynamicLink'] ?? "",
        eventDate: AbastractModel.parseDate(json['eventDate']),
        guests: json['guests'] != null ? GuestEntryListModel.fromJsonToList(
            json) : []);
  }

  @override
  String get id => _id;

  set id(String id) => _id = id;

}