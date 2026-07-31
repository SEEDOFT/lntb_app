import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class AppFieldError extends StatelessWidget {
  const AppFieldError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 6, left: 12),
        child: Text(
          message,
          style: const TextStyle(
            color: AppColors.error,
            fontSize: 12,
          ),
        ),
      );
}
