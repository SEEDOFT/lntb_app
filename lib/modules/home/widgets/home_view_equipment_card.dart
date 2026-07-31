import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class HomeViewEquipmentCard extends StatelessWidget {
  const HomeViewEquipmentCard({super.key, required this.activity});

  final List<ControlRecord> activity;

  @override
  Widget build(BuildContext context) {
    final active = _activeEquipment();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.power_settings_new_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'equipment_running'.tr,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      active.isEmpty
                          ? 'nothing_running'.tr
                          : active.map((item) => item.label).join(' • '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: active.isEmpty
                      ? AppColors.inputFill
                      : AppColors.onlineBadgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  active.length.toString(),
                  style: TextStyle(
                    color: active.isEmpty
                        ? AppColors.textSecondary
                        : AppColors.onlineBadgeText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (active.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: active
                  .map(
                    (item) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            size: 17,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  List<_EquipmentItem> _activeEquipment() {
    final latest = <String, String>{};
    for (final record in activity) {
      final equipment = record.controlType.split('.').first;
      latest.putIfAbsent(equipment, () => record.controlType);
    }

    return [
      if (latest['irrigation'] == 'irrigation.start')
        _EquipmentItem(Icons.water_rounded, 'water'.tr),
      if (latest['fan'] == 'fan.start')
        _EquipmentItem(Icons.air_rounded, 'fan'.tr),
      if (latest['roof'] == 'roof.open')
        _EquipmentItem(Icons.roofing_rounded, 'roof'.tr),
    ];
  }
}

class _EquipmentItem {
  const _EquipmentItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
