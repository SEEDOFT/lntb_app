import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
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
        toolbarHeight: 76,
        centerTitle: false,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'devices'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'devices_subtitle'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        actions: [
          if (filter == 'owned')
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: IconButton.filledTonal(
                onPressed: controller.goToAddDevice,
                icon: const Icon(Icons.add_rounded),
                tooltip: 'claim_device'.tr,
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  backgroundColor: AppColors.primaryLight,
                ),
              ),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
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
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: AppColors.primaryLight,
                      selectedForegroundColor: AppColors.primaryDark,
                      foregroundColor: AppColors.textSecondary,
                      backgroundColor: AppColors.surface,
                      side: const BorderSide(color: AppColors.cardBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                      action:
                          filter == 'shared' ? null : controller.goToAddDevice,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: controller.fetchDevices,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
                      children: list
                          .map(
                            (device) => DeviceCard(
                              device: device,
                              onTap: () => controller.open(device),
                            ),
                          )
                          .toList(),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
