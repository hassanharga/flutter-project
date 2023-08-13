// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// storage keys
const String LAGUAGE_CODE = 'language';
const String TOKEN = 'token';
const String LOCATION = 'location';
const String PRAYERS = 'prayers';

class StorageService {
  // sharedPreferences instance
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  // getter and setter
  static Future<bool> setStringValue(String key, dynamic value) async {
    try {
      SharedPreferences prefs = await _prefs;
      await prefs.setString(key, json.encode(value));
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getStringValue(String key,
      [dynamic defaultValue]) async {
    SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? defaultValue;
  }
}
