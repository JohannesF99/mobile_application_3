import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
  static Future<bool?> getBool(String val) async {
    var pref = await SharedPreferences.getInstance();
    return pref.getBool(val);
  }

  static Future<String?> getString(String val) async {
    var pref = await SharedPreferences.getInstance();
    return pref.getString(val);
  }

  static Future<bool> saveString(String key, String val) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setString(key, val);
  }

  static Future<bool> saveBool(String key, bool val) async {
    var pref = await SharedPreferences.getInstance();
    return pref.setBool(key, val);
  }
}