import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_rhythm_component.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_teacher_component.dart';
import 'package:link_dance/components/widgets/filter_component.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/filter/base_wrapper_filter.dart';

import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:link_dance/repository/teacher_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../repository/base_repository.dart';
import '../../components/widgets/filter_component.dart';

class TeacherWrapperFilter  extends BaseWrapperFilter  {

  TeacherWrapperFilter({required BuildContext context, FilterOptions? options})
      : super(context: context) {
  super.init();
  }


  FilterComponent defaultOptions() {
    options = FilterOptions(
        callBackFieldQuery: apllyFilter,
        defaultLabelFilter: 0,
        fieldsFilter: [
          FilterField(
              label: "Ritmo",
              queryFieldName: "danceRhythms",
              conditionQuery: ConditionQuery.arrayContainsAny,
              widgetSearch: getAutocompleteRhythm()),
          FilterField(label: "Nome", queryFieldName: "name"),
        ]);
    return FilterComponent(
      filterOptions: options,
      changeIndex: changeIndex,
    );
  }



  void apllyFilter(FilterField param) {
    var repository = Provider.of<TeacherRepository>(context, listen: false);
    repository.clearNotify();
    onLoading(context);
    if (param.queryFieldName == "name") {
      repository.likeSearchBase(
        orderBy: "name",
        condition: QueryCondition(
            fieldName: param.queryFieldName,
            contains: param.valueFieldForm,
            ),
      ).whenComplete(() => Navigator.of(context).pop());
    } else {
      repository.listBase(conditions: [
        QueryCondition(
            fieldName: param.queryFieldName,
            arrayContainsAny: [param.valueFieldForm],
         ),
      ], orderBy: "name").whenComplete(() => Navigator.of(context).pop());;
    }
  }
}
