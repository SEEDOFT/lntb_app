import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lntb_app/core/constants/app_assets.dart';
import 'package:lntb_app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<Map<String, String>> pages = [
    {
      'title': 'onboarding_title_1',
      'subtitle': 'onboarding_subtitle_1',
      'image': AppAssets.onboarding1,
    },
    {
      'title': 'onboarding_title_2',
      'subtitle': 'onboarding_subtitle_2',
      'image': AppAssets.onboarding2,
    },
    {
      'title': 'onboarding_title_3',
      'subtitle': 'onboarding_subtitle_3',
      'image': AppAssets.onboarding3,
    },
  ];

  int get totalPages => pages.length;
  bool get isLastPage => currentPage.value == totalPages - 1;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      finishOnboarding();
    }
  }

  void skip() {
    finishOnboarding();
  }

  void finishOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_seen_onboarding', true);
    } catch (e) {
      debugPrint('Storage write error: $e');
    } finally {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
