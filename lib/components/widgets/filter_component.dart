import 'package:link_dance/components/input_fields/date_field.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../input_fields/text_field.dart';
import '../../core/decorators/box_decorator.dart';

class FilterComponent extends StatefulWidget {
  FilterOptions filterOptions;
  Function(int index)? changeIndex;

  FilterComponent({Key? key, required this.filterOptions, this.changeIndex})
      : super(key: key);

  @override
  State<FilterComponent> createState() => _FilterComponentState();
}

class _FilterComponentState extends State<FilterComponent> {
  final _formKey = GlobalKey<FormState>();

  late List<bool> _selections;
  TextEditingController textController = TextEditingController();

  FocusNode focusNode = FocusNode();
  FocusNode focusNodeAutoComplete = FocusNode();
  late Widget inputWidget;
  int index = 0;
  late MainAxisSize _mainAxisSize;

  @override
  void initState() {
    super.initState();
    _selections =
        List.generate(widget.filterOptions.fieldsFilter.length, (_) => false);
    _selections[widget.filterOptions.defaultLabelFilter] = true;
    index = widget.filterOptions.defaultLabelFilter;
    var defaultDataType = widget.filterOptions
        .fieldsFilter[widget.filterOptions.defaultLabelFilter].dataType;
    inputWidget = _getDefaultnput(dataType: defaultDataType);

  }

  @override
  Widget build(BuildContext context) {
    _mainAxisSize =
        widget.filterOptions.isMaxSize ? MainAxisSize.max : MainAxisSize.min;

    return Material(
      child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: _mainAxisSize,
              children: [
                sizedBox20(),
                sizedBox20(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: OutlinedButton(
                        child: const Text("Fechar",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Filtrar por "),
                      ],
                    )
                  ],
                ),
                sizedBox20(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_tootleButtons()],
                ),
                Stack(children: [inputWidget]),
              ],
            ),
          )),
    );
  }

  Widget dateInput() {
    return DateInputField(
      label: "",
      focusNode: focusNode,
      showIcon: false,
      textInputAction: TextInputAction.search,
      textController: textController,
      onSubmit: (value) {
        var filter = widget.filterOptions.fieldsFilter[index];
        filter.valueFieldForm = textController.text;
        widget.filterOptions.callBackFieldQuery(filter);
        Navigator.of(context).pop();
      },
    );
  }

  Widget textField() {
    return CustomTextField(
      focusNode: focusNode,
      required: false,
      textInputAction: TextInputAction.search,
      label: "",
      onSubmit: (value) {
        var filter = widget.filterOptions.fieldsFilter[index];
        filter.valueFieldForm = textController.text;
        widget.filterOptions.callBackFieldQuery(filter);
        Navigator.of(context).pop();
      },
      controller: textController,
    );
  }

  Widget _getDefaultnput({DataTypeQuery dataType = DataTypeQuery.string}) {

    if ( widget.filterOptions.widgetSearch!=null){
      return widget.filterOptions.widgetSearch!;
    }

    if (dataType == DataTypeQuery.string) {
      return textField();
    } else {
      return dateInput();
    }
  }

  _tootleButtons() {
    return ToggleButtons(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderColor: Colors.white30,
      renderBorder: true,
      isSelected: _selections,
      onPressed: (int index) {
        widget.filterOptions.defaultLabelFilter = index;
        this.index = index;
        widget.changeIndex!(index);
        var fieldFilter = widget.filterOptions.fieldsFilter[index];

        setState(() {
          if (fieldFilter.widgetSearch != null) {
            inputWidget = fieldFilter.widgetSearch!;
          } else {
            inputWidget = _getDefaultnput(dataType: fieldFilter.dataType);
          }
          _selections = List.generate(
              widget.filterOptions.fieldsFilter.length, (_) => false);
          _selections[index] = true;
        });
      },
      children: _buidButtons(),
    );
  }

  List<Widget> _buidButtons() {
    return (widget.filterOptions.fieldsFilter
        .map((e) => _toogleButton(e.label))
        .toList());
  }

  Widget _toogleButton(String label) {
    return Padding(
        padding: EdgeInsets.only(left: 15, right: 15), child: Text(label));
  }
}

class FilterOptions {
  Function(FilterField) callBackFieldQuery;
  int defaultLabelFilter;
  List<FilterField> fieldsFilter;
  bool isMaxSize;
  
  Widget? get widgetSearch=> fieldsFilter[defaultLabelFilter].widgetSearch;

  FilterOptions(
      {required this.callBackFieldQuery,
      required this.fieldsFilter,
      this.isMaxSize = true,
      this.defaultLabelFilter = 0});
}

class FilterField {
  String label;
  final String? _orderBy;
  final String queryFieldName;
  ConditionQuery? conditionQuery;
  String valueFieldForm;
  DataTypeQuery dataType;
  Widget? widgetSearch;

  FilterField({
    required this.label,
    this.conditionQuery,
    this.widgetSearch,
    required this.queryFieldName,
    String? orderBy,
    this.dataType = DataTypeQuery.string,
    this.valueFieldForm = "",
  }) : _orderBy = orderBy ?? queryFieldName;

  String? get orderBy => _orderBy;

  QueryCondition get queryEquals => QueryCondition(
      fieldName: queryFieldName,
      isEqualTo: valueFieldForm);


  @override
  String toString() {
    return 'FilterField{label: $label, queryFieldName: $queryFieldName, valueFieldForm: $valueFieldForm}';
  }
}


