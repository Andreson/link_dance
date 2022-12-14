import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/repository/teacher_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../repository/movie_repository.dart';

class AutoCompleteTeacherComponent extends StatefulWidget {

  void Function(AutoCompleteItem item)? onSelected;

  TextEditingController textEdit = TextEditingController();
  FocusNode focus = FocusNode();
  TextInputAction textInputAction;
  InputDecoration? inputDecoration;

  //Se for necessario chamar o autocmplete dentro de uma Stack, passar false
  bool isExpanded;

  AutoCompleteTeacherComponent({
    this.onSelected,
    this.isExpanded = true,
    this.textInputAction = TextInputAction.search,
    this.inputDecoration,
  });

  @override
  State<AutoCompleteTeacherComponent> createState() =>
      _AutoCompleteRhythmState();
}

class _AutoCompleteRhythmState extends State<AutoCompleteTeacherComponent> {
  late TeacherRepository repository;


  @override
  Widget build(BuildContext context) {
    repository = Provider.of<TeacherRepository>(context, listen: false);

    return AutocompleteComponent(
      isExpanded: false,
      decoration: widget.inputDecoration,
      loadData: loadDataAutocomplete,
      textInputAction: TextInputAction.search,
      onSelected: widget.onSelected,
      textEditing: widget.textEdit,
      focusNode: widget.focus,
    );
  }


  Future<List<AutoCompleteItem>> loadDataAutocomplete() async {
    var data = await repository.loadData();
    return data
        .map((e) => AutoCompleteItem(id: e.userId, label: e.name, filterField: e.name))
        .toList();
  }
}
