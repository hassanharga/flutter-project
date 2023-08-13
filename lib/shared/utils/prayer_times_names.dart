import 'package:flutter/material.dart';

import './utils.dart';
import '../constants/constants.dart';

String getPrayerTimeName(BuildContext context, String key) {
  if (key.toLowerCase() == AdhanName.Fajr) return translate(context).fajr;
  if (key.toLowerCase() == AdhanName.Dhuhr) return translate(context).dhuhr;
  if (key.toLowerCase() == AdhanName.Asr) return translate(context).asr;
  if (key.toLowerCase() == AdhanName.Maghrib) {
    return translate(context).maghrib;
  }
  if (key.toLowerCase() == AdhanName.Isha) return translate(context).isha;
  if (key.toLowerCase() == AdhanName.Sunrise) return translate(context).sunrise;
  return '';
}
