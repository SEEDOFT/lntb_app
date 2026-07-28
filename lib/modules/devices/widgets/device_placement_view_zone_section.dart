import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/devices/widgets/device_placement_view_device_placement_card.dart';

class ZoneSection extends StatelessWidget {
  const ZoneSection({
    super.key,
    required this.label,
    required this.color,
    required this.devices,
    required this.zone,
    required this.selectionMode,
    required this.selectedDeviceIds,
    required this.pendingDeviceIds,
    required this.onDeviceTap,
    required this.onSelectAll,
    required this.onEdit,
  });

  final String label;
  final Color color;
  final List<DeviceModel> devices;
  final DeviceZone zone;
  final bool selectionMode;
  final Set<int> selectedDeviceIds;
  final Set<int> pendingDeviceIds;
  final ValueChanged<DeviceModel> onDeviceTap;
  final VoidCallback onSelectAll;
  final ValueChanged<DeviceModel> onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            if (selectionMode)
              TextButton(
                onPressed: onSelectAll,
                child: Text('select_zone'.tr),
              ),
            const SizedBox(width: 8),
            Text(
              '(${devices.length})',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.82,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: devices.length,
          itemBuilder: (_, index) => DevicePlacementCard(
            device: devices[index],
            onTap: () => onDeviceTap(devices[index]),
            selectionMode: selectionMode,
            selected: selectedDeviceIds.contains(devices[index].id),
            pending: pendingDeviceIds.contains(devices[index].id),
            onEdit:
                devices[index].isOwner ? () => onEdit(devices[index]) : null,
          ),
        ),
      ],
    );
  }
}
