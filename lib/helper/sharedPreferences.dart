import 'package:shared_preferences/shared_preferences.dart';

Future<bool> insertToSharedPref(String key, dynamic value) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      throw Exception("invalid-type");
    }
    return true;
  } catch(e) {
    return false;
  }
}

Future<bool> removeFromSharedPref(String key) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    return true;
  } catch(e) {
    return false;
  }
}

Future<dynamic> getAllFromSharedPref() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set keys = prefs.getKeys();
    Map keyValue = new Map();
    keys.forEach((key) {
      keyValue[key] = prefs.get(key);
    });
    return keyValue;
  } catch(e) {
    return Exception("shared-pref-read-error");
  }
}

Future<dynamic> getFromSharedPref(String key) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  } catch(e) {
    return Exception("shared-pref-read-error");
  }
}

Future<bool> clearSharedPref() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return true;
  } catch(e) {
    return false;
  }
}
