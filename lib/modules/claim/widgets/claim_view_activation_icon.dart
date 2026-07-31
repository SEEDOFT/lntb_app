import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class ClaimViewActivationIcon extends StatelessWidget {
  const ClaimViewActivationIcon({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 88,
          height: 88,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.router_rounded,
            size: 46,
            color: AppColors.primary,
          ),
        ),
      );
}
