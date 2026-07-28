import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class DevicePlacementCard extends StatelessWidget {
  const DevicePlacementCard({
    super.key,
    required this.device,
    required this.onTap,
    required this.selectionMode,
    required this.selected,
    required this.pending,
    this.onEdit,
  });

  final DeviceModel device;
  final VoidCallback onTap;
  final bool selectionMode;
  final bool selected;
  final bool pending;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryLight : AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.cardBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: device.isOnline
                          ? AppColors.onlineBadgeBg
                          : AppColors.offlineBadgeBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _deviceIcon,
                      color: device.isOnline
                          ? AppColors.onlineBadgeText
                          : AppColors.offlineBadgeText,
                      size: 26,
                    ),
                  ),
                  if (selectionMode)
                    Positioned(
                      right: -7,
                      top: -7,
                      child: Icon(
                        selected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  if (pending)
                    const Positioned(
                      left: -6,
                      bottom: -6,
                      child: SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                ],
              ),
              if (pending) ...[
                const SizedBox(height: 4),
                Text(
                  'command_pending'.tr,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                device.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: device.isOnline
                      ? AppColors.onlineBadgeBg
                      : AppColors.offlineBadgeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  device.isOnline ? 'online'.tr : 'offline'.tr,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: device.isOnline
                        ? AppColors.onlineBadgeText
                        : AppColors.offlineBadgeText,
                  ),
                ),
              ),
              if (!device.isOwner) ...[
                const SizedBox(height: 4),
                Text(
                  'shared_access_role'.tr,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              if (onEdit != null && !selectionMode)
                SizedBox.square(
                  dimension: 28,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    onPressed: onEdit,
                    tooltip: 'edit_device'.tr,
                    icon: const Icon(Icons.edit_outlined, size: 17),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData get _deviceIcon {
    if (device.name.toLowerCase().contains('irrig')) {
      return Icons.water_drop_outlined;
    }
    if (device.name.toLowerCase().contains('fan')) return Icons.air;
    if (device.name.toLowerCase().contains('roof')) {
      return Icons.roofing_outlined;
    }
    if (device.name.toLowerCase().contains('camera')) {
      return Icons.camera_alt_outlined;
    }
    return Icons.sensors;
  }
}
