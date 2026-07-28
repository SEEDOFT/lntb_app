import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/routes/app_routes.dart';
import 'package:lntb_app/modules/home/widgets/home_view_overview_metric.dart';

class HomeDeviceOverview extends StatelessWidget {
  const HomeDeviceOverview({
    super.key,
    required this.total,
    required this.online,
    required this.owned,
  });

  final int total;
  final int online;
  final int owned;

  @override
  Widget build(BuildContext context) {
    final shared = total - owned;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .22),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'device_overview'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$total ${'total_devices'.tr}',
                      style: const TextStyle(
                        color: Color(0xFFD8FFE5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.hub_outlined,
                  color: Colors.white,
                  size: 27,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              HomeOverviewMetric(
                value: '$online',
                label: 'online'.tr,
                icon: Icons.wifi_rounded,
              ),
              HomeOverviewMetric(
                value: '$owned',
                label: 'owned'.tr,
                icon: Icons.verified_user_outlined,
              ),
              HomeOverviewMetric(
                value: '$shared',
                label: 'shared'.tr,
                icon: Icons.people_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Get.toNamed(Routes.CLAIM),
              style: FilledButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.add_rounded),
              label: Text('claim_device'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
