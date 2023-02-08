import 'package:flutter/material.dart';
import '../../core/factory_widget.dart';
import '../../core/theme/fontStyles.dart';
class PhoneInputField extends StatelessWidget {

  final String label;
  String? hint;
  String? initialValue;
  FormFieldSetter<String>? onSaved;
   FocusNode? focus;

  PhoneInputField({Key? key,this.focus, required this.label,this.initialValue, this.hint, this.onSaved}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return TextFormField(
      focusNode: focus,
      initialValue: initialValue,
      style: formInputsStyles,
        onSaved:onSaved,
      inputFormatters: [phoneMask(initValue: initialValue)],
      keyboardType: TextInputType.phone,
      decoration:  InputDecoration(

        hintText: hint ?? label,
        labelText: label,
      ),
    );
  }
}