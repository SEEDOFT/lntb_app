import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find<LanguageController>();

  final isKhmer = true.obs;

  @override
  void onInit() {
    super.onInit();
    Future<void>.delayed(Duration.zero, _restore);
  }

  Future<void> _restore() async {
    final language = await Get.find<ApiClient>().storage.read(
          key: 'app_language',
        );
    isKhmer.value = language != 'en';
    Get.updateLocale(
      isKhmer.value ? const Locale('km', 'KH') : const Locale('en', 'US'),
    );
  }

  Future<void> toggleLanguage() async {
    isKhmer.toggle();
    final language = isKhmer.value ? 'km' : 'en';
    await Get.find<ApiClient>().storage.write(
          key: 'app_language',
          value: language,
        );
    Get.updateLocale(
      isKhmer.value ? const Locale('km', 'KH') : const Locale('en', 'US'),
    );
  }
}
