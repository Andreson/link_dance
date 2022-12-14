import 'package:link_dance/model/abastract_model.dart';

class FollowCountModel extends AbastractModel  {
  String id;
  String ownerId;
  int like;

  FollowCountModel(
      {required this.id, required this.ownerId, required this.like});


  static FollowCountModel fromJson(Map<String, dynamic> json, String id) {
    return FollowCountModel(
        id: id, ownerId: json["ownerId"], like: json["like"]);
  }

  @override
  Map<String, dynamic> body() {
    return {
      "ownerId":ownerId,
      "like":like
    };

  }
}
