import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_typography.dart';

class FarmCounter extends StatelessWidget {
  const FarmCounter({super.key, required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.sensorValue.copyWith(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFD8FFE5), fontSize: 11),
            ),
          ],
        ),
      );
}
