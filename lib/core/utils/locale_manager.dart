import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleManager {
  static const String _localeKey = 'selected_locale';

  static Future<Locale> getSelectedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey) ?? 'en';
    
    if (localeCode == 'ru') {
      return const Locale('ru', '');
    }
    return const Locale('en', '');
  }

  static Future<void> setSelectedLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}