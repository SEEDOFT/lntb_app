import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/claim/controllers/claim_controller.dart';

class ClaimViewReviewCard extends StatelessWidget {
  const ClaimViewReviewCard({super.key, required this.controller});

  final ClaimController controller;

  @override
  Widget build(BuildContext context) {
    final deviceName = controller.payload.value?.name;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_rounded, color: AppColors.success),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'activation_qr_ready'.tr,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              IconButton(
                onPressed: controller.clearSensitiveState,
                tooltip: 'scan_again'.tr,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          if (deviceName != null && deviceName.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              deviceName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: controller.nameController,
            maxLength: 120,
            decoration: InputDecoration(
              labelText: 'device_name'.tr,
              hintText: deviceName,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: controller.canActivate ? controller.claimDevice : null,
              icon: controller.isLoading.value
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.verified_user_rounded),
              label: Text('confirm_activation'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
