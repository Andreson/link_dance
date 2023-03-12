import 'package:flutter/cupertino.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/dynamic_links/dynamic_links_helper.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/custom_exeptions.dart';
import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:link_dance/features/event/model/entry_list_model.dart';
import 'package:link_dance/features/event/model/guest_list_entry_model.dart';
import 'package:link_dance/features/event/repository/entry_list_repository.dart';
import 'package:link_dance/features/user/dto/user_response_dto.dart';
import 'package:link_dance/features/user/user_helper.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/user_repository.dart';
import 'package:provider/provider.dart';

class EntryListHelper {
  late UserRepository _userRepository;
  late AuthenticationFacate _auth;
  late EntryListRepository _entryListRepository;
  late final RestTemplate _restTemplate;
  late UserHelper _userHelper;

  EntryListHelper.ctx({required BuildContext context}) {
    _auth = Provider.of<AuthenticationFacate>(context, listen: false);
    _userRepository = UserRepository(auth: _auth);
    _restTemplate = RestTemplate(auth: _auth);
    _userHelper = UserHelper(context: context);
    _entryListRepository =
        Provider.of<EntryListRepository>(context, listen: false);
  }

  EntryListHelper({required AuthenticationFacate auth})
      : _userRepository = UserRepository(auth: auth),
        _restTemplate = RestTemplate(auth: auth);

  Future<UserModel?> findUserByEmail({required String email}) {
    return _userRepository.findUserByEmail(UserModel.Mock(email: email.trim()));
  }

  Future<UserResponseDTO> checkUserLoggedRegistration() {
    return _userHelper.checkCompleteRegistration();
  }

  Future<EntryListEventModel> createEntryList(
      {required EntryListEventModel entryList}) async {
    var respose = await _restTemplate.post(
        body: {"entryList": entryList.body()},
        url: "${ConstantsAPI.eventApi}/event/entrylist").catchError((onError) {
      print("Erro ao chamar entrylist $onError");

      throw onError;
    });
    entryList.id = respose["data"]["data"]["entryList"]["id"];

    try {
      entryList.dynamicLink =
          await createDynamicLinkEntryList(entryListID: entryList.id);
    } catch (err, trace) {
      print("Erro ao salvar entry list $err | \n $trace");
      throw NoCriticalException("Erro ao criar link dinamico:  $err");
    }

    return entryList;
  }

  Future<String> createDynamicLinkEntryList({required entryListID}) async {
    var options = DynamicLinkOptions.shortLink(
        idDocument: entryListID,
        releaseDestination: "entrylist",
        title: "Lista de entrada");
    final dynamicLink =
        await DynamicLinkHelper.createDynamicLink(options: options);
    _entryListRepository
        .updateDynamicLink(id: entryListID, dynamicLink: dynamicLink)
        .catchError((onError) => throw onError);
    print("Novo link gerado $dynamicLink");
    return dynamicLink;
  }

  Future<void> updateGuestEntryList(
      {required List<GuestEntryListModel> guests,
      String? dynamicLink,
      required String id}) async {
    Map<String, dynamic> data = {"guests": guests.map((e) => e.body()).toList()};
    if (dynamicLink != null) {
      data["dynamicLink"] = dynamicLink;
    }
    return _entryListRepository
        .updateGuestEntryList(data: data, id: id)
        .catchError((onError,trace) {
      print("Erro updateGuestEntryList event Helper = : $onError");
      throw onError;
    });
  }
}
