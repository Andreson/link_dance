import 'package:link_dance/core/helpers/constantes_images.dart';
import 'package:link_dance/model/user_model.dart';

class GuestEntryListModel {
  late final String _name;
  late String email;
  late String idUserGuest;
  late String photoUrl;

  GuestEntryListModel(
      {required String name,
      required this.email,
      required this.idUserGuest,
      required this.photoUrl}): _name = name;

  GuestEntryListModel.user({required UserModel user})
      : _name = user.name,
        email = user.email!,
        idUserGuest = user.id,
        photoUrl = user.photoUrl ?? ConstantsImagens.defaultAvatar;


  String get name=> _name.toLowerCase();

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestEntryListModel &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          idUserGuest == other.idUserGuest;

  @override
  int get hashCode => email.hashCode ^ idUserGuest.hashCode;
}
