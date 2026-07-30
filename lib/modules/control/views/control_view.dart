import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/config/app_data_source.dart';
import 'package:lntb_app/core/repositories/demo_prototype_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/control/controllers/control_controller.dart';
import 'package:lntb_app/modules/control/widgets/control_view_device_header.dart';
import 'package:lntb_app/modules/control/widgets/control_view_history_tile.dart';
import 'package:lntb_app/modules/farm/views/zone_control_view.dart';
import 'package:lntb_app/modules/main/controllers/main_controller.dart';

class ControlView extends GetView<ControlController> {
  const ControlView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(controller.device.name),
          actions: controller.device.isOwner
              ? [
                  IconButton(
                    onPressed: controller.manageUsers,
                    icon: const Icon(Icons.manage_accounts_outlined),
                    tooltip: 'manage_users'.tr,
                  ),
                ]
              : null,
        ),
        body: RefreshIndicator(
          onRefresh: controller.refreshHistory,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ControlDeviceHeader(device: controller.device),
              const SizedBox(height: 14),
              Card(
                color: AppColors.primaryLight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'daily_control'.tr,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      Text('daily_control_zone_help'.tr),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _openZoneControls,
                          icon: const Icon(Icons.eco_outlined),
                          label: Text('open_zone_controls'.tr),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ExpansionTile(
                initiallyExpanded: true,
                title: Text('device_details'.tr),
                leading: const Icon(Icons.info_outline),
                children: [
                  ListTile(
                    title: Text('firmware'.tr),
                    trailing: Text(
                      controller.device.firmwareVersion ?? 'unavailable'.tr,
                    ),
                  ),
                  ListTile(
                    title: Text('last_sync'.tr),
                    trailing: Text(
                      controller.device.lastSeenAt?.toLocal().toString() ??
                          'unavailable'.tr,
                    ),
                  ),
                  ListTile(
                    title: Text('connection'.tr),
                    trailing: Text(
                      controller.device.isOnline ? 'online'.tr : 'offline'.tr,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'recent_activity'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Obx(
                () => controller.history.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'no_history'.tr,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Column(
                        children: controller.history
                            .take(10)
                            .map(
                              (item) => ControlHistoryTile(record: item),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      );

  void _openZoneControls() {
    if (AppDataSourceConfig.isDemo &&
        Get.isRegistered<DemoPrototypeRepository>()) {
      final demo = Get.find<DemoPrototypeRepository>();
      Get.to(
        () => ZoneControlView(zone: demo.primaryZone, demo: demo),
      );
      return;
    }
    Get.back();
    if (Get.isRegistered<MainController>()) {
      Get.find<MainController>().changePage(1);
    }
  }
}
