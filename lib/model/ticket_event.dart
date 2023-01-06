
import 'package:link_dance/model/abastract_model.dart';

class TicketEventModel extends AbastractModel{


  String _id;
  String eventId;
  String userId;
  String userEventOwnerId;
  late DateTime createDate;
  DateTime expirationDate;
  bool  isUsed;
  String? checkSum;

  @override
  String get id => _id;

  TicketEventModel(
      { required this.eventId,
        required this.userId,
        required this.userEventOwnerId,
        required this.expirationDate, this.isUsed=false, this.checkSum,String id=""}): _id = id;

  @override
  Map<String, dynamic> body() {
    return {
      "eventId":eventId,
      "userId":userId,
      "userCreateId":userEventOwnerId,
      "createDate":createDate,
      "expirationDate":expirationDate,
      "isUsed":isUsed,
      "checkSum":checkSum
    };
  }

  static TicketEventModel fromJson(Map<String, dynamic> json, String id) {

    return TicketEventModel(
        id: id,
        eventId: json['eventId'],
        userId: json['userId'],
        userEventOwnerId: json['userCreateId'],
        expirationDate: json['expirationDate'],
        isUsed: json['isUsed'],
        checkSum: json['checkSum'] );
  }


}