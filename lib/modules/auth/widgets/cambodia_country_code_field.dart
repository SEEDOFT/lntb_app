import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class CambodiaCountryCodeField extends StatelessWidget {
  const CambodiaCountryCodeField({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cambodia country code plus eight five five',
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          border: Border.all(color: AppColors.inputBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🇰🇭', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text(
              '+855',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
