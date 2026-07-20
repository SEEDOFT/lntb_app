import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<Map<String, String>> pages = [
    {
      'title': 'ស្វាគមន៍មកកាន់ LNTB IoT',
      'subtitle': 'កម្មវិធីសម្រាប់កសិកម្មឆ្លាតវៃ',
      'image': 'assets/svgs/onboarding_step_1_farmer.svg',
    },
    {
      'title': 'ភ្ជាប់ឧបករណ៍ងាយស្រួល',
      'subtitle': 'ភ្ជាប់ឧបករណ៍ និងគ្រប់គ្រងបានគ្រប់ពេល',
      'image': 'assets/svgs/onboarding_step_2_devices.svg',
    },
    {
      'title': 'គ្រប់គ្រងពីចម្ងាយ',
      'subtitle': 'តាមដានស្ថានភាព និងបញ្ជាឧបករណ៍ពីចម្ងាយ',
      'image': 'assets/svgs/onboarding_step_3_mobile.svg',
    },
    {
      'title': 'ជួយឲ្យដំណាំលូតលាស់',
      'subtitle': 'បង្កើនទិន្នផល និងសន្សំសំចៃ',
      'image': 'assets/svgs/onboarding_step_4_growth.svg',
    },
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (currentPage.value < pages.length - 1) {
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
      await apiClient.storage.write(key: 'has_seen_onboarding', value: 'true');
    } catch (e) {
      debugPrint('Storage write error: $e');
    } finally {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
