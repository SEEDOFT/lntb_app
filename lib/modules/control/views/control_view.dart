import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/modules/control/controllers/control_controller.dart';
import 'package:lntb_app/modules/control/widgets/control_view_device_header.dart';
import 'package:lntb_app/modules/control/widgets/control_view_history_tile.dart';
import 'package:lntb_app/modules/control/widgets/control_view_toggle.dart';

class ControlView extends GetView<ControlController> {
  const ControlView({super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(controller.device.name),
            actions: controller.device.isOwner
                ? [
                    IconButton(
                      onPressed: controller.manageUsers,
                      icon: const Icon(Icons.manage_accounts_outlined),
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
                const SizedBox(height: 22),
                Text(
                  'device_controls'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Column(
                    children: [
                      ControlToggle(
                        title: 'irrigation'.tr,
                        icon: Icons.water_drop_outlined,
                        value: controller.latestState(
                          'irrigation.start',
                          'irrigation.stop',
                        ),
                        onChanged: (on) => controller.sendCommand(
                          on ? 'irrigation.start' : 'irrigation.stop',
                        ),
                      ),
                      ControlToggle(
                        title: 'fan'.tr,
                        icon: Icons.air,
                        value: controller.latestState('fan.start', 'fan.stop'),
                        onChanged: (on) => controller
                            .sendCommand(on ? 'fan.start' : 'fan.stop'),
                      ),
                      ControlToggle(
                        title: 'roof'.tr,
                        icon: Icons.roofing_outlined,
                        value:
                            controller.latestState('roof.open', 'roof.close'),
                        onChanged: (on) => controller
                            .sendCommand(on ? 'roof.open' : 'roof.close'),
                      ),
                      ControlToggle(
                        title: 'camera'.tr,
                        icon: Icons.camera_alt_outlined,
                        button: true,
                        value: false,
                        onChanged: (_) =>
                            controller.sendCommand('camera.capture'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'recent_activity'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
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
                              .map((item) => ControlHistoryTile(record: item))
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        ),
      );
}
