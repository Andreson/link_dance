import 'package:link_dance/core/factory_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/fontStyles.dart';

class CustomTextField extends StatelessWidget {
  final String label;

  String? hint;
  Widget? icon;
  TextInputType? inputType;
  bool required;
  String? Function(String? value)? customValidator;
  IconButton? suffixIcon;
  IconButton? prefixIcon;

  String? initialValue;
  TextInputAction? textInputAction;
  FormFieldSetter<String>? onSaved;
  FormFieldSetter<String>? onSubmit;
  List<TextInputFormatter>? inputFormatter;
  VoidCallback? onEditingComplete;
  ValueChanged<String>? onChanged;
  TextEditingController? controller;
  FocusNode? focusNode;
  int? maxLines;
   IconData? iconData;

  CustomTextField({Key? key,
    this.label="",
    this.hint,
    this.iconData,
    this.maxLines = 1,
    this.customValidator,
    this.required = true,
    this.icon,
    this.focusNode,
    this.suffixIcon,
    this.prefixIcon,
    this.initialValue,
    this.textInputAction = TextInputAction.next,
    this.onSaved,
    this.inputFormatter,
    this.onEditingComplete,
    this.onChanged,
    this.onSubmit,
    this.controller,
    this.inputType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    focusNode = focusNode ?? FocusNode();
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      focusNode: focusNode,
      style: formInputsStyles,

      initialValue: initialValue,
      inputFormatters: inputFormatter,
      textInputAction: textInputAction ?? TextInputAction.next,
      validator: customValidator ?? defaultInputValidator,
      keyboardType: inputType,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      onSaved: onSaved,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
          icon: getIcon(),
          hintText: hint ?? label,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: labelRequired(required: required, label: label),
          prefixIcon:prefixIcon,
          suffixIcon: suffixIcon),
    );
  }


  Widget? getIcon() {
    if ( icon==null && iconData!=null) {
      return Icon(iconData,size: 18,);
    }
    else if ( icon!=null ){
      return icon;
    }
    return null;
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
