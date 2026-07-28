import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class HomeStatusBadge extends StatelessWidget {
  const HomeStatusBadge({super.key, required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: isOnline ? AppColors.onlineBadgeBg : AppColors.offlineBadgeBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: isOnline
                    ? AppColors.onlineBadgeText
                    : AppColors.offlineBadgeText,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              isOnline ? 'online'.tr : 'offline'.tr,
              style: TextStyle(
                color: isOnline
                    ? AppColors.onlineBadgeText
                    : AppColors.offlineBadgeText,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
}
