import 'package:flutter/material.dart';

import './search_bar.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/models/prayer_times.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';
import '../../home/widgets/prayer_time_countdown.dart';
import '../models/city.dart';
import '../widgets/cities.dart';

class TopSection extends StatelessWidget {
  final double height;
  final String lang;
  final String? address;
  final PrayerTimes? todayPrayerTimes;
  final PrayerTimes? currentPrayerTimes;

  final TextEditingController searchController;
  final bool isHideSectionContent;
  final bool isSearchingForCities;
  final List<City> cities;

  final VoidCallback getMyCurrentLocationPrayers;
  final Function(String value) onInputChange;
  final Function(bool value) getDayPrayers;
  final Function() goBack;
  final Function(City city) onCityClick;

  const TopSection({
    super.key,
    required this.height,
    required this.lang,
    this.address,
    this.todayPrayerTimes,
    this.currentPrayerTimes,
    required this.getMyCurrentLocationPrayers,
    required this.onInputChange,
    required this.getDayPrayers,
    required this.goBack,
    required this.isHideSectionContent,
    required this.isSearchingForCities,
    required this.cities,
    required this.onCityClick,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: height,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImgAssets.prayers),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: !isHideSectionContent
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            // app bar
            CustomAppBar(
              leadingIcon: ImgAssets.cancel,
              title: translate(context).prayersTitle,
              trailingIcon: ImgAssets.location2,
              onLeadingIconPressed: goBack,
              onTrailingIconPressed: getMyCurrentLocationPrayers,
            ),

            // search city & cities details
            Column(
              children: [
                AppSearchBar(
                  controller: searchController,
                  leadingIcon: Icons.search,
                  placeHolder: translate(context).searchByCity,
                  onChange: (value) => onInputChange(value),
                ),
                // cities details
                if (isHideSectionContent) ...[
                  const SizedBox(height: 10),
                  CitiesDetails(
                    isSearchingForCities: isSearchingForCities,
                    cities: cities,
                    onCityClick: onCityClick,
                  ),
                ]
              ],
            ),
            if (!isHideSectionContent) ...[
              // current location
              Row(
                children: [
                  const DynamicIcon(
                    ImgAssets.location,
                    color: AppColors.primaryColor,
                  ),
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
              // prayer remaining
              if (todayPrayerTimes != null) ...[
                Text(
                  translate(context).prayerRemaining(
                    getPrayerTimeName(
                      context,
                      todayPrayerTimes!.currentPrayerTiming?.key ?? '',
                    ),
                  ),
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 15,
                  ),
                ),
                // countdown timer
                PrayerTimeCountdown(
                  fromPrayerPage: true,
                  onTimerFinshed: () {},
                  time: todayPrayerTimes!.currentPrayerTiming?.value,
                ),
              ],
              // switch days
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  // next
                  InkWell(
                    onTap: () => getDayPrayers(true),
                    child: const DynamicIcon(
                      ImgAssets.next,
                      size: 25,
                    ),
                  ),
                  // hijri date
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // day
                        Text(
                          (lang == ARABIC
                                  ? currentPrayerTimes?.date.hijri.weekday.ar
                                  : currentPrayerTimes
                                      ?.date.gregorian.weekday.en) ??
                              '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatHijriDate(currentPrayerTimes?.date.hijri, lang),
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        // date
                      ],
                    ),
                  ),
                  // previous
                  InkWell(
                    onTap: () => getDayPrayers(false),
                    child: const DynamicIcon(
                      ImgAssets.previous,
                      size: 25,
                    ),
                  )
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
