import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/farm/farm_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/farm/widgets/farm_view_counter.dart';

class FarmSummary extends StatelessWidget {
  const FarmSummary({super.key, required this.dashboard});
  final FarmDashboard dashboard;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDark, AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .2),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dashboard.farm.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: Color(0xFF9AF2B5),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dashboard.farm.status.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              dashboard.farm.currentCrop ?? 'no_active_crop'.tr,
              style: const TextStyle(color: Color(0xFFD8FFE5)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                FarmCounter(
                  value: '${dashboard.openTaskCount}',
                  label: 'open_tasks'.tr,
                ),
                FarmCounter(
                  value: '${dashboard.onlineDeviceCount}',
                  label: 'online_devices'.tr,
                ),
                FarmCounter(
                  value: '${dashboard.metrics.length}',
                  label: 'sensor_readings'.tr,
                ),
              ],
            ),
          ],
        ),
      );
}
