
import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/input_fields/text_field.dart';
import 'package:link_dance/components/not_found_card.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_event_component.dart';
import 'package:link_dance/core/exception/custom_exeptions.dart';
import 'package:link_dance/core/exception/http_exceptions.dart';
import 'package:link_dance/core/theme/fontStyles.dart';
import 'package:link_dance/features/event/components/entry_list_grid.dart';
import 'package:link_dance/features/event/entry_list/entry_list_form_.dart';
import 'package:link_dance/features/event/entry_list_helper.dart';
import 'package:link_dance/features/event/model/entry_list_model.dart';
import 'package:link_dance/features/event/model/guest_list_entry_model.dart';
import 'package:link_dance/features/event/repository/entry_list_repository.dart';

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

class EventEntryListShowGuestComponent extends StatefulWidget {
  final GlobalKey<EventEntryListShowGuestState>? key;

  EventEntryListShowGuestComponent({this.key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EventEntryListShowGuestState();
}

class EventEntryListShowGuestState extends State<EventEntryListShowGuestComponent> {
  final _formKey = GlobalKey<FormState>();
  EntryListRepository entryListRepository = EntryListRepository();


  late EntryListHelper eventEntryListHelper;
  List<GuestEntryListModel> _userListEntry = [];
  late AuthenticationFacate _authentication;
  late AutoCompleteEventComponent _autoCompleteEventComponent;

  late UserModel _userSession;
  final FocusNode _findGuestFocus = FocusNode();
  final TextEditingController _findGuestcontroller = TextEditingController();

  late EntryListEventModel entryList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    entryList =
        ModalRoute.of(context)!.settings.arguments as EntryListEventModel;

    _userListEntry = entryList.guests;
  }

  void _initWidgets() {}

  void _save() {}

  @override
  Widget build(BuildContext context) {
    _initWidgets();
    return Scaffold(
      appBar: AppBar(

        title: const Text("Convidados da lista"),

        actions: [
          buttonSaveRegistry(onPressed: () {
            _save();
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
                        required: false,
                        initialValue: entryList.label,
                        readOnly: true,
                        label: "Nome da lista",
                        textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold)),
                    CustomTextField(
                        required: false,
                        initialValue: entryList.eventLabel(),
                        readOnly: true,
                        label: "Evento",
                        textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold)),
                    _formFindGuest(),
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


  Container _formFindGuest() {
    return Container(
      decoration: box(opacity: 0.20, allBorderRadius: 10),
      child: Column(children: [
        sizedBox20(),
        Text("Procurar convidado por nome"),
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: CustomTextField(
                  onChanged: (value) => _filterUserList(),
                  focusNode: _findGuestFocus,
                  required: false,
                  controller: _findGuestcontroller,
                  label: "Nome do convidado",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      _userListEntry = entryList.guests;
                    });
                  },
                  icon: const Icon(Icons.filter_alt_off)),
            )
          ],
        ),
        sizedBox15(),
      ]),
    );
  }

  Future _filterUserList() async {
    var userName = _findGuestcontroller.text;
    print("object procurando usuario que comecem com $userName");

    List<GuestEntryListModel> tempList = _userListEntry
        .where((element) =>
            element.name.toLowerCase().startsWith(userName.toLowerCase()) ||
            element.name.toLowerCase().contains(userName.toLowerCase()))
        .toList();

    if (userName == "") {
      setState(() {
        _userListEntry = entryList.guests;
      });
    } else {
      setState(() {
        _userListEntry = tempList;
      });
    }
  }

  Widget _buildList() {
    return GuestGridEntryList(
        userListEntry: _userListEntry,
        iconTrailing: const Icon(
          FontAwesomeIcons.personCircleCheck,
          color: Colors.blue,
        ),
        actionTrailing: (index) {
          setState(() {
            //  _userListEntry.removeAt(index);
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBar(mensage: "Usuário removido da lista"));
          });
        });
  }
}
