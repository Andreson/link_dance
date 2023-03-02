import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/input_fields/text_field.dart';
import 'package:link_dance/components/not_found_card.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_event_component.dart';
import 'package:link_dance/features/event/entry_list/entry_list_helper.dart';
import 'package:link_dance/features/event/model/entry_list_model.dart';
import 'package:link_dance/features/event/model/guest_list_entry_model.dart';
import 'package:link_dance/features/event/repository/event_entry_list_repository.dart';

import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/functions/dialog_functions.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/upload_files/file_upload.dart';
import 'package:link_dance/features/movie/model/movie_model.dart';
import 'package:link_dance/features/movie/repository/movie_repository.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/factory_widget.dart';

class EventEntryListFormComponent extends StatefulWidget {
  final GlobalKey<MovieUploadFormState>? key;

  EntryListEventModel? entryListEventModel;

  EventEntryListFormComponent({this.key, this.entryListEventModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MovieUploadFormState();
}

class MovieUploadFormState extends State<EventEntryListFormComponent> {
  final _formKey = GlobalKey<FormState>();
  EntryListRepository entryListRepository = EntryListRepository();

  FileUpload _fileUpload = FileUpload();

  Map<String, dynamic> _formData = {};

  late EventEntryListHelper eventEntryListHelper;
  List<GuestEntryListModel> _userListEntry = [];
  late AuthenticationFacate _authentication;
  late AutoCompleteEventComponent _autoCompleteEventComponent;

  late UserModel _userSession;

  bool isReadOnly = false;
  bool titleReadOnly = false;
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _emailGuestFocus = FocusNode();

  final TextEditingController _emailGuestcontroller = TextEditingController();
  final TextEditingController _linkGuestcontroller = TextEditingController();
  final TextEditingController _titlecontroller = TextEditingController();

  String msgVideoSelect =
      "Por favor, selecione um video para upload ou informe uma URL válida de um video do Youtube!";

  @override
  void initState() {
    _authentication = Provider.of<AuthenticationFacate>(context, listen: false);

    _userSession = _authentication.user!;
    if (widget.entryListEventModel != null) {
      isReadOnly = true;
      _titlecontroller.text = widget.entryListEventModel!.label;
    } else {

      if ( // _userSession.userType!=UserType.admin &&
          _userSession.userType != UserType.promoter) {
        titleReadOnly = true;
        _titlecontroller.text = _userSession.name;
      }else {
        titleReadOnly = false;
        _titlecontroller.text = "";
      }
      _formData['ownerId']=_userSession.id;
      _formData['ownerEmail']=_userSession.email;

    }
    _autoCompleteEventComponent = AutoCompleteEventComponent(
      isExpanded: true,
      required: true,
      onSelected: _selectDataEventAutocomplete,
    );
    eventEntryListHelper = EventEntryListHelper(auth: _authentication);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    bool isExpanded = false;
    if (false) {
    } else {
      _linkGuestcontroller.text = "Salve a lista para visualizar o link";
    }
    _autoCompleteEventComponent = AutoCompleteEventComponent(
      isExpanded: isExpanded,
      required: true,
      onSelected: _selectDataEventAutocomplete,
    );
    _autoCompleteEventComponent.textEdit.text = "Digite o nome do evento";
  }

  void _initWidgets() {
    _userSession = _authentication.user!;
    entryListRepository = Provider.of<EntryListRepository>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _initWidgets();
    _emailGuestcontroller.text = "balloserviceit@gmail.com";
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar lista"),
        actions: [buttonSaveRegistry(onPressed: () {})],
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
                        textAlign: titleReadOnly ? TextAlign.center :TextAlign.left,
                        required: false,
                        controller: _titlecontroller,
                        readOnly: titleReadOnly,
                        label: "Nome da lista",
                      textStyle:titleReadOnly ? const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold
                      ):null,
                        ),
                    _autoCompleteEventComponent,
                    CustomTextField(
                        readOnly: true,
                        required: false,
                        textStyle:  TextStyle(
                            fontSize: 14,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold
                        ),
                        controller: _linkGuestcontroller,
                        label: "Link para convite",
                        suffixIcon: IconButton(
                          iconSize: 20,
                          onPressed: () {
                            if (_linkGuestcontroller.text != "") {
                              copyClipboardData(
                                  _linkGuestcontroller.text, context,
                                  mensage: "Link convite copiado");
                            }
                          },
                          icon: const Icon(Icons.copy),
                        ) ),
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
    }
    else {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar(mensage: "Usuário de email \"$email\" já esta na lista lista",level:  LevelEnum.warn));
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

  Widget _buildList() {
    return Flexible(
      child: Container(
        height: 300,
        decoration: box(opacity: 0.4, allBorderRadius: 10),
        child: Column(children: [
          const Text("Convidados na lista "),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                  itemCount: _userListEntry.length,
                  itemBuilder: (BuildContext context, int index) {
                    var backgroundColor = Colors.transparent;
                    if (_userListEntry.isEmpty) {
                      return DataNotFoundComponent();
                    }
                    if (index % 2 == 0) {
                      backgroundColor = Colors.black38;
                    }
                    return _itemBuild(
                        user: _userListEntry[index],
                        brackgroudColor: backgroundColor,
                        index: index);
                  }),
            ),
          )
        ]),
      ),
    );
  }

  bool _validations() {
    var formIsvalid = _formKey.currentState!.validate();

    if (!formIsvalid) {
      return false;
    } else {
      _formKey.currentState?.save();
    }

    return true;
  }

  save() async {
    onLoading(context, actionMesage: "Salvando registro");
    EntryListEventModel entryList = EntryListEventModel.fromJson(_formData);


    entryListRepository.saveOrUpdateBase(data: entryList.body())
        .then((value) {
      Navigator.of(context).pop();

      showInfo(
          onPressed: () {
            Navigator.pushNamed(context, RoutesPages.movieAdmin.name);
          },
          context: context,
          content: "Lista criada com sucesso",
          title: "Aêêêêêêêêê");
    }).catchError((e, stacktrace) {
      Navigator.of(context).pop();
      showError(context, content: "Erro ao salvar registro do video");
      print("Erro ao salvar registro do video ${stacktrace}");
    });
  }

  ListTile _itemBuild(
      {required GuestEntryListModel user,
      Color? brackgroudColor = Colors.transparent,
      required int index}) {
    var textStyle = const TextStyle(fontSize: 14);
    return ListTile(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.circular(1),
      ),
      tileColor: brackgroudColor,
      leading: getImageThumb(pathImage: user.photoUrl),
      title: Text(
        user.name,
        style: textStyle,
      ),
      trailing: IconButton(
          onPressed: () {
            setState(() {
              _userListEntry.removeAt(index);

              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBar(mensage: "Usuário removido da lista"));
            });
          },
          icon: const Icon(
            FontAwesomeIcons.trash,
            size: 16,
            color: Colors.redAccent,
          )),
      subtitle: Row(children: [
        Flexible(child: Text(user.email!)),
      ]),
    );
  }

  void _selectDataEventAutocomplete(AutoCompleteItem value) {
    if (value.isNotNull()) {
      _formData['eventId'] = value.id;
      _formData['eventTitle'] = value.label;
      _formData['eventPlace'] = value.data!['eventPlace'];
      _formData['eventDate'] = value.data!['eventDate'];
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
}
