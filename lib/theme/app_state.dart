import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState extends ChangeNotifier {
  final String key = "themeMode";
  late SharedPreferences _preferences;
  bool isDarkModeOn = false;

  bool get darkMode => isDarkModeOn;

  ThemeState() {
    _loadFromPreferences();
  }

  _initialPreferences() async {
      _preferences = await SharedPreferences.getInstance();
  }

  _savePreferences()async {
    await _initialPreferences();
    _preferences.setBool(key, isDarkModeOn);
  }

  _loadFromPreferences() async {
    await _initialPreferences();
    isDarkModeOn = _preferences.getBool(key) ?? false;
    notifyListeners();
  }

  toggleChangeTheme(){
    isDarkModeOn = !isDarkModeOn;
    _savePreferences();
    notifyListeners();
  }


}