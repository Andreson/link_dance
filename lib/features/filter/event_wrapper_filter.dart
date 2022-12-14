import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_rhythm_component.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_teacher_component.dart';
import 'package:link_dance/components/widgets/filter_component.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/filter/base_wrapper_filter.dart';

import 'package:link_dance/repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../repository/base_repository.dart';
import '../../components/widgets/filter_component.dart';

class EventWrapperFilter extends BaseWrapperFilter {
  EventWrapperFilter({required BuildContext context, FilterOptions? options})
      : super(context: context) {
    super.init();
  }

  @override
  FilterComponent defaultOptions() {
    options = FilterOptions(
        callBackFieldQuery: apllyFilter,
        defaultLabelFilter: 2,
        fieldsFilter: [
          FilterField(
              label: "Data",
              queryFieldName: "eventDate",
              dataType: DataTypeQuery.date),
          FilterField(
              label: "Organizador",
              queryFieldName: "userId",
              widgetSearch: getAutocompleteTeacher()),
          FilterField(
              label: "Ritmo",
              queryFieldName: "rhythm",
              widgetSearch: getAutocompleteRhythm()),
          FilterField(label: "Nome", queryFieldName: "title"),
        ]);
    return FilterComponent(
      filterOptions: options,
      changeIndex: changeIndex,
    );
  }

  @override
  void apllyFilter(FilterField param) {
    var repository = Provider.of<EventRepository>(context, listen: false);
    repository.clearNotify();
    print("param query event wrapper $param");
    onLoading(context);
    if (param.queryFieldName == "title") {
      repository.likeSearch(
          condition: QueryCondition(
              fieldName: param.queryFieldName, contains: param.valueFieldForm),
          orderBy: param.queryFieldName).whenComplete(() => Navigator.of(context).pop());
    } else if (param.queryFieldName == "eventDate") {
      var field = QueryCondition(
          fieldName: param.queryFieldName,
          isGreaterThanOrEqualTo: param.valueFieldForm.toDate());
      repository.listBase(
          orderDesc: false, orderBy: "eventDate", conditions: [field]).whenComplete(() => Navigator.of(context).pop());
    } else {
      repository.listBase(conditions: [
        QueryCondition(
            fieldName: param.queryFieldName, isEqualTo: param.valueFieldForm)
      ]).whenComplete(() => Navigator.of(context).pop());;
    }
  }
}
