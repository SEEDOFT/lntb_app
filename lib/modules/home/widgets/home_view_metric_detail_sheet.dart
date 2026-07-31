import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/farm_dashboard_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/theme/app_typography.dart';
import 'package:lntb_app/core/utils/app_date_formatter.dart';

class HomeViewMetricDetailSheet extends StatelessWidget {
  const HomeViewMetricDetailSheet({
    super.key,
    required this.metric,
    required this.icon,
    required this.color,
  });

  final DashboardMetric metric;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final status = metric.status;
    final statusColor = _statusColor(status);
    final description = _statusDescription(status);
    final warning = _statusWarning(status);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _metricLabel(metric.code),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${metric.value.toStringAsFixed(metric.code == 'temperature' ? 1 : 0)}${metric.unit}',
                        style: AppTypography.sensorValue.copyWith(fontSize: 22),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(color: statusColor, label: status.tr),
              ],
            ),
            const SizedBox(height: 20),
            _DetailLine(
              icon: Icons.description_outlined,
              label: 'state_description'.tr,
              value: description,
            ),
            if (warning != null)
              _DetailLine(
                icon: Icons.warning_amber_rounded,
                label: 'state_warning'.tr,
                value: warning,
                valueColor: AppColors.warning,
              ),
            _DetailLine(
              icon: Icons.router_outlined,
              label: 'source_device'.tr,
              value:
                  metric.deviceName.isEmpty ? 'device'.tr : metric.deviceName,
            ),
            if (metric.recordedAt != null)
              _DetailLine(
                icon: Icons.access_time,
                label: 'recorded_at'.tr,
                value: metric.recordedAt!.toLocal().toAppFormattedString(),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text('close'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      );
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
}

Color _statusColor(String status) => switch (status) {
      'normal' => AppColors.success,
      'attention' => AppColors.warning,
      'low' || 'minimum' => Colors.orange,
      'high' || 'maximum' => AppColors.error,
      'critical' => AppColors.error,
      _ => AppColors.textSecondary,
    };

String _statusDescription(String status) => switch (status) {
      'normal' => 'sensor_status_normal_description'.tr,
      'attention' => 'sensor_status_attention_description'.tr,
      'low' || 'minimum' => 'sensor_status_minimum_description'.tr,
      'high' || 'maximum' => 'sensor_status_maximum_description'.tr,
      'critical' => 'sensor_status_critical_description'.tr,
      _ => 'sensor_status_unknown_description'.tr,
    };

String? _statusWarning(String status) => switch (status) {
      'normal' => null,
      'attention' => 'sensor_warning_attention'.tr,
      'low' || 'minimum' => 'sensor_warning_minimum'.tr,
      'high' || 'maximum' => 'sensor_warning_maximum'.tr,
      'critical' => 'sensor_warning_critical'.tr,
      _ => null,
    };

String _metricLabel(String code) => switch (code) {
      'soil_moisture' => 'soil_moisture'.tr,
      'temperature' => 'temperature'.tr,
      'humidity' => 'humidity'.tr,
      'light' => 'light'.tr,
      _ => code.tr,
    };
