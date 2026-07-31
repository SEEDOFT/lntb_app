import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/theme/app_typography.dart';

class HomeViewMetricCard extends StatelessWidget {
  const HomeViewMetricCard({
    super.key,
    required this.width,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    this.decimals = 0,
    this.onTap,
  });

  final double width;
  final String label;
  final double? value;
  final String unit;
  final IconData icon;
  final Color color;
  final int decimals;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 23),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        value == null
                            ? '—'
                            : '${value!.toStringAsFixed(decimals)}$unit',
                        style: AppTypography.sensorValue.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
