import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/claim/controllers/claim_controller.dart';
import 'package:lntb_app/modules/claim/widgets/claim_view_account_card.dart';
import 'package:lntb_app/modules/claim/widgets/claim_view_activation_icon.dart';
import 'package:lntb_app/modules/claim/widgets/claim_view_review_card.dart';
import 'package:lntb_app/modules/claim/widgets/claim_view_scan_card.dart';

class ClaimView extends GetView<ClaimController> {
  const ClaimView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          title: Text('activate_device'.tr),
        ),
        body: Obx(
          () => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const ClaimViewActivationIcon(),
              const SizedBox(height: 18),
              Text(
                'activate_device'.tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'activation_subtitle'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              if (controller.payload.value == null)
                ClaimViewScanCard(onScan: controller.scanBarcode)
              else
                ClaimViewReviewCard(controller: controller),
              const SizedBox(height: 18),
              ClaimViewAccountCard(
                name: controller.currentUser.value?.name,
                contact: controller.currentUser.value?.contact,
              ),
            ],
          ),
        ),
      );
}
