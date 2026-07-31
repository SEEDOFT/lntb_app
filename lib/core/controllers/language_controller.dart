import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';

class LanguageController extends GetxController {
  LanguageController({required ApiClient apiClient}) : _apiClient = apiClient;

  static LanguageController get to => Get.find<LanguageController>();

  final ApiClient _apiClient;
  final isKhmer = true.obs;

  @override
  void onInit() {
    super.onInit();
    Future<void>.delayed(Duration.zero, _restore);
  }

  Future<void> _restore() async {
    final language = await _apiClient.storage.read(
          key: 'app_language',
        );
    isKhmer.value = language != 'en';
    await Get.updateLocale(
      isKhmer.value ? const Locale('km', 'KH') : const Locale('en', 'US'),
    );
  }

  Future<void> toggleLanguage() async {
    isKhmer.toggle();
    final language = isKhmer.value ? 'km' : 'en';
    await _apiClient.storage.write(
          key: 'app_language',
          value: language,
        );
    await Get.updateLocale(
      isKhmer.value ? const Locale('km', 'KH') : const Locale('en', 'US'),
    );
  }
}
