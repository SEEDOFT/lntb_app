import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/modules/control/controllers/control_controller.dart';
import 'package:lntb_app/modules/control/widgets/control_view_daily_control_card.dart';
import 'package:lntb_app/modules/control/widgets/control_view_details_tile.dart';
import 'package:lntb_app/modules/control/widgets/control_view_device_header.dart';
import 'package:lntb_app/modules/control/widgets/control_view_history_tile.dart';

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
              if (controller.device.isFan ||
                  controller.device.isRoof ||
                  controller.device.isCamera) ...[
                Obx(
                  () => ControlViewDailyControlCard(
                    isFan: controller.device.isFan,
                    isRoof: controller.device.isRoof,
                    isCamera: controller.device.isCamera,
                    fanRunning: controller.latestState(
                      'fan.start',
                      'fan.stop',
                    ),
                    roofOpen: controller.latestState(
                      'roof.open',
                      'roof.close',
                    ),
                    enabled: controller.device.isOnline &&
                        !controller.isLoading.value,
                    onCommand: controller.sendCommand,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              ControlViewDetailsTile(device: controller.device),
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
}
