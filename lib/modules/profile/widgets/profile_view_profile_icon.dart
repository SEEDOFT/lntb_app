import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.primary),
      );
}
