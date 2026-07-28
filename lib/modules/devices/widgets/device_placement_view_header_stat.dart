import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_typography.dart';

class HeaderStat extends StatelessWidget {
  const HeaderStat({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFB9F5CC), size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.sensorValue.copyWith(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFD8FFE5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
