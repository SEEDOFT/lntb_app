import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/modules/onboarding/widgets/onboarding_view_dots.dart';

class OnboardingBottomBar extends StatelessWidget {
  const OnboardingBottomBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.isLastPage,
    required this.onNext,
  });

  final RxInt currentPage;
  final int totalPages;
  final bool isLastPage;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Row(
          children: [
            Obx(
              () => OnboardingDots(
                count: totalPages,
                activeIndex: currentPage.value,
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: onNext,
              child: Text(isLastPage ? 'get_started'.tr : 'next'.tr),
            ),
          ],
        ),
      );
}
