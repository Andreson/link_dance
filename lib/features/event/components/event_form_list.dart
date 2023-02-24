import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/components/input_fields/currency_field.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/custom_exeptions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/theme/fontStyles.dart';
import 'package:link_dance/core/theme/theme_data.dart';
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
  Map<String, dynamic> _formData = {};
  EventListType _listType = EventListType.none;
  bool _hasList = false;
  @override
  bool get wantKeepAlive => true;
  @override
  void didChangeDependencies() {
    if (widget.event != null && widget.event!.listData != null) {
      _listType = widget.event!.listData!.listType;
      _formData = widget.event!.deserialize();
    }
    super.didChangeDependencies();
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
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.ticket),
                      ),
                      const Text(
                        "Lista : ",
                        style: formInputsStyles,
                      ),
                      sizedBoxH15(),
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
                          }),
                      const Text("Vip", style: TextStyle(color: inputField)),
                      Radio<EventListType>(
                          activeColor: Colors.white54,
                          groupValue: _listType,
                          value: EventListType.discount,
                          onChanged: (EventListType? newValue) {
                            setState(() {
                              _listType = newValue!;
                            });
                          }),
                      const Text("Desconto",
                          style: TextStyle(color: inputField)),
                    ],
                  ),
                  if (_listType != EventListType.none)
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Row(
                        children: _getInputValueVipList(),
                      ),
                    ),
                  if (_listType != EventListType.none)
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Row(
                        children: [
                          Flexible(
                            child: CustomTextField(
                                focusNode: _timeFemaleFocus,
                                inputType: TextInputType.number,
                                inputFormatter: [hourMask()],
                                required: false,
                                hint: "Horário do vip Feminino",
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
                                required: false,
                                hint: "Horário do vip masculino",
                                initialValue: _formData['vipTimeMale'] ?? "",
                                onSaved: (value) {
                                  _formData['vipTimeMale'] = value;
                                }),
                          )
                        ],
                      ),
                    ),
                  if (_listType == EventListType.discount)
                    _getInputValueDiscount(),
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
            hintText: "QTDE Feminino",
            label: Text("QTDE Feminino"),
            hintStyle: TextStyle(fontSize: 13),
          ),
          textAlign: TextAlign.left,
          style: const TextStyle(color: inputField),
          inputFormatters: [_mask()],
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
              label: "Valor masculino",
              initialValue:
                  _formData['malePriceDiscount'].toString().emptyIfNull(),
              required: false,
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  _formData['malePriceDiscount'] = value.parseDouble();
                }
              }),
        ),
        sizedBoxH15(),
        Flexible(
          child: CurrencyInputField(
              hideIcon: true,
              initialValue:
                  _formData['femalePriceDiscount'].toString().emptyIfNull(),
              required: false,
              label: "Valor feminino",
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  _formData['femalePriceDiscount'] = value.parseDouble();
                }
              }),
        ),
      ],
    );
  }

  bool _validations() {
    // if (!_formKey.currentState!.validate()) {
    //   return false;
    // }
    return true;
  }

  Map<String, dynamic> getData() {
    // if (_validations()) {
    //   throw InvalidFormException("Formulario de lista inválido");
    // }
    return _formData;
  }

  void cleanForm() {}
}
