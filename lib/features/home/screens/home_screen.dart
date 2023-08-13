import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../services/services.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/language/providers/language_provider.dart';
import '../../../shared/models/prayer_times.dart';
import '../../prayers/screens/prayers_screen.dart';
import '../../qibla/screens/qibla.dart';
import '../widgets/azhkar_card.dart';
import '../widgets/prayer_time_card.dart';
import '../widgets/rateel_tools.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final Function(int index) navigateToTab;

  const HomeScreen({
    super.key,
    required this.navigateToTab,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  PrayerTimes? _todayPrayerTimes;
  String? _address;
  String _lang = ARABIC;

  @override
  void initState() {
    _getPrayerTimes();
    super.initState();
  }

  _getPrayerTimes() async {
    _lang = ref.read(languageProvider);
    var locationData = await LocationService.getCurrentLocation(_lang);

    double latitude = locationData['latitude'];
    double longitude = locationData['longitude'];
    _address = locationData['address'];

    final allPrayerTimes =
        await PrayersService.getPrayerTimes(latitude, longitude, _lang);

    if (allPrayerTimes == null) return;

    _todayPrayerTimes = await PrayersService.getPrayerTimesForDay(
      allPrayerTimes,
      DateTime.now(),
    );
    setState(() {});

    if (context.mounted) {
      // scheduled notification
      await NotificationService().schedulePrayerTimeNotification(
        context,
        allPrayerTimes,
      );
    }
  }

  // after timer finshed will recalculate to get the next prayer to start timer again
  _onTimerFinshed() {
    print(' === will _notifyHomaPage === 2');
    Timer(
      const Duration(minutes: 2),
      () {
        print(' === _notifyHomaPage === 2');
        _getPrayerTimes();
      },
    );
  }

  // because we will navigate to different location from home
  // this will be the generic function that navigate to other screens (tabs & screens)
  void _navigateToPage({
    bool withNavBar = false,
    bool jumpToTab = false,
    PageName? page,
    int? tabIndex,
  }) async {
    if (jumpToTab) {
      if (tabIndex == null) return;
      widget.navigateToTab(tabIndex);
    } else {
      if (page == null) return;

      final Widget screen;

      switch (page) {
        case PageName.qibla:
          screen = const QiblaScreen();
          break;
        case PageName.prayers:
          screen = const PrayersScreen();
          break;
        default:
          screen = const QiblaScreen();
      }

      final data = await PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: screen,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
        withNavBar: withNavBar,
      );

      if (data != null && data['fromPrayerPage'] != null) {
        await _getPrayerTimes();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var showMorning =
        _todayPrayerTimes?.currentPrayerTiming?.key.toLowerCase() ==
            AdhanName.Dhuhr;
    var showEvening =
        _todayPrayerTimes?.currentPrayerTiming?.key.toLowerCase() ==
            AdhanName.Maghrib;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // prayer
          PrayerTimeCard(
            todayPrayerTimes: _todayPrayerTimes,
            address: _address,
            onTimerFinshed: _onTimerFinshed,
            navigateToPage: _navigateToPage,
            lang: _lang,
          ),
          // azkar
          if (showEvening || showMorning) const SizedBox(height: 10),
          AzkarCard(
            showMorning: showMorning,
            showEvening: showEvening,
          ),
          // khatmah
          // rateel tools
          const SizedBox(height: 10),
          const RateelTools(),
          // reciters
          // audio
        ],
      ),
    );
  }
}
