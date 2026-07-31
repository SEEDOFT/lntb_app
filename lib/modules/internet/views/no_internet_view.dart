import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/services/internet_status_service.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/routes/app_routes.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Get.find<InternetStatusService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.wifi_off_rounded,
                      size: 42,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'no_internet_title'.tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'no_internet_message'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 22),
                  Obx(
                    () => FilledButton.icon(
                      onPressed: () async {
                        final online = await service.check();
                        if (online) {
                          unawaited(Get.offAllNamed(Routes.SPLASH));
                        }
                      },
                      icon: service.isOnline.value
                          ? const Icon(Icons.refresh_rounded)
                          : const Icon(Icons.wifi_find_rounded),
                      label: Text('try_again'.tr),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
