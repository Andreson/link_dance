import 'package:link_dance/core/theme/fontStyles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/factory_widget.dart';
class CurrencyInputField extends StatelessWidget {

  final String label;
  String? hint;
  String? initialValue;
  bool required;
  FormFieldSetter<String>? onSaved;

  CurrencyInputField({Key? key, required this.label, this.initialValue, this.hint, this.onSaved, this.required=true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
 
    return TextFormField(
      style: formInputsStyles,
      onSaved:onSaved,
      initialValue:initialValue ,
      inputFormatters: [currencyMask()],

      keyboardType: TextInputType.number,
      decoration:  InputDecoration(
        icon: const Icon(Icons.monetization_on_outlined),
        hintText: hint ?? label,
        label: labelRequired(required: required, label: label)
      ),
    );
  }
}