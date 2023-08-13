import 'package:flutter/material.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/models/prayer_times.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';
import '../../qibla/screens/qibla.dart';

class BottomSection extends StatelessWidget {
  final PrayerTimes? currentPrayerTimes;

  const BottomSection({
    super.key,
    this.currentPrayerTimes,
  });

  bool _isActiveTime(String key) {
    return currentPrayerTimes!.currentPrayerTiming?.key.toLowerCase() == key;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          // prayers
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: currentPrayerTimes != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // fajr
                        _PrayerCard(
                          isActive: _isActiveTime(AdhanName.Fajr),
                          prayerName: translate(context).fajr,
                          time: convert24HoursTo12hours(
                            context,
                            currentPrayerTimes!.timings.fajr,
                          ),
                          icon: ImgAssets.fajr,
                        ),
                        // sunrise
                        _PrayerCard(
                          isActive: _isActiveTime(AdhanName.Sunrise),
                          prayerName: translate(context).sunrise,
                          time: convert24HoursTo12hours(
                            context,
                            currentPrayerTimes!.timings.sunrise,
                          ),
                          icon: ImgAssets.sunrise,
                        ),
                        // dhuhr
                        _PrayerCard(
                          isActive: _isActiveTime(AdhanName.Dhuhr),
                          prayerName: translate(context).dhuhr,
                          time: convert24HoursTo12hours(
                            context,
                            currentPrayerTimes!.timings.dhuhr,
                          ),
                          icon: ImgAssets.dhuhr,
                        ),
                        // asr
                        _PrayerCard(
                          isActive: _isActiveTime(AdhanName.Asr),
                          prayerName: translate(context).asr,
                          time: convert24HoursTo12hours(
                            context,
                            currentPrayerTimes!.timings.asr,
                          ),
                          icon: ImgAssets.asr,
                        ),
                        // maghrib
                        _PrayerCard(
                          isActive: _isActiveTime(AdhanName.Maghrib),
                          prayerName: translate(context).maghrib,
                          time: convert24HoursTo12hours(
                            context,
                            currentPrayerTimes!.timings.maghrib,
                          ),
                          icon: ImgAssets.maghrib,
                        ),
                        // isha
                        _PrayerCard(
                          isActive: _isActiveTime(AdhanName.Isha),
                          prayerName: translate(context).isha,
                          time: convert24HoursTo12hours(
                            context,
                            currentPrayerTimes!.timings.isha,
                          ),
                          icon: ImgAssets.isha,
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          // qibla button
          ButtonWidget(
            label: translate(context).qiblaDetect,
            fontSize: 18,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QiblaScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PrayerCard extends StatelessWidget {
  final bool isActive;
  final String prayerName;
  final String time;
  final String icon;

  const _PrayerCard({
    required this.prayerName,
    required this.time,
    required this.isActive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // active border
        Container(
          width: 6,
          height: 41,
          decoration: BoxDecoration(
            color:
                isActive ? AppColors.primaryColor : AppColors.transparentColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        // prayer details
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // name
                Expanded(
                  flex: 1,
                  child: Text(
                    prayerName,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                // icon
                Expanded(
                  flex: 2,
                  child: Center(
                    child: DynamicIcon(
                      icon,
                      color: isActive
                          ? AppColors.primaryColor
                          : AppColors.blackColor,
                    ),
                  ),
                ),
                // time
                Expanded(
                  flex: 1,
                  child: Text(
                    time,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
