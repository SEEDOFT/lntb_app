import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

/// Per-type accent used for the gradient icon tile in the device card.
class DeviceTypeStyle {
  const DeviceTypeStyle({
    required this.gradient,
    required this.icon,
    required this.iconColor,
  });

  final LinearGradient gradient;
  final IconData icon;
  final Color iconColor;
}

class DeviceTypeStyles {
  static DeviceTypeStyle of(DeviceModel device) {
    if (device.isCamera) {
      return const DeviceTypeStyle(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C5CFF), Color(0xFF4F3BCC)],
        ),
        icon: Icons.camera_alt_rounded,
        iconColor: Colors.white,
      );
    }
    if (device.isRoof) {
      return const DeviceTypeStyle(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFB35C), Color(0xFFF2803B)],
        ),
        icon: Icons.roofing_rounded,
        iconColor: Colors.white,
      );
    }
    if (device.isMeter) {
      return const DeviceTypeStyle(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF34C77B), Color(0xFF0E9F58)],
        ),
        icon: Icons.speed_rounded,
        iconColor: Colors.white,
      );
    }
    return const DeviceTypeStyle(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3EC2F0), Color(0xFF1488C7)],
      ),
      icon: Icons.air_rounded,
      iconColor: Colors.white,
    );
  }
}

class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key, required this.device, required this.onTap});
  final DeviceModel device;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final style = DeviceTypeStyles.of(device);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: style.gradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: style.gradient.colors.first.withValues(alpha: .35),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(style.icon, color: style.iconColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.deviceDisplayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        if (device.typeCode != null)
                          'device_type_${device.typeCode}'.tr,
                        if (device.placement != null) device.placement,
                      ].whereType<String>().join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.lan_outlined,
                          size: 12,
                          color: device.isOnline
                              ? AppColors.onlineBadgeText
                              : AppColors.offlineBadgeText,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            device.macAddress,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: device.isOnline
                          ? AppColors.onlineBadgeBg
                          : AppColors.offlineBadgeBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 7,
                          color: device.isOnline
                              ? AppColors.onlineBadgeText
                              : AppColors.offlineBadgeText,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          device.status.tr,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: device.isOnline
                                ? AppColors.onlineBadgeText
                                : AppColors.offlineBadgeText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    device.accessRole.tr,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: device.isOwner
                          ? AppColors.primary
                          : const Color(0xFF2E90D1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
