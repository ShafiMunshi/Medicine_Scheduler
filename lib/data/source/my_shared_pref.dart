import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  MySharedPref._();

  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> reload() async {
    await _sharedPreferences?.reload();
  }

  static void setValue(String key, String value) {
    _sharedPreferences?.setString(key, value);
    if (kDebugMode) {
      print("$key = $value (set)");
    }
  }

  static String? getValue(String key) {
    return _sharedPreferences?.getString(key);
  }

  static Future<void> setBool(String key, bool val) async {
    await _sharedPreferences?.setBool(key, val);
  }

  static bool? getBool(String key) {
    return _sharedPreferences?.getBool(key);
  }

  static bool isContains(String key) {
    return _sharedPreferences?.containsKey(key) ?? false;
  }

  static Future<void> clear() async => await _sharedPreferences?.clear();
}
