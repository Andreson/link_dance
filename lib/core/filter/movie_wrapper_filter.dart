import 'package:link_dance/components/widgets/filter_component.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/factory_widget.dart';

import 'package:link_dance/repository/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../repository/base_repository.dart';
import 'base_wrapper_filter.dart';

class MovieWrapperFilter extends BaseWrapperFilter {
  MovieWrapperFilter({required BuildContext context, FilterOptions? options})
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
              queryFieldName: "createDate",
              dataType: DataTypeQuery.date),
          FilterField(
              label: "Professor",
              queryFieldName: "ownerId",
              widgetSearch: getAutocompleteTeacher()),
          FilterField(
              label: "Ritmo",
              queryFieldName: "rhythm",
              widgetSearch: getAutocompleteRhythm())
        ]);
    return FilterComponent(
      filterOptions: options,
      changeIndex: changeIndex,
    );
  }

  @override
  void apllyFilter(FilterField param) {
    var repository = Provider.of<MovieRepository>(context, listen: false);
    repository.clearNotify();
    print("param query event wrapper $param");
    onLoading(context);
    if (param.queryFieldName == "createDate") {
      var field = QueryCondition(
          fieldName: param.queryFieldName,
          isGreaterThanOrEqualTo: param.valueFieldForm.toDate());
      repository.listBase(
          orderDesc: false, orderBy: param.queryFieldName, conditions: [field]).whenComplete(() => Navigator.of(context).pop());
    } else {
      repository.listBase(orderDesc: true,  conditions: [
        QueryCondition(
            fieldName: param.queryFieldName, isEqualTo: param.valueFieldForm)
      ]).whenComplete(() => Navigator.of(context).pop());
    }
  }
}
