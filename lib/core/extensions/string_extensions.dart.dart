
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return _capitalize(this);
  }

  String _capitalize(String text) {
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  String capitalizePhrase({bool allWord = true}) {
    try {
      List<String> phrase = split(" ");
      phrase[0] = _capitalize(phrase[0]);

      if (!allWord) {
        return phrase.join(" ");
      }
      for (int i = 1; i < phrase.length; i++) {
        if (phrase[i].length < 2) {
          continue;
        }
        phrase[i] = _capitalize(phrase[i]);
      }
      return phrase.join(" ");
    }
    catch(e) {
      return this;
    }
  }

  DateTime toDate({String format = "dd/MM/yyyy"}) {
    return DateFormat(format).parse(this);
  }

  DateTime parse() {
    return DateTime.parse(this);
  }

  DateTime toDateTime({String format = "yyyy-MM-ddThh:mm:ss"}) {
    return DateFormat(format).parse(this);
  }

  String emptyIfNull() {
    return this=="null" ? "":this;
  }
  Timestamp toTimestamp({String format = "dd/MM/yyyy"}) {
    return Timestamp.fromDate(DateFormat(format).parse(this));
  }

  double parseDouble() {
    var temp = replaceAll("R\$", "").replaceFirst(",", ".");

    return double.parse(temp);
  }
}

main() {
  var value = "grupo de estudos ";
  print(value.capitalizePhrase());
}
