import 'package:link_dance/components/autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../features/movie/repository/movie_repository.dart';

class AutoCompleteRhythmComponent extends StatefulWidget {

  void Function(AutoCompleteItem item)? onSelected;

  TextEditingController textEdit = TextEditingController();
  FocusNode focus = FocusNode();
  TextInputAction textInputAction;
  InputDecoration? inputDecoration;
  bool required;

  //Se for necessario chamar o autocmplete dentro de uma Stack, passar false
  bool isExpanded;

  AutoCompleteRhythmComponent({

    this.required=false,

    this.onSelected,
    this.isExpanded = true,
    this.textInputAction = TextInputAction.search,
    this.inputDecoration=  const InputDecoration(labelText: "Ritmo"),
  });

  @override
  State<AutoCompleteRhythmComponent> createState() =>
      _AutoCompleteRhythmState();
}

class _AutoCompleteRhythmState extends State<AutoCompleteRhythmComponent> {
  late MovieRepository repository;


  @override
  Widget build(BuildContext context) {
    repository = Provider.of<MovieRepository>(context, listen: false);

    return AutocompleteComponent(

      required: widget.required,
      isExpanded: widget.isExpanded,
      decoration: widget.inputDecoration,
      loadData: loadDataAutocomplete,
      textInputAction: widget.textInputAction,
      onSelected: widget.onSelected,
      textEditing: widget.textEdit,
      focusNode: widget.focus,
    );
  }


  Future<List<AutoCompleteItem>> loadDataAutocomplete() async {
    var data = await repository.findRhythms();
    return data
        .map((e) => AutoCompleteItem(id: e, label: e, filterField: e))
        .toList();
  }
}
