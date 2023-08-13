import 'dart:convert';

import 'package:intl/intl.dart';

import '../../services/services.dart';
import '../../shared/models/prayer_times.dart';

class PrayersService {
  static Future<PrayerTimes?> getPrayerTimesForDay(
    Map<String, dynamic> allPrayers,
    DateTime date,
  ) async {
    // print('currentDay ===> $currentDay');
    final todayDate = DateFormat('dd-MM-yyyy').format(date);
    final monthPrayerTimings =
        prayerTimesFromJson(allPrayers, date.month.toString());

    return monthPrayerTimings
        .where((element) => element.date.gregorian.date == todayDate)
        .firstOrNull;
  }

  // get prayer time from local storage
  // if not exists call api to get it and save it locally
  // get prayers for today
  static Future<Map<String, dynamic>?> getPrayerTimes(
    double latitude,
    double longitude,
    String lang, {
    bool refetch = false,
  }) async {
    try {
      // refetch is to get the new prayer times from api even if it exists in local storage
      // get stored prayer time
      if (!refetch) {
        final savedPrayers = await StorageService.getStringValue(PRAYERS, null);

        if (savedPrayers != null) {
          final savedPrayersTimings = json.decode(savedPrayers);
          final monthPrayersTimings =
              prayerTimesFromJson(savedPrayersTimings, '1');

          if (monthPrayersTimings[0].date.gregorian.year ==
              DateTime.now().year.toString()) {
            print('===== get stored prayers timings =====');
            return savedPrayersTimings as dynamic;
          }
        }
      }

      // api request
      print('===== fetch prayer times from api =====');
      final apiPrayers = await ApiService.send(
        'getPrayerTimes',
        {
          'latitude': latitude,
          'longitude': longitude,
          'year': DateTime.now().year
        },
      );
      final Map<String, dynamic>? allPrayers = apiPrayers['data'];

      // save to local storage
      if (allPrayers != null && allPrayers.isNotEmpty) {
        await StorageService.setStringValue(PRAYERS, allPrayers);
        return allPrayers;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
