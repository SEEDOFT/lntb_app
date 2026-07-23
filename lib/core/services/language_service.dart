import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends GetxService {
  static LanguageService get to => Get.find<LanguageService>();

  static const String _keyLanguage = 'app_language';
  static const Locale defaultLocale = Locale('km', 'KH');

  final currentLocale = defaultLocale.obs;
  late SharedPreferences _prefs;

  Future<LanguageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    final languageCode = _prefs.getString(_keyLanguage);

    if (languageCode == 'en') {
      currentLocale.value = const Locale('en', 'US');
    } else {
      currentLocale.value = const Locale('km', 'KH');
    }
    return this;
  }

  Future<void> changeLanguage(String languageCode) async {
    if (languageCode == 'en') {
      currentLocale.value = const Locale('en', 'US');
      await _prefs.setString(_keyLanguage, 'en');
    } else {
      currentLocale.value = const Locale('km', 'KH');
      await _prefs.setString(_keyLanguage, 'km');
    }
    Get.updateLocale(currentLocale.value);
  }

  void toggleLanguage() {
    changeLanguage(isKhmer ? 'en' : 'km');
  }

  bool get isKhmer => currentLocale.value.languageCode == 'km';
  String get currentLanguageCode => currentLocale.value.languageCode;
}
