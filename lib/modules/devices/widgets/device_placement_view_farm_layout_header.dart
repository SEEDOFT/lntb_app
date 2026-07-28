import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/devices/widgets/device_placement_view_header_stat.dart';

class FarmLayoutHeader extends StatelessWidget {
  const FarmLayoutHeader({
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.map_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'farm_map'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '$total ${'devices_in_farm'.tr}',
                    style: const TextStyle(
                      color: Color(0xFFD8FFE5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              HeaderStat(
                icon: Icons.wifi_rounded,
                value: '$online',
                label: 'online'.tr,
              ),
              HeaderStat(
                icon: Icons.verified_user_outlined,
                value: '$owned',
                label: 'owned'.tr,
              ),
              HeaderStat(
                icon: Icons.people_outline_rounded,
                value: '${total - owned}',
                label: 'shared'.tr,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
