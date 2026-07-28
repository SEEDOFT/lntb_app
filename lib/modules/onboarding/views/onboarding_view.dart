import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:lntb_app/modules/onboarding/widgets/onboarding_view_bottom_bar.dart';
import 'package:lntb_app/modules/onboarding/widgets/onboarding_view_onboarding_page.dart';
import 'package:lntb_app/modules/onboarding/widgets/onboarding_view_skip_button.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Obx(
                () => controller.isLastPage
                    ? const SizedBox(height: 48)
                    : OnboardingSkipButton(onPressed: controller.skip),
              ),
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.totalPages,
                  itemBuilder: (_, index) => OnboardingPage(
                    imagePath: controller.pages[index]['image']!,
                    title: controller.pages[index]['title']!.tr,
                    subtitle: controller.pages[index]['subtitle']!.tr,
                  ),
                ),
              ),
              Obx(
                () => OnboardingBottomBar(
                  currentPage: controller.currentPage,
                  totalPages: controller.totalPages,
                  isLastPage: controller.isLastPage,
                  onNext: controller.next,
                ),
              ),
            ],
          ),
        ),
      );
}
