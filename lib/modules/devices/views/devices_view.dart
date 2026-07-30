import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/modules/devices/views/device_placement_view.dart';
import 'package:lntb_app/modules/devices/widgets/devices_view_device_card.dart';
import 'package:lntb_app/modules/devices/widgets/devices_view_state.dart';

class DevicesView extends StatefulWidget {
  const DevicesView({super.key});
  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  String filter = 'owned';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DeviceController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('devices'.tr),
            Text(
              'devices_subtitle'.tr,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const DevicePlacementView()),
            icon: const Icon(Icons.dashboard_customize_outlined),
            tooltip: 'farm_layout'.tr,
          ),
          if (filter == 'owned')
            IconButton(
              onPressed: controller.goToAddDevice,
              icon: const Icon(Icons.add_circle_outline),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'owned',
                    icon: const Icon(Icons.person_outline),
                    label: Text('owned'.tr),
                  ),
                  ButtonSegment(
                    value: 'shared',
                    icon: const Icon(Icons.people_outline),
                    label: Text('shared'.tr),
                  ),
                ],
                selected: {filter},
                onSelectionChanged: (value) =>
                    setState(() => filter = value.first),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final list = filter == 'shared'
                  ? controller.sharedDevices
                  : controller.ownedDevices;
              if (controller.isLoading.value && list.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (list.isEmpty) {
                return DevicesState(
                  icon: filter == 'shared'
                      ? Icons.people_outline
                      : Icons.router_outlined,
                  text: filter == 'shared'
                      ? 'no_shared_devices'.tr
                      : 'no_devices'.tr,
                  action: filter == 'shared' ? null : controller.goToAddDevice,
                );
              }
              return RefreshIndicator(
                onRefresh: controller.fetchDevices,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
                  children: [
                    Card(
                      color: AppColors.primaryLight,
                      child: ListTile(
                        leading: const Icon(
                          Icons.map_outlined,
                          color: AppColors.primary,
                        ),
                        title: Text('zone_control_board'.tr),
                        subtitle: Text('zone_control_board_help'.tr),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Get.to(() => const DevicePlacementView()),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...list.map(
                      (device) => DeviceCard(
                        device: device,
                        onTap: () => controller.open(device),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
