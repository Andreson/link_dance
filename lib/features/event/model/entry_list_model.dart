import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/features/event/model/guest_list_entry_model.dart';
import 'package:link_dance/model/abastract_model.dart';

class EntryListEventModel extends AbastractModel {

  late String _id;
  late String label;
  late String ownerId;
  late String eventId;
  late String eventTitle;
  late String eventPlace;
  late DateTime eventDate;
  late String dynamicLink;
  late List<GuestEntryListModel> guests;
  EntryListType entryListType;
  
  EntryListEventModel(
      {id = "",required this.entryListType ,required this.label, required this.ownerId,
        required this.eventId, required this.eventTitle, required this.eventPlace, required this.dynamicLink,
        required this.eventDate, required this.guests}) :_id = id;

  @override
  Map<String, dynamic> body() {
    return {
      "label": label,
      "ownerId": ownerId,

      "eventId": eventId,
      "eventTitle": eventTitle,
      "eventPlace": eventPlace,
      "dynamicLink": dynamicLink,
      "eventDate": eventDate,
      "guests": guests.map((e) => e.body()).toList(),
      "entryListType":entryListType.name
    };
  }

  static EntryListEventModel fromJson(Map<String, dynamic> json) {
    return EntryListEventModel(id: json['id'],
        entryListType: EntryListType.values.byName(json['entryListType']),
        label: json['label'],
        ownerId: json['ownerId'],

        eventId: json['eventId'],
        eventTitle: json['eventTitle'],
        eventPlace: json['eventPlace'],
        dynamicLink: json['dynamicLink'],
        eventDate: json['eventDate'],
        guests: GuestEntryListModel.fromJsonToList(json));
  }

  @override
  String get id => _id;

}