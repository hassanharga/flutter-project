import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/services.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/language/providers/language_provider.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/city.dart';
import '../widgets/bottom_section.dart';
import '../widgets/top_section.dart';

class PrayersScreen extends ConsumerStatefulWidget {
  const PrayersScreen({
    super.key,
  });

  @override
  ConsumerState<PrayersScreen> createState() => _PrayersScreenState();
}

class _PrayersScreenState extends ConsumerState<PrayersScreen> {
  TextEditingController searchController = TextEditingController();
  String _lang = ARABIC;

  Map<String, dynamic>? _allPrayerTimes = {};
  PrayerTimes? _todayPrayerTimes;
  PrayerTimes? _currentPrayerTimes;

  String? _address;
  double? _latitude;
  double? _longitude;

  bool showLoader = false;

  DateTime _todayDate = DateTime.now();

  // this related to top section content
  bool isHideSectionContent = false;
  bool isSearchingForCities = false;
  List<City> allCities = [];

  @override
  void initState() {
    _getPrayerTimes(false);
    super.initState();
  }

  Future<void> _getPrayerTimes(
    bool refetch, {
    bool skipLocation = false,
  }) async {
    try {
      setState(() {
        showLoader = true;
      });
      _lang = ref.read(languageProvider);

      if (!skipLocation) await _getLocation(refetch);

      if (_latitude == null && _longitude == null) return;

      _allPrayerTimes = await PrayersService.getPrayerTimes(
        _latitude!,
        _longitude!,
        _lang,
        refetch: refetch,
      );
      if (_allPrayerTimes == null) return;

      _todayPrayerTimes = await _getPrayersForDay(_todayDate);
      _currentPrayerTimes = _todayPrayerTimes;

      // scheduled notification
      if (context.mounted) {
        await NotificationService().schedulePrayerTimeNotification(
          context,
          _allPrayerTimes!,
        );
      }
    } finally {
      setState(() {
        showLoader = false;
      });
    }
  }

  _getLocation(bool refetch) async {
    var locationData = await LocationService.getCurrentLocation(
      _lang,
      refetch: refetch,
    );

    _latitude = locationData['latitude'];
    _longitude = locationData['longitude'];
    _address = locationData['address'];
  }

  _onInputChange(String value) {
    if (value.isEmpty) {
      setState(() {
        isHideSectionContent = false;
        isSearchingForCities = false;
        allCities = [];
      });
      return;
    }

    if (value.length >= 3) {
      _searchCity(value);
      setState(() {
        isHideSectionContent = true;
      });
    }
  }

  _searchCity(String value) async {
    try {
      setState(() {
        isSearchingForCities = true;
        allCities = [];
      });
      final res = await ApiService.send('searchForCity', {'city': value});
      final cities = (res['data'] as List?) ?? [];
      setState(() {
        isSearchingForCities = false;
        allCities = citiesFromJson(cities);
      });
    } catch (e) {
      print('error[_searchCity] =====> $e');
      setState(() {
        isSearchingForCities = false;
        allCities = [];
      });
    }
  }

  Future<PrayerTimes?> _getPrayersForDay(DateTime date) async {
    if (_latitude == null || _longitude == null || _allPrayerTimes == null) {
      return null;
    }

    return await PrayersService.getPrayerTimesForDay(_allPrayerTimes!, date);
  }

  _getDayPrayers(bool addToDate) async {
    var dateToGet = addToDate
        ? _todayDate.add(
            const Duration(days: 1),
          )
        : _todayDate.subtract(
            const Duration(days: 1),
          );
    // print('current date =====> $nextDate');
    final p = await _getPrayersForDay(dateToGet);
    if (p != null) {
      _currentPrayerTimes = p;
      _todayDate = dateToGet;
      setState(() {});
    }
  }

  _goBack() {
    Navigator.pop(
      context,
      {'fromPrayerPage': true},
    );
  }

  _onCityClick(BuildContext context, City city) async {
    FocusScope.of(context).requestFocus(FocusNode());
    _latitude = city.latitude;
    _longitude = city.longitude;
    _address = city.name;

    await LocationService.saveLocationToStorage({
      'latitude': _latitude,
      'longitude': _longitude,
      'address': _address,
    });

    searchController.clear();
    setState(() {
      isHideSectionContent = false;
      isSearchingForCities = false;
      allCities = [];
    });
    await _getPrayerTimes(true, skipLocation: true);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewPadding.top;

    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: LoaderOverlay(
        showLoader: showLoader,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                // top section
                TopSection(
                  currentPrayerTimes: _currentPrayerTimes,
                  todayPrayerTimes: _todayPrayerTimes,
                  height: height,
                  lang: _lang,
                  address: _address,
                  isHideSectionContent: isHideSectionContent,
                  isSearchingForCities: isSearchingForCities,
                  cities: allCities,
                  searchController: searchController,
                  getMyCurrentLocationPrayers: () => _getPrayerTimes(true),
                  onInputChange: _onInputChange,
                  getDayPrayers: _getDayPrayers,
                  goBack: _goBack,
                  onCityClick: (city) => _onCityClick(context, city),
                ),
                // bottom section
                BottomSection(currentPrayerTimes: _currentPrayerTimes),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
