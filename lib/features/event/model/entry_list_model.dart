import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/helpers/constantes_images.dart';
import 'package:link_dance/features/event/model/guest_list_entry_model.dart';
import 'package:link_dance/model/abastract_model.dart';

class EntryListEventModel extends AbastractModel {

  late String _id;
  late String label;
  late String ownerId;
  late String ownerImageUrl;
  late String ownerEmail;
  late String ownerPhone;
  late String eventId;
  late String eventTitle;
  late String eventPlace;
  late DateTime eventDate;
  late String dynamicLink;
  late List<GuestEntryListModel> guests;
  EntryListType entryListType;
  
  EntryListEventModel(
      {id = "",required this.entryListType,required this.ownerPhone,required this.ownerEmail, required this.ownerImageUrl ,required this.label, required this.ownerId,
        required this.eventId, required this.eventTitle, required this.eventPlace, required this.dynamicLink,
        required this.eventDate, required this.guests}) :_id = id;

  @override
  Map<String, dynamic> body() {
    return {
      "label": label,
      "ownerId": ownerId,
      "eventId": eventId,
      "dynamicLink": dynamicLink,
      "guests": guests.map((e) => e.body()).toList(),
      "entryListType":entryListType.name,
      "ownerPhone":ownerPhone,
      "ownerEmail":ownerEmail,
      "ownerImageUrl":ownerImageUrl
    };
  }

  static EntryListEventModel fromJson(Map<String, dynamic> json) {
    return EntryListEventModel(id: json['id'] ??"",
        entryListType: EntryListType.values.byName( "birthday"),
        label: json['label'],
        ownerId: json['ownerId'] ??"",
        ownerEmail: json["ownerEmail"] ??"",
        ownerImageUrl: json["ownerImageUrl"] ?? ConstantsImagens.defaultAvatar ,
        ownerPhone: json["ownerPhone"] ??"" ,
        eventId: json['eventId'],
        eventTitle: json['eventTitle'],
        eventPlace: json['eventPlace'],
        dynamicLink: json['dynamicLink'] ??"",
        eventDate:AbastractModel.parseDate(json['eventDate']),
        guests: json['guests']!=null? GuestEntryListModel.fromJsonToList(json):[]);
  }

  @override
  String get id => _id;

   set id(String id) => _id= id;

}