import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class ClaimViewScanCard extends StatelessWidget {
  const ClaimViewScanCard({super.key, required this.onScan});

  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.qr_code_2_rounded,
              size: 52,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'seller_qr_help'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onScan,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: Text('scan_activation_qr'.tr),
            ),
          ],
        ),
      );
}
