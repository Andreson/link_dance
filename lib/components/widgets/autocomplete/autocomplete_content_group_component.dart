import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/repository/content_group_respository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/movie/repository/movie_repository.dart';

class AutoCompleteContentGroupComponent extends StatefulWidget {

  void Function(AutoCompleteItem item)? onSelected;

  TextEditingController textEdit = TextEditingController();
  FocusNode focus = FocusNode();
  TextInputAction textInputAction;
  InputDecoration? inputDecoration;
  bool required;
  //Se for necessario chamar o autocmplete dentro de uma Stack, passar false
  bool isExpanded;

  AutoCompleteContentGroupComponent({Key? key,
    this.onSelected,
    this.required=false,
    this.isExpanded = false,
    this.textInputAction = TextInputAction.search,
    this.inputDecoration=   const InputDecoration(labelText: "Turma"),
  }) : super(key: key);

  @override
  State<AutoCompleteContentGroupComponent> createState() =>
      _AutoCompleteRhythmState();
}

class _AutoCompleteRhythmState extends State<AutoCompleteContentGroupComponent> {

  late ContentGroupRepository repository;

  @override
  Widget build(BuildContext context) {
    repository = Provider.of<ContentGroupRepository>(context, listen: false);

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
    var data = await repository.getAllPagination();
    print("Call load data for loadDataContentGroupAutocomplete");
    return data!
        .map((contentGroup) =>
        AutoCompleteItem(
          id: contentGroup.id,
          subtitle: Text(contentGroup.school),
          data: {"imageUrl":contentGroup.imageUrl},
          label: contentGroup.title,
          filterField:
          "${contentGroup.title},${contentGroup.school},${contentGroup
              .description}",
        ))
        .toList();
  }


}
