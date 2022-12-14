import 'package:flutter/material.dart';
import '../../core/factory_widget.dart';
import '../../core/theme/fontStyles.dart';
class MailInputField extends StatelessWidget {

  final String label;
  String? hint;
  FormFieldSetter<String>? onSaved;
  String? initialValue;
  TextEditingController? controller;
  bool readOnly;
  bool required;
  FocusNode? focusNode;
  MailInputField({Key? key,this.focusNode, this.readOnly=false, required this.label, this.hint, this.onSaved, this.initialValue, this.controller, this.required=false}) : super(key: key);
  @override
  Widget build(BuildContext context) {


    return TextFormField(
      style: readOnly ?formInputsStylesRead:formInputsStyles,
      focusNode: focusNode,
      onSaved: onSaved,
      readOnly:readOnly ,
      controller: controller,
      initialValue: initialValue,
      validator: (value){
        if ( RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value.toString()) ) {
          return null;
        } else {
          return "Email Inválido, fafor informar um email no formado 'username@provedor.yyy'";
        }
      },
      //inputFormatters: [mailMask()],
      keyboardType: TextInputType.emailAddress,
      decoration:  InputDecoration(
        icon: const Icon(Icons.email_outlined),
        hintText: hint ?? label,
        label: labelRequired(required: required, label: label),
      ),
    );
  }
}