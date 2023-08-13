import 'package:flutter/material.dart';

import '../../shared/constants/constants.dart';
import '../../shared/models/prayer_times.dart';
import '../../shared/utils/utils.dart';

int mapHour(String hour) {
  switch (hour) {
    case '1':
    case '01':
    case '13':
      return 1;

    case '2':
    case '02':
    case '14':
      return 2;

    case '3':
    case '03':
    case '15':
      return 3;

    case '4':
    case '04':
    case '16':
      return 4;

    case '5':
    case '05':
    case '17':
      return 5;

    case '6':
    case '06':
    case '18':
      return 6;

    case '7':
    case '07':
    case '19':
      return 7;

    case '8':
    case '08':
    case '20':
      return 8;

    case '9':
    case '09':
    case '21':
      return 9;

    case '10':
    case '22':
      return 10;

    case '11':
    case '23':
      return 11;

    case '12':
    case '00':
      return 12;

    default:
      return 12;
  }
}

String getHoursAndMinutes(String oldTime) {
  return oldTime.split(' ').first;
}

String convert24HoursTo12hours(BuildContext context, String oldTime) {
  final time = getHoursAndMinutes(oldTime);
  final [hour, minutes] = time.split(':');

  final amPm =
      int.parse(hour) > 12 ? translate(context).pm : translate(context).am;

  final newHour = mapHour(hour);
  return '${newHour.toString().padLeft(2, '0')}:$minutes $amPm';
}

String formatHijriDate(Hijri? date, String lang) {
  if (date == null) return '';
  final day = date.day;
  final month = lang == ARABIC ? date.month.ar : date.month.en;
  final year = date.year;

  return '$day $month $year';
}
