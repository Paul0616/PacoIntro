import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class LocalBaseRepository{

  Future<Map<String, dynamic>> getLocalObjectMap({String key}) async {
    final prefs = await SharedPreferences.getInstance();
    final object = prefs.getString(key);
    if(object == null)
      return null;
    return JsonDecoder().convert(object) as Map<String, dynamic>;
  }


  Future<bool> saveLocalObjectMap({Map<String, dynamic> map, String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, JsonEncoder().convert(map));
  }

  Future<void> removeLocalObject({String key}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}