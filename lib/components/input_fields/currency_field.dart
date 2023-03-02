import 'package:link_dance/core/theme/fontStyles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/factory_widget.dart';
class CurrencyInputField extends StatelessWidget {

  final String label;
  String? hint;
  String? initialValue;
  bool required;
  bool hideIcon;
  FormFieldSetter<String>? onSaved;
  FocusNode? focus;
  CurrencyInputField({Key? key, this.label="",this.focus, this.initialValue, this.hint, this.onSaved, this.required=true, this.hideIcon=false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
 
    return TextFormField(
      focusNode: focus,
      style: formInputsStyles,
      onSaved:onSaved,
      validator: required ? defaultInputValidator : null,
      initialValue:initialValue ,
      inputFormatters: [currencyMask()],

      keyboardType: TextInputType.number,
      decoration:  InputDecoration(
        icon:hideIcon ?null: const Icon(Icons.monetization_on_outlined),
        hintText: hint  ,
        label: labelRequired(required: required, label: label)
      ),
    );
  }

  String? defaultInputValidator(String? value) {
    if (!required) {
      return null;
    }
    if (value != null && value
        .toString()
        .isNotEmpty) {
      return null;
    } else {
      return "Campo obrigatório!";
    }
  }
}