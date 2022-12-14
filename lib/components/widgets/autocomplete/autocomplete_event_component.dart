import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:link_dance/repository/content_group_respository.dart';
import 'package:link_dance/repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../repository/movie_repository.dart';

class AutoCompleteEventComponent extends StatefulWidget {

  void Function(AutoCompleteItem item)? onSelected;

  TextEditingController textEdit = TextEditingController();
  FocusNode focus = FocusNode();
  TextInputAction textInputAction;
  InputDecoration? inputDecoration;
  bool required;
  //Se for necessario chamar o autocmplete dentro de uma Stack, passar false
  bool isExpanded;

  AutoCompleteEventComponent({Key? key,
    this.onSelected,
    this.required=false,
    this.isExpanded = false,
    this.textInputAction = TextInputAction.search,
    this.inputDecoration=   const InputDecoration(labelText: "Evento"),
  }) : super(key: key);

  @override
  State<AutoCompleteEventComponent> createState() =>
      _AutoCompleteRhythmState();
}

class _AutoCompleteRhythmState extends State<AutoCompleteEventComponent> {

  late EventRepository repository;
  late AuthenticationFacate authentication;
  @override
  Widget build(BuildContext context) {
    repository = Provider.of<EventRepository>(context, listen: false);
    authentication = Provider.of<AuthenticationFacate>(context, listen: false);

    return AutocompleteComponent(
      required: widget.required,
      isExpanded: widget.isExpanded,
      decoration: widget.inputDecoration,
      loadData: loadDataAutocomplete,
      textInputAction: TextInputAction.search,
      onSelected: widget.onSelected,
      textEditing: widget.textEdit,
      focusNode: widget.focus,
    );
  }

  Future<List<AutoCompleteItem>> loadDataAutocomplete() async {
    var userId = authentication.user!.id;
    var data = await repository.listBase(conditions: [QueryCondition(fieldName: "ownerId",isEqualTo: userId)]);
    return data!
        .map((event) =>
        AutoCompleteItem(
          id: event.id,
          label: event.title,
          metaData: event.uriBanner,
          filterField:
          "${event.title},${event.description}"
        ))
        .toList();
  }


}
