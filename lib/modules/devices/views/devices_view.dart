import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/modules/devices/views/device_placement_view.dart';
import 'package:lntb_app/modules/devices/widgets/devices_view_device_card.dart';
import 'package:lntb_app/modules/devices/widgets/devices_view_state.dart';

class DevicesView extends GetView<DeviceController> {
  const DevicesView({super.key, this.sharedOnly = false});
  final bool sharedOnly;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
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
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: sharedOnly
                ? null
                : [
                    IconButton(
                      onPressed: () =>
                          Get.to(() => const DevicePlacementView()),
                      icon: const Icon(Icons.map_outlined),
                      tooltip: 'farm_layout'.tr,
                    ),
                    IconButton(
                      onPressed: controller.goToAddDevice,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
          ),
          body: Obx(() {
            final list =
                sharedOnly ? controller.sharedDevices : controller.ownedDevices;
            if (controller.isLoading.value && list.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (list.isEmpty) {
              return DevicesState(
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
                itemBuilder: (_, index) => DeviceCard(
                  device: list[index],
                  onTap: () => controller.open(list[index]),
                ),
              ),
            );
          }),
        ),
      );
}
