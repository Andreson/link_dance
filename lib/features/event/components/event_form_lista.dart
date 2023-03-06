import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/components/input_fields/currency_field.dart';
import 'package:link_dance/components/input_fields/date_field.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/custom_exeptions.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/utils/dialog_functions.dart';
import 'package:link_dance/core/theme/fontStyles.dart';
import 'package:link_dance/core/theme/theme_data.dart';
import 'package:link_dance/features/event/model/event_list_model.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:link_dance/components/input_fields/text_field.dart';

class EventFormList extends StatefulWidget {
  EventModel? event;

  EventFormList({required Key key, this.event}):super(key: key);

  @override
  State<EventFormList> createState() => EventFormListState();
}

class EventFormListState extends State<EventFormList>  with AutomaticKeepAliveClientMixin  {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _timeMaleFocus = FocusNode();
  final FocusNode _timeFemaleFocus = FocusNode();

  final FocusNode _eventDateFocus = FocusNode();

  final TextEditingController _eventDateController = TextEditingController();

  Map<String, dynamic> _formData = {};
  EventListType _listType = EventListType.none;
  bool _hasList = false;
  bool requiredValueFemale= true;
  bool requiredValueMale= true;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    if (widget.event != null && widget.event!.listData != null) {
      var listTemp = widget.event!.listData!;
      _listType = listTemp.listType;
      _formData = listTemp.body();
      _listType = listTemp.listType;
      _eventDateController.text = listTemp.entriesUntil.showString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: box(opacity: 0.35, allBorderRadius: 10),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Row(children:   [
                     const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(FontAwesomeIcons.ticket),
                    ),
                      const Text(
                      "Tipo de Lista : ",
                      style: formInputsStyles,
                    ),
                      IconButton(onPressed: () {
                        _inforTypeList();
                      }, icon: Icon(FontAwesomeIcons.question))
                  ],),

                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [

                      Radio(
                          activeColor: Colors.white54,
                          groupValue: _listType,
                          value: EventListType.none,
                          onChanged: (newValue) {
                            setState(() {
                              _hasList = !_hasList;
                              if (_hasList) {
                                _listType = EventListType.vip;
                              } else {
                                _listType = EventListType.none;
                              }

                            });
                            _formData['listType']=_listType.name;
                          }),
                      const Text("Nenhuma",
                          style: TextStyle(color: inputField)),
                      Radio<EventListType>(
                          activeColor: Colors.white54,
                          groupValue: _listType,
                          value: EventListType.vip,
                          onChanged: (EventListType? newValue) {
                            setState(() {
                              _listType = newValue!;
                            });
                            _formData['listType']=_listType.name;
                          }),
                      const Text("Vip", style: TextStyle(color: inputField)),
                      Radio<EventListType>(
                          activeColor: Colors.white54,
                          groupValue: _listType,
                          value: EventListType.discount,
                          onChanged: (EventListType? newValue) {
                            setState(() {
                              _listType = newValue!;
                              requiredValueFemale  =true;
                              requiredValueMale  =true;
                            });
                            _formData['listType']=_listType.name;
                          }),
                      const Text("Desconto",
                          style: TextStyle(color: inputField)),
                      Radio<EventListType>(
                          activeColor: Colors.white54,
                          groupValue: _listType,
                          value: EventListType.mixed,
                          onChanged: (EventListType? newValue) {
                            setState(() {
                              _listType = newValue!;
                              requiredValueFemale  =false;
                              requiredValueMale  =false;
                            });

                            _formData['listType']=_listType.name;
                          }),
                      const Text("Mix",
                          style: TextStyle(color: inputField)),

                    ],
                  ),
                  if (_listType != EventListType.none)
                  DateInputField(
                      focusNode: _eventDateFocus,
                      textController: _eventDateController,
                      isDatePicker: true,
                      onlyFuture: true,
                      required: true,
                      label: "Data Limite para inscrições",
                      hint: "impede novos vips após data informada",
                      onSaved: (value) {
                        _formData['entriesUntil'] = value.toString().parseDateTimestamp();
                      }),
                  if (_listType != EventListType.none)
                    Row(
                      children: _getInputValueVipList(),
                    ),
                  if (_listType != EventListType.none)
                    Row(
                      children: [
                        Flexible(
                          child: CustomTextField(
                            icon: const Icon(FontAwesomeIcons.clock),
                              focusNode: _timeFemaleFocus,
                              inputType: TextInputType.number,
                              inputFormatter: [hourMask()],
                              label:"Horário entrada Feminino" ,
                              hint: "Horário entrada Feminino",
                              initialValue: _formData['vipTimeFemale'] ?? "",
                              onSaved: (value) {
                                _formData['vipTimeFemale'] = value;
                              }),
                        ),
                        sizedBoxH15(),
                        Flexible(
                          child: CustomTextField(
                              focusNode: _timeMaleFocus,
                              inputType: TextInputType.number,
                              inputFormatter: [hourMask()],
                              label: "Horário entrada masculino",
                              hint: "Horário entrada masculino",
                              initialValue: _formData['vipTimeMale'] ?? "",
                              onSaved: (value) {
                                _formData['vipTimeMale'] = value;
                              }),
                        )
                      ],
                    ),
                  if (_listType == EventListType.discount || _listType == EventListType.mixed)
                    _getInputValueDiscount(),
                  sizedBox30()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getInputValueVipList() {
    return [
      Flexible(
        child: TextFormField(
          decoration: const InputDecoration(
            icon: Icon(FontAwesomeIcons.personCirclePlus ),
            hintText: "QTDE Feminino",
            label: Text("QTDE Feminino"),
            hintStyle: TextStyle(fontSize: 13),
          ),
          textAlign: TextAlign.left,
          style: const TextStyle(color: inputField),
          inputFormatters: [_mask()],
          validator: (value) {
            if (value != null && value
                .toString()
                .isNotEmpty) {
              return null;
            } else {
              return "Campo obrigatório!";
            }
          },
          onSaved: (value) {
            _formData['femaleVip'] = int.parse(value ?? "0");
          },
          keyboardType: TextInputType.number,
          initialValue:
              _formData['femaleVip'].toString().emptyIfNull(value: "1000"),
        ),
      ),
      sizedBoxH15(),
      Flexible(
        child: TextFormField(

          decoration: const InputDecoration(
              label: Text("QTDE Masculino"),
              hintText: "QTDE Masculino",
              hintStyle: TextStyle(fontSize: 13)),
          textAlign: TextAlign.left,
          validator: (value) {
            if (value != null && value
                .toString()
                .isNotEmpty) {
              return null;
            } else {
              return "Campo obrigatório!";
            }
          },
          style: const TextStyle(color: inputField),
          inputFormatters: [_mask()],
          keyboardType: TextInputType.number,
          initialValue: _formData['maleVip'].toString().emptyIfNull(value: "0"),
          onSaved: (value) {
            _formData['maleVip'] = int.parse(value ?? "0");
            print("Male VIP ${_formData['maleVip']}");
          },
        ),
      )
    ];
  }

  _mask({String initValue = "0"}) {
    return MaskTextInputFormatter(
        initialText: initValue,
        mask: '####',
        type: MaskAutoCompletionType.lazy);
  }

  Row _getInputValueDiscount() {
    return Row(
      children: [
        sizedBoxH40(),
        Flexible(
          child: CurrencyInputField(

              hideIcon: true,
              label: "Valor feminino",
              initialValue:
                  _formData['femalePriceDiscount'].toString().emptyIfNull(value: "0"),
              required: requiredValueFemale,
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  _formData['femalePriceDiscount'] = value.parseDouble();
                }
              }),
        ),
        sizedBoxH15(),
        Flexible(
          child: CurrencyInputField(
              hideIcon: true,
              initialValue:
                  _formData['malePriceDiscount'].toString().emptyIfNull(),
              required: requiredValueMale,
              label: "Valor masculino",
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  _formData['malePriceDiscount'] = value.parseDouble();
                }
              }),
        ),
      ],
    );
  }

  bool _formIsValid() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  EventListModel? getData() {
    if (!_formIsValid()) {
      throw InvalidFormException("Formulario de lista inválido");
    }

    _formKey.currentState!.save();
    if ( _listType!=EventListType.none) {
      return EventListModel.fromJson(_formData);
    }
    return null;
  }

  void cleanForm() {

    _formKey.currentState?.reset();
  }

  void _inforTypeList() {
    showInfo(
        context: context,
        title: "Tipos de lista",
        content:
        "VIP      - Todos participantes da lista tem entrada gratuita.\n"
        "Desconto - Entrada com valor com desconto para os participantes da lista.\n"
        "Mix      - Entrada pode ser gratuita ou com desconto de acordo com definições especificadas.\n",
        labelButton: "Tendeu");
  }
}
