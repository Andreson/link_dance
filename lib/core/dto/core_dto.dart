

import 'package:link_dance/core/extensions/datetime_extensions.dart';

class DateRangeDto {
  DateTime startDate;
  DateTime endDate;

  DateRangeDto({required this.startDate,required this.endDate});

  bool isValidRange( ) {
    if ( startDate.isAfter(endDate)  ||  endDate.isBefore(startDate)  ) {
      return false;
    }
    return true;
  }

  //retorna true se a data passada como parametro estiver entre a data o objeto
  bool isBetween({required DateRangeDto range}) {
    if ( startDate.isBefore(range.endDate)  && startDate.isAfter(range.startDate)  ) {
      print("intersecção de start date em ${range.toString()}");
      return true;
    }
    if (endDate.isBefore(range.startDate)  &&  endDate.isAfter(range.endDate)) {
      print("intersecção de end date em ${range.toString()}");
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return '${startDate.showString()} até ${endDate.showString()}';
  }
}