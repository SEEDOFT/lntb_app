import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class ClaimViewAccountCard extends StatelessWidget {
  const ClaimViewAccountCard({
    super.key,
    required this.name,
    required this.contact,
  });

  final String? name;
  final String? contact;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.person_rounded, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? 'signed_in_customer'.tr,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (contact != null && contact!.isNotEmpty)
                    Text(
                      contact!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
}
