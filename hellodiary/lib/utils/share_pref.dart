import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class SharePref {
  static SharePref _instance;
  SharedPreferences _sharedPreferences;

  static SharePref instance() {
    if(_instance == null) {
      _instance = SharePref._internal();
      _instance._init();
    }
    return _instance;
  }

  SharePref._internal();

  Future _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  String getString(String key) {
    if(_sharedPreferences == null) {
      return null;
    }
    return _sharedPreferences.getString(key);
  }
  Future<bool> putString(String key, String value) {
    if(_sharedPreferences == null) {
      return null;
    }
    return _sharedPreferences.setString(key, value);
  }

  Map getJson(String key) {
    if(_sharedPreferences == null) {
      return null;
    }
    String data = _sharedPreferences.getString(key);
    if(data != null && data != '') {
      return json.decode(data);
    }
    return null;
  }

  Future<bool> putJson(String key, Map map) {
    if(_sharedPreferences == null) {
      return null;
    }
    String value = json.encode(map);
    return _sharedPreferences.setString(key, value);
  }

  bool getBool(String key) {
    if(_sharedPreferences == null) {
      return false;
    }
    try {
      return _sharedPreferences.getBool(key);
    } catch(e) {
      return false;
    }
  }
  Future<bool> setBool(String key, bool value) {
    if(_sharedPreferences == null) {
      return null;
    }
    return _sharedPreferences.setBool(key, value);
  }
}
