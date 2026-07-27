import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/routes/app_routes.dart';

class DevicePlacementView extends GetView<DeviceController> {
  const DevicePlacementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('farm_devices'.tr),
        surfaceTintColor: AppColors.background,
        actions: [
          IconButton(
            onPressed: controller.goToAddDevice,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchDevices,
        child: Obx(() {
          if (controller.isLoading.value && controller.devices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.devices.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.router_outlined, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text('no_devices'.tr),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: controller.goToAddDevice,
                    icon: const Icon(Icons.add),
                    label: Text('claim_device'.tr),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _FarmLayoutHeader(
                total: controller.devices.length,
                online: controller.devices.where((d) => d.isOnline).length,
                owned: controller.devices.where((d) => d.isOwner).length,
              ),
              const SizedBox(height: 24),
              Text(
                'device_placement'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'tap_device_to_control'.tr,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),

              // Owned devices section
              if (controller.ownedDevices.isNotEmpty) ...[
                _ZoneSection(
                  label: 'my_devices'.tr,
                  color: AppColors.primary,
                  devices: controller.ownedDevices,
                ),
                const SizedBox(height: 20),
              ],

              // Shared devices section
              if (controller.sharedDevices.isNotEmpty) ...[
                _ZoneSection(
                  label: 'shared_devices'.tr,
                  color: AppColors.info,
                  devices: controller.sharedDevices,
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}

class _FarmLayoutHeader extends StatelessWidget {
  const _FarmLayoutHeader({
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
                child: const Icon(Icons.map_outlined, color: Colors.white, size: 26),
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
              _HeaderStat(
                icon: Icons.wifi_rounded,
                value: '$online',
                label: 'online'.tr,
              ),
              _HeaderStat(
                icon: Icons.verified_user_outlined,
                value: '$owned',
                label: 'owned'.tr,
              ),
              _HeaderStat(
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

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFB9F5CC), size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFD8FFE5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneSection extends StatelessWidget {
  const _ZoneSection({
    required this.label,
    required this.color,
    required this.devices,
  });

  final String label;
  final Color color;
  final List<DeviceModel> devices;

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
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
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
            childAspectRatio: 0.95,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: devices.length,
          itemBuilder: (_, index) => _DevicePlacementCard(
            device: devices[index],
            onTap: () => Get.toNamed(Routes.CONTROL, arguments: devices[index]),
          ),
        ),
      ],
    );
  }
}

class _DevicePlacementCard extends StatelessWidget {
  const _DevicePlacementCard({
    required this.device,
    required this.onTap,
  });

  final DeviceModel device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ),
      ),
    );
  }

  IconData get _deviceIcon {
    if (device.name.toLowerCase().contains('irrig')) return Icons.water_drop_outlined;
    if (device.name.toLowerCase().contains('fan')) return Icons.air;
    if (device.name.toLowerCase().contains('roof')) return Icons.roofing_outlined;
    if (device.name.toLowerCase().contains('camera')) return Icons.camera_alt_outlined;
    return Icons.sensors;
  }
}
