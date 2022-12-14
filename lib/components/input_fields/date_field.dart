import 'package:link_dance/core/exception/exceptions.dart';
import 'package:flutter/material.dart';
import '../../core/factory_widget.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import '../../core/theme/fontStyles.dart';

class DateInputField extends StatelessWidget {
  final String label;
  String? hint;
  bool required;
  bool showIcon;
  bool onlyFutureDate;
  bool readOnly;
  bool onlyFuture;
  bool onlyPast;
  bool isDatePicker;
  DateTime? initValue;
  void Function()? onTap;
  FocusNode? focusNode;
  TextInputAction? textInputAction;
  TextEditingController? textController;
  FormFieldSetter<String>? onSubmit;
  late BuildContext _context;

  FormFieldSetter<String>? onSaved;

  DateInputField(
      {Key? key,
      this.isDatePicker = false,
      this.onlyFuture = false,
       this.onlyPast = false,
      this.textInputAction,
      this.onSubmit,
      this.focusNode,
      this.onTap,
      this.showIcon = true,
      this.textController,
      required this.label,
      this.readOnly = false,
      this.hint,
      this.initValue,
      this.onSaved,
      this.onlyFutureDate = false,
      this.required = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
  //  textController = textController ?? TextEditingController();
    _context = context;
    if( isDatePicker && textController==null) {
      var temp = initValue!=null?initValue!.showString() :"";
      textController = TextEditingController(text: temp);
      initValue=null;
    }
    return TextFormField(
      controller: textController,
      focusNode: focusNode,
      onTap: isDatePicker ? _selectDate : onTap,
      onFieldSubmitted: onSubmit,
      readOnly: readOnly,
      initialValue: initValue?.showString(),
      style: formInputsStyles,
      onSaved: onSaved,
      inputFormatters: [dateMask()],
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        icon: showIcon ? const Icon(Icons.date_range_rounded) : null,
        hintText: hint ?? label,
        label: labelRequired(required: required, label: label),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Campo obrigatório!";
        }
        final components = value.split("/");
        if (components.length == 3) {
          final day = int.tryParse(components[0]);
          final month = int.tryParse(components[1]);
          final year = int.tryParse(components[2]);
          if (day != null && month != null && year != null) {
            final date = DateTime(year, month, day);
            if (onlyFutureDate && date.isBefore(DateTime.now())) {
              return "Data inválida. Não é permitido datas anteriores ao dia de hoje!";
            }
            if (date.year == year && date.month == month && date.day == day) {
              return null;
            }
          }
        }
        return "Data inválida!";
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: _context,
        initialDate: DateTime.now(),
        firstDate: onlyFuture? DateTime.now() : DateTime(DateTime.now().year - 100),
        lastDate: onlyPast ? DateTime.now() : DateTime(DateTime.now().year + 100));

    if (pickedDate != null) {
      textController!.text = pickedDate.showString();
    }
  }
}
