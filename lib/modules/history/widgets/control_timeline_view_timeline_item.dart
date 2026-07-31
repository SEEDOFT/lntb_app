import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/translations/control_type_labels.dart';
import 'package:lntb_app/core/utils/app_date_formatter.dart';
import 'package:lntb_app/core/utils/unit_formatter.dart';

/// Formats runtime as "2h 05m" or "45m" or "30s" (localized).
String formatRuntime(Duration? runtime) {
  if (runtime == null || runtime.inSeconds <= 0) return '—';
  final hours = runtime.inHours;
  final minutes = runtime.inMinutes % 60;
  final seconds = runtime.inSeconds % 60;
  if (hours > 0) {
    return '$hours${'unit_hour'.tr} '
        '${minutes.toString().padLeft(2, '0')}${'unit_minute'.tr}';
  }
  if (minutes > 0) {
    return '$minutes${'unit_minute'.tr} '
        '${seconds.toString().padLeft(2, '0')}${'unit_second'.tr}';
  }
  return '$seconds${'unit_second'.tr}';
}

String formatEnergyKwh(double? kwh) =>
    kwh == null ? '—' : '${kwh.toStringAsFixed(3)} ${localizedUnit('kWh')}';

class TimelineItem extends StatelessWidget {
  const TimelineItem({
    super.key,
    required this.entry,
    required this.isLast,
    this.onTap,
  });

  final HistoryTimelineEntry entry;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final record = entry.record;
    final isStart = _isStartAction(record.controlType);
    final actionColor = isStart ? AppColors.success : AppColors.primary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: actionColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_actionIcon(record.controlType),
                      color: actionColor, size: 17),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: AppColors.cardBorder),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.controlType.controlTypeLabel,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.5,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  entry.deviceDisplayName,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _PowerBadge(energyKwh: entry.energyKwh),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              record.requestedAt.toAppFormattedString(),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (entry.runtime != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.timelapse_rounded,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  formatRuntime(entry.runtime),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (record.failureMessage != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 16,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  record.failureMessage!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isStartAction(String controlType) =>
      controlType.endsWith('.start') ||
      controlType.endsWith('.open') ||
      controlType == 'camera.capture';

  IconData _actionIcon(String controlType) {
    if (controlType.startsWith('irrigation.')) {
      return controlType.endsWith('.stop')
          ? Icons.water_drop_outlined
          : Icons.water_drop_rounded;
    }
    if (controlType.startsWith('fan.')) {
      return Icons.air_rounded;
    }
    if (controlType.startsWith('roof.')) {
      return Icons.roofing_outlined;
    }
    return Icons.photo_camera_outlined;
  }
}

class _PowerBadge extends StatelessWidget {
  const _PowerBadge({required this.energyKwh});

  final double? energyKwh;

  @override
  Widget build(BuildContext context) {
    final hasEnergy = energyKwh != null;
    final color = hasEnergy ? AppColors.primary : AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt_rounded, size: 13, color: color),
          const SizedBox(width: 3),
          Text(
            formatEnergyKwh(energyKwh),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
