import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_typography.dart';

class HomeOverviewMetric extends StatelessWidget {
  const HomeOverviewMetric({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFB9F5CC), size: 20),
            const SizedBox(height: 5),
            Text(
              value,
              style: AppTypography.sensorValue.copyWith(
                color: Colors.white,
                fontSize: 21,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFD8FFE5),
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
}
