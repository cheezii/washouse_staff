import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtils {
  TimeOfDay timeNow = TimeOfDay.now();
  DateTime dateNow = DateTime.now();

  bool checkCenterStatus(String openTime, String closedTime) {
    String openHr = openTime.substring(0, 2);
    String openMin = openTime.substring(3, 5);
    TimeOfDay timeOpen;

    timeOpen = TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));

    String closeHr = closedTime.substring(0, 2);
    String closeMin = closedTime.substring(3, 5);

    TimeOfDay timeClose;

    timeClose =
        TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));

    int nowInMinutes = timeNow.hour * 60 + timeNow.minute;
    int openTimeInMinutes = timeOpen.hour * 60 + timeOpen.minute;
    int closeTimeInMinutes = timeClose.hour * 60 + timeClose.minute;

    if (openTimeInMinutes < nowInMinutes && nowInMinutes < closeTimeInMinutes) {
      return true;
    }

    return false;
  }

  bool checkCloseTime(String closedTime) {
    String closeHr = closedTime.substring(0, 2);
    String closeMin = closedTime.substring(3, 5);

    TimeOfDay timeClose;

    timeClose =
        TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));

    int nowInMinutes = timeNow.hour * 60 + timeNow.minute;
    int closeTimeInMinutes = timeClose.hour * 60 + timeClose.minute;

//handling day change ie pm to am
    if (closeTimeInMinutes - 30 < nowInMinutes &&
        nowInMinutes < closeTimeInMinutes) {
      return true;
    }

    return false;
  }

  bool checkBreakDay(String openTime, String closedTime) {
    if (openTime.isEmpty && closedTime.isEmpty) return true;
    return false;
  }

  bool checkNowWeekDay(int weekDay) {
    int weekdayNow;

    if (dateNow.weekday == 7) {
      weekdayNow = 0;
    } else {
      weekdayNow = dateNow.weekday;
    }

    if (weekDay == weekdayNow) return true;
    return false;
  }

  bool checkOver24Hours(String createDateTime) {
    String formattedDate = changeDateFormat(createDateTime);
    DateTime datetime = DateTime.parse(formattedDate);
    int milliseconds = datetime.millisecondsSinceEpoch;
    if (dateNow.millisecondsSinceEpoch - milliseconds < 24 * 60 * 60 * 1000) {
      return false;
    } else {
      return true;
    }
  }

  String changeDateFormat(String dateChange) {
    var time = dateChange.split(' ')[1] as String;
    var day = dateChange.split(' ')[0] as String;
    DateTime date = DateFormat('dd/MM/yyyy').parse(day);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return formattedDate + ' ' + time;
  }

  String getDisplayName(String dateTime) {
    return dateTime.substring(0, 5);
  }

  String getDisplayTime(String dateTime) {
    List<String> subString = dateTime.split(' ');
    return '${subString[0].substring(0, 5)} ${subString[1].substring(0, 5)}';
  }
}
