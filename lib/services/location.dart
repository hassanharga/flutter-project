import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../../../shared/constants/constants.dart';
import '../services/services.dart';

class LocationService {
  static Future<String?> _getAddressDetails(double lat, double lng,
      [String lang = 'ar']) async {
    String? address;
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&language=$lang&key=$API_KEY');

      final response = await http.get(url);
      final resData = json.decode(response.body);
      final List addressData = resData['results'] ?? [];

      outerLoop:
      for (final add in addressData) {
        final addressComponents = add['address_components'];
        for (final element in addressComponents) {
          final types = element['types'] as List<dynamic>;
          if (types.contains('locality')) {
            address = element['long_name'] ?? '';
            break outerLoop;
          }
        }
      }
      return address;
    } catch (e) {
      print('error[addressDetails] ===> $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> getCurrentLocation(
    String lang, {
    bool refetch = false,
  }) async {
    try {
      // default data with makkah corrdinated
      final locationDataRes = {
        'latitude': CITIES_LOCATION['makkah']!['latitude'],
        'longitude': CITIES_LOCATION['makkah']!['longitude'],
        'address': lang == ARABIC ? 'مكة المكرمة' : 'makka',
      };

      // get stored location
      if (!refetch) {
        final savedLocation =
            await StorageService.getStringValue(LOCATION, null);
        // print('savedLocation ===> $savedLocation');
        if (savedLocation != null) {
          final data = json.decode(savedLocation);
          locationDataRes['latitude'] = data['latitude'] as double;
          locationDataRes['longitude'] = data['longitude'] as double;
          locationDataRes['address'] = data['address'] as String;
          print('===== get stored location =====');
          return locationDataRes;
        }
      }

      Location location = Location();
      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return locationDataRes;
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return locationDataRes;
        }
      }

      locationData = await location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        return locationDataRes;
      }
      print('===== get live location ===== $locationData');

      // get address city
      final address = await _getAddressDetails(
        locationData.latitude!,
        locationData.longitude!,
        lang,
      );
      print('===== get address location details =====> $address');

      locationDataRes['latitude'] = locationData.latitude as double;
      locationDataRes['longitude'] = locationData.longitude as double;
      if (address != null) locationDataRes['address'] = address;

      // save to local storage
      await saveLocationToStorage(locationDataRes);

      return locationDataRes;
    } catch (e) {
      rethrow;
    }
  }

  // it should be latitude, longitude & address
  static saveLocationToStorage(Map<String, dynamic> locationDataRes) async {
    if (locationDataRes['latitude'] == null ||
        locationDataRes['longitude'] == null ||
        locationDataRes['address'] == null) return;

    await StorageService.setStringValue(LOCATION, locationDataRes);
  }
}
