import 'dart:developer';

import 'package:intl/intl.dart';

class DateFormatters {
  DateFormat yMD = DateFormat('yyyy-MM-dd');
  DateFormat mD = DateFormat('MMMM dd');
  DateFormat dM = DateFormat('dd - MMMM');
  DateFormat hMA = DateFormat('hh:mm a');
  DateFormat hMs = DateFormat('hh:mm:ss');
  DateFormat dMy = DateFormat('dd MMM yyyy');
  // ignore: non_constant_identifier_names
  DateFormat My = DateFormat('MMMM yyyy');
  DateFormat dM2 = DateFormat('dd MMM');
  DateFormat dMyDash = DateFormat('dd-MM-yyyy');
  DateFormat dMonthYear = DateFormat('dd MMMM yyyy');
  DateFormat dateTime = DateFormat('dd MMM yyyy, hh:mm a');
  DateFormat ddMMTime = DateFormat('dd MMM, hh:mm a');
  DateFormat dayDMY = DateFormat('EEE,  dd MMM yyyy');
  DateFormat dayDateTime = DateFormat('EEE,  dd MMM yyyy, hh:mm a');
  DateFormat day = DateFormat('EEE');
  DateFormat dayDate = DateFormat('EEE, dd');
  DateFormat dayDateMonth = DateFormat('EEE, dd MMM');
  DateFormat dateDay = DateFormat('dd, EEEE');
  DateFormat month = DateFormat('MMMM');
  DateFormat date = DateFormat('dd');
  // DateFormat week = DateFormat('dd');
  week(DateTime dateTime) {
    if (dateTime.day < 8) {
      return '1';
    }
    if (dateTime.day < 15) {
      return '2';
    }
    if (dateTime.day < 22) {
      return '3';
    }
    return '4';
  }
}

double getDifferenceInDays({required DateTime date, DateTime? currentDate}) {
  // DateTime _myTime;
  // DateTime _ntpTime;
  DateTime dateTimeCreatedAt = date;
  DateTime dateTimeNow = currentDate ?? DateTime.now();
  int differenceInDays = dateTimeCreatedAt.difference(dateTimeNow).inDays;
  return double.parse("$differenceInDays");
}

String getSlotTime({required DateTime one, required DateTime two}) {
  return "${DateFormatters().hMA.format(one)} - ${DateFormatters().hMA.format(two)}";
}

bool compareDates({required DateTime one, required DateTime two, bool year = true, bool logData = false}) {
  if (logData) {
    log("${DateFormatters().dMy.format(one)}  ${DateFormatters().dMy.format(two)}");
  }
  if (year) {
    return DateFormatters().dMy.format(one) == DateFormatters().dMy.format(two);
  } else {
    return DateFormatters().dM.format(one) == DateFormatters().dM.format(two);
  }
}

DateTime getDateTime() {
  return DateTime.now();
}
