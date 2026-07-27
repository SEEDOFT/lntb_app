import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/constants/app_assets.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/onboarding/controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              children: [
                Image.asset(AppAssets.logo, height: 58),
                const SizedBox(height: 10),
                Text(
                  'LNTB IoT',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'welcome_description'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                Expanded(
                  child: SvgPicture.asset(
                    AppAssets.onboardingStep1Farmer,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.finishOnboarding,
                    child: Text('get_started'.tr),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'phase_one_tagline'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      );
}
