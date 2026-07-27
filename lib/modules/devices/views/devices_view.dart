import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';

class DevicesView extends GetView<DeviceController> {
  const DevicesView({super.key, this.sharedOnly = false});
  final bool sharedOnly;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sharedOnly ? 'shared_access'.tr : 'devices'.tr,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(
                'devices_subtitle'.tr,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          actions: sharedOnly
              ? null
              : [
                  IconButton.filledTonal(
                    onPressed: controller.goToAddDevice,
                    icon: const Icon(Icons.add_rounded),
                  ),
                  const SizedBox(width: 10),
                ],
        ),
        body: Obx(() {
          if (controller.isLoading.value && controller.devices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final list =
              sharedOnly ? controller.sharedDevices : controller.devices;
          if (controller.error.value != null && list.isEmpty) {
            return _State(
              icon: Icons.cloud_off,
              text: 'load_failed'.tr,
              action: controller.fetchDevices,
            );
          }
          if (list.isEmpty) {
            return _State(
              icon: Icons.router_outlined,
              text: sharedOnly ? 'no_shared_devices'.tr : 'no_devices'.tr,
              action: sharedOnly ? null : controller.goToAddDevice,
            );
          }
          return RefreshIndicator(
            onRefresh: controller.fetchDevices,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
              itemCount: list.length,
              itemBuilder: (_, index) => _DeviceCard(
                device: list[index],
                onTap: () => controller.open(list[index]),
              ),
            ),
          );
        }),
      );
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.device, required this.onTap});
  final DeviceModel device;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.energy_savings_leaf_outlined,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        device.macAddress,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        device.accessRole.tr,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
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
                const SizedBox(width: 2),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      );
}

class _State extends StatelessWidget {
  const _State({required this.icon, required this.text, this.action});
  final IconData icon;
  final String text;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 34, color: AppColors.primary),
              ),
              const SizedBox(height: 18),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              if (action != null) ...[
                const SizedBox(height: 18),
                FilledButton(onPressed: action, child: Text('try_again'.tr)),
              ],
            ],
          ),
        ),
      );
}
