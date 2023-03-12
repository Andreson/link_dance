import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/input_fields/text_field.dart';
import 'package:link_dance/components/not_found_card.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_event_component.dart';
import 'package:link_dance/core/exception/custom_exeptions.dart';
import 'package:link_dance/core/exception/http_exceptions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/theme/fontStyles.dart';
import 'package:link_dance/features/event/components/entry_list_grid.dart';
import 'package:link_dance/features/event/entry_list_helper.dart';
import 'package:link_dance/features/event/model/entry_list_model.dart';
import 'package:link_dance/features/event/model/guest_list_entry_model.dart';
import 'package:link_dance/features/event/repository/entry_list_repository.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/utils/dialog_functions.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/upload_files/file_upload.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/features/user/dto/user_response_dto.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/factory_widget.dart';

class EventEntryListFormComponent extends StatefulWidget {
  final GlobalKey<MovieUploadFormState>? key;

  EventEntryListFormComponent({this.key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MovieUploadFormState();
}

class MovieUploadFormState extends State<EventEntryListFormComponent> {
  final _formKey = GlobalKey<FormState>();
  EntryListRepository entryListRepository = EntryListRepository();

  EntryListEventModel? _entryListEventModel;
  Map<String, dynamic> _formData = {};

  late EntryListHelper eventEntryListHelper;
  List<GuestEntryListModel> _userListEntry = [];
  late AuthenticationFacate _authentication;
  late AutoCompleteEventComponent _autoCompleteEventComponent;

  late UserModel _userSession;
  String _pageTitle = "Criar nova Lista";
  bool _isReadOnly = false;
  bool _isEdit = false;
  bool _isLinkChange = false;
  bool _titleReadOnly = false;
  bool _showGenerateDynamicLink = false;
  bool _eventFormIsValid = true;
  bool _isUserRegistryComplete = true;
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _emailGuestFocus = FocusNode();
  final Text _eventMsgValidation = const Text(
    "Favor selecionar o evento",
    style: kErrorText,
  );
  final TextEditingController _emailGuestcontroller = TextEditingController();
  final TextEditingController _linkGuestcontroller = TextEditingController();
  final TextEditingController _titlecontroller = TextEditingController();

  String msgVideoSelect =
      "Por favor, selecione um video para upload ou informe uma URL válida de um video do Youtube!";

  @override
  void initState() {
    _authentication = Provider.of<AuthenticationFacate>(context, listen: false);
    _userSession = _authentication.user!;
    eventEntryListHelper = EntryListHelper.ctx(context: context);
    super.initState();
  }

  _initData() {
    _entryListEventModel =
        ModalRoute.of(context)?.settings.arguments as EntryListEventModel?;

    if (_entryListEventModel != null && _entryListEventModel!.id.isNotEmpty) {
      _isEdit = true;
      _pageTitle = "Editar lista de convidados";
      _autoCompleteEventComponent.textEdit.text =
          _entryListEventModel!.eventTitle.capitalizePhrase();
      _formData = _entryListEventModel!.body();
      _userListEntry = _entryListEventModel!.guests;
      _isReadOnly = true;
      _titlecontroller.text = _entryListEventModel!.label;
      //fallback para re-gerar link dinamico caso o mesmo nao seja cria
      if (_entryListEventModel!.dynamicLink.isEmpty) {
        _showGenerateDynamicLink = true;
      } else {
        _showGenerateDynamicLink = false;
        _linkGuestcontroller.text = _entryListEventModel!.dynamicLink;
      }
    } else {
      _isEdit = false; // se for um novo cadastro
      if ( // _userSession.userType!=UserType.admin &&
          _userSession.userType != UserType.promoter) {
        _titleReadOnly = true;
        _titlecontroller.text = _userSession.name;
        _formData['label'] = _userSession.name;
      } else {
        _titleReadOnly = false;
        _titlecontroller.text = "";
        _formData['label'] = "";
      }
      _formData['ownerId'] = _userSession.id;
      _formData['ownerEmail'] = _userSession.email;
    }

    if (_entryListEventModel != null && _entryListEventModel!.eventId.isNotEmpty) {
      _autoCompleteEventComponent.textEdit.text =
          _entryListEventModel!.eventTitle.capitalizePhrase();
      _formData['eventId'] = _entryListEventModel!.eventId;
      _formData['eventTitle'] = _entryListEventModel!.eventTitle;
      _formData['eventPlace'] = _entryListEventModel!.eventPlace;
      _formData['eventDate'] = _entryListEventModel!.eventDate;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _autoCompleteEventComponent = AutoCompleteEventComponent(
      isStatefullSelection: true,
      isExpanded: false,
      required: true,
      onSelected: _selectDataEventAutocomplete,
    );

    _initData();
    _checkRegistryUser();
  }

  void _initWidgets() {
    _userSession = _authentication.user!;
    entryListRepository =
        Provider.of<EntryListRepository>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _initWidgets();

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          _isEdit
              ? buttonUpdateRegistry(onPressed: () {
                  update();
                })
              : buttonSaveRegistry(onPressed: () {
                  save();
                })
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: box(opacity: 0.35, allBorderRadius: 10),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomTextField(
                      focusNode: _descriptionFocus,
                      textAlign:
                          _titleReadOnly ? TextAlign.center : TextAlign.left,
                      required: false,
                      controller: _titlecontroller,
                      readOnly: _titleReadOnly,
                      label: "Nome da lista",
                      textStyle: _titleReadOnly
                          ? const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)
                          : null,
                    ),
                    _autoCompleteEventComponent,
                    if (!_eventFormIsValid) _eventMsgValidation,
                    CustomTextField(
                        readOnly: true,
                        required: false,
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold),
                        controller: _linkGuestcontroller,
                        label: "Link para convite",
                        suffixIcon: IconButton(
                          iconSize: 20,
                          onPressed: () {
                            if (!_showGenerateDynamicLink) {
                              copyClipboardData(
                                  _linkGuestcontroller.text, context,
                                  mensage: "Link convite copiado");
                            } else {
                              eventEntryListHelper
                                  .createDynamicLinkEntryList(
                                      entryListID: _entryListEventModel!.id)
                                  .then((value) => _isLinkChange = true);
                            }
                          },
                          icon: _showGenerateDynamicLink
                              ? const Icon(FontAwesomeIcons.arrowsRotate)
                              : const Icon(Icons.copy),
                        )),
                    sizedBox15(),
                    _formAddGuest(),
                    sizedBox10(),
                    _buildList()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserResponseDTO?> _checkRegistryUser() async {
    if (_entryListEventModel != null && _entryListEventModel!.id.isNotEmpty) {
      return null;
    }
    UserResponseDTO response = await eventEntryListHelper
        .checkUserLoggedRegistration()
        .catchError((onError) {
      print("Erro ao checar cadastro do usuario $onError");
      // showError(context,
      //     content:
      //         "Ocorreu um erro não esperado ao validar cadastro de usuário.");
    });
    if (response.hasBussinessError()) {
      _isUserRegistryComplete = response.userDTO.completeRegistration;
      showDialogRegistryIncomplete(errors: response.errors, context: context);
    }
    return null;
  }

  bool entryListHasChange() {
    var handlerListHash =
        md5.convert(utf8.encode(_userListEntry.toString())).toString();
    var originalListHash = md5
        .convert(utf8.encode(_entryListEventModel!.guests.toString()))
        .toString();

    if (handlerListHash == originalListHash) {
      print("As listas sao iguais ");
    } else {
      showInfo(
          context: context,
          content:
              "As alterações feitas na lista não foram salvas. Tem certeza q deseja sair sem salvar?");
      print("As listas sao diferentes ");
    }

    if (_userListEntry.length == _entryListEventModel!.guests.length) {
      return true;
    }
    return false;
  }

  Container _formAddGuest() {
    return Container(
      decoration: box(opacity: 0.20, allBorderRadius: 10),
      child: Column(children: [
        sizedBox20(),
        Text("Adicionar convidado"),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: CustomTextField(
                  focusNode: _emailGuestFocus,
                  required: false,
                  controller: _emailGuestcontroller,
                  label: "Email do convidado",
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  inforGuestRequirements();
                },
                icon: const Icon(
                  FontAwesomeIcons.circleInfo,
                  color: Colors.blue,
                ))
          ],
        ),
        sizedBox10(),
        OutlinedButton(
            onPressed: () {
              _addUserList();
            },
            child: Text("Add")),
        sizedBox15(),
      ]),
    );
  }

  Future _addUserList() async {
    var email = _emailGuestcontroller.text;
    FocusScope.of(context).unfocus();
    bool checkUser =
        _userListEntry.where((element) => element.email == email).isEmpty;

    if (checkUser) {
      _findUserGuest(email: _emailGuestcontroller.text);
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar(mensage: "Usuário adicionado a lista"));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar(
          mensage: "Usuário de email \"$email\" já esta na lista lista",
          level: LevelEnum.warn));
    }
  }

  Future _findUserGuest({required String email}) async {
    onLoading(context);
    UserModel? user = await eventEntryListHelper
        .findUserByEmail(email: email)
        .whenComplete(() => Navigator.of(context).pop());

    if (user != null) {
      setState(() {
        _userListEntry.add(GuestEntryListModel.user(user: user));
      });
    } else {
      showWarning(context,
          content:
              "Não encontramos nenhum usuário cadastrado com o email \"$email\".\n"
              "Poderia verificar se seu convidado possui conta ativa no Linkdance e tentar novamente?");
    }
  }

  GuestGridEntryList _buildList() {
    return GuestGridEntryList(
        userListEntry: _userListEntry,
        iconTrailing: const Icon(
          FontAwesomeIcons.trash,
          size: 16,
          color: Colors.redAccent,
        ),
        actionTrailing: (index) {
          setState(() {
            _userListEntry.removeAt(index);
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBar(mensage: "Usuário removido da lista"));
          });
        });
  }

  bool _validations() {
    if (_formData['eventId'] == null) {
      setState(() {
        _eventFormIsValid = false;
      });
      return false;
    } else {
      setState(() {
        _eventFormIsValid = true;
      });
    }
    return true;
  }

  update() {
    _formData["ownerUserType"] = _userSession.userType.name();
    eventEntryListHelper
        .updateGuestEntryList(
            guests: _userListEntry, id: _entryListEventModel!.id)
        .then((value) =>
            _showSucessPopUp(message: "Lista Atualizada com sucesso"))
        .catchError((onError) {
      showError(context);
    });
  }

  save() async {
    if (!_validations()) {
      return;
    }

    FocusScope.of(context).unfocus();
    onLoading(context, actionMesage: "Salvando registro");
    _formKey.currentState!.save();
    _formData["ownerUserType"] = _userSession.userType.name();
    _formData["entryListType"] = EntryListType.birthday.name;
    EntryListEventModel entryList = EntryListEventModel.fromJson(_formData);
    entryList.guests = _userListEntry;

    eventEntryListHelper.createEntryList(entryList: entryList).then((data) {
      Navigator.of(context).pop();
      _showSucessPopUp();
      setState(() {
        _linkGuestcontroller.text = data.dynamicLink;
      });
    }).catchError((onError, trace) {
      Navigator.of(context).pop();
      _formData['eventId'] = null;
      print("Erro ao criar lista $trace");
      if (onError is NoCriticalException) {
        _showSucessPopUp();
        return;
      }
      if (onError is HttpBussinessException) {
        showWarning(context,
            content:
                "Não foi possível criar a sua lista.\n${(onError).message}");
      } else {
        showError(context,
            content: "Ocorreu um erro não esperado ao salvar lista.");
      }
    });
  }

  void _showSucessPopUp({String message = "Lista criada com sucesso"}) {
    showInfo(
        // onPressed: () {
        //       Navigator.pushNamed(context, RoutesPages.movieAdmin.name);
        // },
        context: context,
        content: message,
        title: "Aêêêêêêêêê");
  }

  void _selectDataEventAutocomplete(AutoCompleteItem value) {
    if (value.isNotNull()) {
      _formData['eventId'] = value.id;
      _formData['eventTitle'] = value.label;
      _formData['eventPlace'] = value.data!['eventPlace'];
      _formData['eventDate'] = value.data!['eventDate'];
    } else {
      _formData['eventId'] = null;
    }
  }

  cleanForm() {
    setState(() {
      _formKey.currentState?.reset();
      _formData = {};
      //   FocusScope.of(context).unfocus();
    });
  }

  void inforGuestRequirements() {
    showInfo(
        context: context,
        title: "Informações sobre convidados",
        content:
            "O acesso e validação do ingresso serão feitos pelo app. Portato "
            "é necessario que seus convidados tenham uma conta ativa no Linkdance para que consigam ser adicionados da lista.",
        labelButton: "Tendeu");
  }

  void showDialogRegistryIncomplete(
      {required List<dynamic> errors, required BuildContext context}) {
    showWarning(context,
        labelButton: "Fechar",
        content:
            "Seu cadastro não está completo, você precisa preencher os seguintes campos para completar seu cadastro: \n"
            "${errors.map((e) => "  * $e").join("  \n")}"
            " \nÉ necessário completar o cadastro de perfil para criar listas.",
        extraActionlabel: "Editar perfil", extraActionCallBack: () {
      Navigator.pushNamed(context, RoutesPages.registration.name,
          arguments: _userSession);
    });
  }
}
