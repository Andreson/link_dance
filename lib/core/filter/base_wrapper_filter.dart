import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_rhythm_component.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_teacher_component.dart';
import 'package:link_dance/components/widgets/filter_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class BaseWrapperFilter {
  late FilterOptions options;
  late int index;
  late AutoCompleteTeacherComponent _autoCompleteTeacher;
  late AutoCompleteRhythmComponent _autocompleteRhythm;
  BuildContext context;
  late FilterComponent _filterComponent;
  BaseWrapperFilter({required this.context});
  FilterComponent get filter => _filterComponent;

  set filter(FilterComponent f) => _filterComponent = f;

  void apllyFilter(FilterField field);

  FilterComponent defaultOptions();

  void init() {
    _filterComponent = defaultOptions();
    index = options.defaultLabelFilter;

  }

  void changeIndex(int index) {
    this.index = index;
  }


  Widget getAutocompleteTeacher() {
    _autoCompleteTeacher = AutoCompleteTeacherComponent(
      onSelected: _selectDataTeachersAutocomplete,
      isExpanded: false,
    );
    return _autoCompleteTeacher;
  }

  Widget getAutocompleteRhythm() {
    _autocompleteRhythm = AutoCompleteRhythmComponent(
      onSelected: _selectDataRhythmsAutocomplete,
      inputDecoration: const InputDecoration(labelText: "Ritmo"),
      isExpanded: false,
    );
    return _autocompleteRhythm;
  }

  void _selectDataRhythmsAutocomplete(AutoCompleteItem value) {
    var field = options.fieldsFilter[index];
    field.valueFieldForm = value.id;
    apllyFilter(field);
    Navigator.of(context).pop();
  }

  void _selectDataTeachersAutocomplete(AutoCompleteItem value) {
    var field = options.fieldsFilter[index];
    field.valueFieldForm = value.id;
    apllyFilter(field);
    Navigator.of(context).pop();
  }
}
