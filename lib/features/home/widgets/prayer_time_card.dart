import 'package:flutter/material.dart';

import './prayer_time_countdown.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/models/prayer_times.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

enum PageName { qibla, prayers, azkar }

class PrayerTimeCard extends StatelessWidget {
  final String lang;
  final double height = 200;
  final double prayerHeight = 70;
  // check stred prayers and change method
  final PrayerTimes? todayPrayerTimes;
  final String? address;
  final VoidCallback? onTimerFinshed;
  final Function({
    PageName? page,
    bool withNavBar,
    bool jumpToTab,
    int? tabIndex,
  }) navigateToPage;

  const PrayerTimeCard({
    super.key,
    this.todayPrayerTimes,
    this.address,
    required this.lang,
    this.onTimerFinshed,
    required this.navigateToPage,
  });

  @override
  Widget build(BuildContext context) {
    var currentPrayerTiming = todayPrayerTimes?.currentPrayerTiming;
    // print('currentPrayerTiming ===> $currentPrayerTiming');

    var nextPrayerTiming = todayPrayerTimes?.nextPrayerTiming;
    // print('nextPrayerTiming ===> $nextPrayerTiming');

    var boxDecoration = BoxDecoration(
      color: AppColors.grayColor.withOpacity(.3),
      borderRadius: const BorderRadius.all(Radius.circular(5)),
    );
    return Stack(
      children: [
        // background image
        Image.asset(
          width: double.infinity,
          height: height,
          ImgAssets.mekkaImg,
          fit: BoxFit.fill,
        ),
        // background color
        Container(
          color: AppColors.primaryColor.withOpacity(.5),
          width: double.infinity,
          height: height,
        ),
        // prayer & location data
        todayPrayerTimes != null
            ? Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // location
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // location name & icon

                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                const DynamicIcon(ImgAssets.location),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    address ?? '',
                                    style: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          // qibla
                          InkWell(
                            onTap: () => navigateToPage(page: PageName.azkar),
                            child: Text(
                              translate(context).qiblaDetect,
                              style: const TextStyle(
                                color: AppColors.yellowColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // hijri date
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: boxDecoration,
                        // TODO add adjustment=1 in BE
                        child: Text(
                          formatHijriDate(todayPrayerTimes?.date.hijri, lang),
                          style: const TextStyle(color: AppColors.whiteColor),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // prayers
                      InkWell(
                        onTap: () => navigateToPage(page: PageName.prayers),
                        child: Row(
                          children: [
                            // current prayer & remaining time
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: prayerHeight,
                                padding: const EdgeInsets.all(5),
                                decoration: boxDecoration,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (currentPrayerTiming != null)
                                      Expanded(
                                        child: _Time(
                                          mainText: getPrayerTimeName(
                                            context,
                                            currentPrayerTiming.key,
                                          ),
                                          time: convert24HoursTo12hours(
                                            context,
                                            currentPrayerTiming.value,
                                          ),
                                        ),
                                      ),
                                    if (currentPrayerTiming != null)
                                      Expanded(
                                        child: _Time(
                                          mainText:
                                              translate(context).adanAfter,
                                          time: currentPrayerTiming.value,
                                          isCountDown: true,
                                          notifyHomaPage: onTimerFinshed,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // next prayer
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: prayerHeight,
                                padding: const EdgeInsets.all(5),
                                decoration: boxDecoration,
                                child: nextPrayerTiming != null
                                    ? _Time(
                                        mainText: getPrayerTimeName(
                                          context,
                                          nextPrayerTiming.key,
                                        ),
                                        time: convert24HoursTo12hours(
                                          context,
                                          nextPrayerTiming.value,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
      ],
    );
  }
}

class _Time extends StatelessWidget {
  final String mainText;
  final String time;
  final bool isCountDown;
  final VoidCallback? notifyHomaPage;

  const _Time({
    required this.mainText,
    required this.time,
    this.isCountDown = false,
    this.notifyHomaPage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // headeline
        Text(
          mainText,
          style: const TextStyle(
            color: AppColors.yellowColor,
            fontSize: 14,
          ),
        ),
        // time
        if (!isCountDown)
          Text(
            time,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 16,
            ),
          ),
        // countdown
        if (isCountDown)
          PrayerTimeCountdown(
            time: time,
            onTimerFinshed: notifyHomaPage,
          ),
      ],
    );
  }
}
