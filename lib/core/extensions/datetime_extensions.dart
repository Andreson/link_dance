import 'package:intl/intl.dart';
import './string_extensions.dart.dart';

extension DatetimeExtension on DateTime {
  String showFriendly() {
    return "${DateFormat("MMMM", "pt_BR").format(this).capitalize()} de ${DateFormat("yyyy", "pt_BR").format(this)}";
  }

  String showString() {
    return "${DateFormat('dd/MM/yyyy').format(this)}";
  }

  String formatMMyyyy() {
    return "${DateFormat('MM-yyyy').format(this)}";
  }

  String formatyyyyMM() {
    return "${DateFormat('yyyy-MM').format(this)}";
  }

  String toTimeStamp() {
    return "${DateFormat('dd-MM-yyyy hh:ss:mm').format(this)}";
  }
}
