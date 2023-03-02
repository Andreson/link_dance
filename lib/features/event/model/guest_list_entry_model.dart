import 'package:link_dance/model/user_model.dart';

class GuestEntryListModel {
  late String name;
  late String email;
  late String idUserGuest;
  late String photoUrl;

  GuestEntryListModel(
      {required this.name,
      required this.email,
      required this.idUserGuest,
      required this.photoUrl});

  GuestEntryListModel.user({required UserModel user})
      : name = user.name,
        email = user.email!,
        idUserGuest = user.id,
        photoUrl = user.photoUrl!;

  Map<String, dynamic> body() {
    return {
      "name": name,
      "email": email,
      "idUserGuest": idUserGuest,
      "photoUrl": photoUrl
    };
  }

  static List<GuestEntryListModel> fromJsonToList(Map<String, dynamic> json) {

    List jsonList =  json['guests'];
    List<GuestEntryListModel> resp = [];
    for (var data in jsonList) {
      resp.add(GuestEntryListModel.fromJson(data));
    }
    return resp;
  }
  static GuestEntryListModel fromJson(Map<String, dynamic> json) {
    return GuestEntryListModel(
        name: json['name'],
        email: json['email'],
        idUserGuest: json['idUserGuest'],
        photoUrl: json['photoUrl']);
  }
}
