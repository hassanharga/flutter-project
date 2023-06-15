// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

// storage keys
const String LAGUAGE_CODE = 'language';

// sharedPreferences instance
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

// getter and setter
Future<String> setStringValue(String key, String value) async {
  SharedPreferences prefs = await _prefs;
  await prefs.setString(key, value);
  return value;
}

Future<String> getStringValue(String key, [defaultValue]) async {
  SharedPreferences prefs = await _prefs;
  return prefs.getString(key) ?? defaultValue;
}
