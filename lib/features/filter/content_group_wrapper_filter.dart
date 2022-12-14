import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_rhythm_component.dart';
import 'package:link_dance/components/widgets/filter_component.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/filter/base_wrapper_filter.dart';

import 'package:link_dance/repository/content_group_respository.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../repository/base_repository.dart';
import '../../components/widgets/filter_component.dart';

class ContentGroupWrapperFilter extends BaseWrapperFilter  {

  ContentGroupWrapperFilter({required BuildContext context, FilterOptions? options})
      : super(context: context) {
    super.init();
  }

  @override
  FilterComponent defaultOptions() {
     options = FilterOptions(callBackFieldQuery: apllyFilter, fieldsFilter: [
      FilterField(label: "Escola", queryFieldName: "school"),
      FilterField(
          label: "Ritmo",
          queryFieldName: "rhythm",
          widgetSearch: getAutocompleteRhythm()),
      FilterField(label: "Turma", queryFieldName: "title"),
    ]);
    return FilterComponent(
      filterOptions: options,
      changeIndex: changeIndex,
    );
  }

  @override
  void apllyFilter(FilterField param) {
    var repository =
        Provider.of<ContentGroupRepository>(context, listen: false);
    repository.clearNotify();
    onLoading(context);
    if (param.queryFieldName == "title") {
      repository.like(
          condition: QueryCondition(
              fieldName: param.queryFieldName, contains: param.valueFieldForm),
          orderBy: param.queryFieldName).whenComplete(() => Navigator.of(context).pop());
    } else {
      repository.getAllPagination(conditions: [
        QueryCondition(
            fieldName: param.queryFieldName, isEqualTo: param.valueFieldForm)
      ]).whenComplete(() => Navigator.of(context).pop());
    }
  }


}
