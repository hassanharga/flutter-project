import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../shared/models/prayer_times.dart';
import '../shared/utils/utils.dart';

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (
        int id,
        String? title,
        String? body,
        String? payload,
      ) async {},
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) async {},
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  Future scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledNotificationDateTime,
  }) async {
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        scheduledNotificationDateTime,
        tz.local,
      ),
      await _notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: payload,
    );
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  Future<void> schedulePrayerTimeNotification(
    BuildContext context,
    Map<String, dynamic> prayers,
  ) async {
    try {
      // TODO check if user don't want to send notifications ==> from app settings
      const isNotificationEnabled = true;

      if (!isNotificationEnabled) {
        await NotificationService().cancelAllNotifications();
        return;
      }

      const maxScheduledNotificationCounter = 50;
      int counter = 0;

      final currentDate = DateTime.now();

      const prayersToIgnore = [
        'Sunset',
        'Imsak',
        'Firstthird',
        'Lastthird',
        // TODO remove this and check if they in setting
        'Sunrise',
        'Midnight'
      ];

      // loop through all months in prayers to schedule notification to reach maximum counter
      // loop inside month to set notification

      print('===== cancel old notifications  =====');
      await cancelAllNotifications();

      print('===== schedule new notification =====');
      outerLoop:
      for (final month in prayers.keys) {
        // break counter if reached to maximum
        if (counter >= maxScheduledNotificationCounter) break outerLoop;

        // don't schedule prayers less than current month
        if (int.parse(month) < DateTime.now().month) continue;

        final monthPrayerTimings = prayerTimesFromJson(prayers, month);
        for (final prayerTimings in monthPrayerTimings) {
          if (counter >= maxScheduledNotificationCounter) break outerLoop;

          // ignore dates before current date
          final loopDate = DateTime.fromMillisecondsSinceEpoch(
            int.parse(prayerTimings.date.timestamp) * 1000,
          );

          final startOfDay = currentDate.copyWith(
            hour: 0,
            minute: 0,
            second: 0,
            microsecond: 0,
            millisecond: 0,
          );
          // print('loopDate =====> $loopDate ====== $startOfDay');
          // print('isBefore =====> ${loopDate.isBefore(startOfDay)}');
          if (loopDate.isBefore(startOfDay)) continue;

          // loop through timings to schedule notification
          final timings = prayerTimings.timings.toJson();

          for (final time in timings.entries) {
            if (counter >= maxScheduledNotificationCounter) break outerLoop;
            final key = time.key;
            final value = time.value;

            // ignore this timings
            if (prayersToIgnore.contains(key)) continue;

            // TODO also check for midnight notification and sunrise  ==> from app settings
            // FIXME remove sunset and midnight from prayersToIgnore array

            // set time for notifcation
            final [hour, minutes] = getHoursAndMinutes(value).split(':');

            final newDate = DateTime(
              int.parse(prayerTimings.date.gregorian.year),
              prayerTimings.date.gregorian.month.number,
              int.parse(prayerTimings.date.gregorian.day),
              int.parse(hour),
              int.parse(minutes),
            );

            // ignore dates before current date & time
            if (newDate.isBefore(currentDate)) continue;

            String msg = '';
            // ignore: use_build_context_synchronously
            final word = getPrayerTimeName(context, key);
            if (['Sunrise', 'Midnight'].contains(key)) {
              // ignore: use_build_context_synchronously
              msg = translate(context).timeNow(word);
            } else {
              // ignore: use_build_context_synchronously
              msg = translate(context).adhanTime(word);
            }

            // print('msg ====> $msg');
            // print('newDate ====> $newDate');

            await scheduleNotification(
              scheduledNotificationDateTime: newDate,
              id: counter + 1,
              // title: key,
              body: msg,
            );

            counter++;
          }
        }
      }
    } catch (e) {
      print('error[sendUserNotification] =====> $e');
    }
  }
}
