import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  MySharedPref._();

  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> reload() async {
    _sharedPreferences.reload();
  }

  static setValue(String key, String value) {
    _sharedPreferences.setString(key, value);
    if (kDebugMode) {
      print("$key = $value (setted)");
    }
  }

  static String? getValue(String key) {
    return _sharedPreferences.getString(key);
  }

  static setInt(String key, int value) {
    _sharedPreferences.setInt(key, value);
    if (kDebugMode) {
      print("$key = $value (setted)");
    }
  }

  static setTimeList(String key, List<String> timeList) {
    _sharedPreferences.setStringList(key, timeList);
    if (kDebugMode) {
      print("$key = $timeList (setted)");
    }
  }

  static int? getInt(String key) {
    return _sharedPreferences.getInt(key);
  }

  // static bool? isLogin() {
  //   return _sharedPreferences.getBool(AppConstants.IS_LOGIN);
  // }

  // static setLoggedIn() {
  //   _sharedPreferences.setBool(AppConstants.IS_LOGIN, true);
  // }

  static bool? getBool(String key) {
    return _sharedPreferences.getBool(key);
  }

  static Future<void> setBool(String key, bool val) async {
    await _sharedPreferences.setBool(key, val);
  }

  // static setLoggedInFalse() {
  //   _sharedPreferences.setBool(AppConstants.IS_LOGIN, false);
  // }

  static removeCookies(String key) {
    _sharedPreferences.remove(key);
  }

  static isContains(String key) {
    _sharedPreferences.containsKey(key);
  }

  static Future<void> clear() async => await _sharedPreferences.clear();
}
