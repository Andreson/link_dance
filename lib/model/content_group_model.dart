import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/model/abastract_model.dart';

import '../core/enumerate.dart';
import '../core/extensions/string_extensions.dart.dart';


/**
 * Classe que sera usada  a principio para representar as turmas , mas podera agrear outros tipos de conteudo
 */
class ContentGroupModel extends AbastractModel{
  @override
  String id;
  String ownerId;
  String _title;
  String? imageUrl;
  String? labelTeacher;
  String timeMeeting;
  String? imageThumbUrl;
  List<String>? storageRef;
  String school;
  String? description;
  String rhythm;
  bool isPublic;
  ContentGroupType type;
  final Timestamp _createDate = Timestamp.now();
  Timestamp startClassDate;

  String get title => _title.capitalizePhrase();

  set title(String title) => _title = title.trim();


  ContentGroupModel({required this.id,
    required title,

    required this.ownerId,
    this.labelTeacher,
    this.imageUrl,
    this.imageThumbUrl,

    required this.timeMeeting,
    this.storageRef,
    required this.school,
    required this.isPublic,
    this.description,
    required this.rhythm,
    required this.type,
    required this.startClassDate}): _title = title;

  String labelAccessContent() {
    if ( isPublic){
      return "público";
    }
    else {
      return "restrito";
    }
  }
  String labelStartClass() {
    var startClass = startClassDate.toDate();
    var toDay = DateTime.now();
    var isAfter = startClass.isAfter(toDay);

    if ( isAfter){
      return "Aulas iniciam em ${startClass.showString()}";
    }
    else {
       return "Aulas iniciadas em ${startClass.showString()}";
    }
  }



  static ContentGroupModel fromJson(Map<String, dynamic> json, String id ) {
    return ContentGroupModel(
      id: id,
      labelTeacher: json['labelTeacher'],
      timeMeeting: json['timeMeeting'],
      isPublic: json['isPublic'],
      ownerId: json['ownerId'],
      imageUrl: json['imageUrl'],
      imageThumbUrl: json['imageThumbUrl'],
      storageRef:json['storageRef']?.cast<String>(),
      school: json['school'],
      title: json['title'],
      description: json['description'],
      type: json['type']==null ?ContentGroupType.intensivo: ContentGroupType.values.byName( json['type'] ),
      startClassDate: json['startClassDate'],
      rhythm: json['rhythm'],);
  }




  @override
  Map<String, dynamic> body() {
    return {
      "labelTeacher":labelTeacher,
      "timeMeeting":timeMeeting,
      "imageUrl": imageUrl,
      "storageRef":storageRef,
      "ownerId":ownerId,
      "imageThumbUrl": imageThumbUrl,
      "school":school,
      "description": description,
      "title": title.toLowerCase().trim(),
      "isPublic":isPublic,
      "type": type.name,
      "startClassDate": startClassDate,
      "rhythm": rhythm,
      "createDate": _createDate
    };
  }

  @override
  String toString() {
    return 'ContentGroupModel{id: $id, ownerId: $ownerId, title: $title, rhythm: $rhythm}';
  }
}
