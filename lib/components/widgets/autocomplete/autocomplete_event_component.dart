import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AutoCompleteEventComponent extends StatefulWidget {

  void Function(AutoCompleteItem item)? onSelected;

  TextEditingController textEdit = TextEditingController();
  FocusNode focus = FocusNode();
  TextInputAction textInputAction;
  InputDecoration? inputDecoration;
  bool required;
  bool isStatefullSelection;
  //Se for necessario chamar o autocomplete dentro de uma Stack, passar false
  bool isExpanded;

  AutoCompleteEventComponent({Key? key,
    this.onSelected,
    required this.isStatefullSelection,
    this.required=false,
    this.isExpanded = false,
    this.textInputAction = TextInputAction.search,
    this.inputDecoration=   const InputDecoration(labelText: "Evento"),
  }) : super(key: key);

  @override
  State<AutoCompleteEventComponent> createState() =>
      _AutoCompleteEventState();
}

class _AutoCompleteEventState extends State<AutoCompleteEventComponent> {

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
      isStatefullSelection : widget.isStatefullSelection,
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
        AutoCompleteItem.custom(
          label: event.title,
          id: event.id,
          customShowItem: _customViewItem(event: event),
          data: {"eventPlace" :event.place,"eventDate":event.eventDate},
          filterField:
          "${event.title},${event.description}"
        ))
        .toList();
  }

  Column _customViewItem({required EventModel event}) {
    var subTitleStyle = TextStyle(color: Colors.grey,fontSize: 10);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(event.title),
        Row(children: [Text(event.eventDate.showString(), style: subTitleStyle),Text(" - ${event.place.capitalizePhrase()}",style: subTitleStyle),],)
      ],

    );
  }


}
