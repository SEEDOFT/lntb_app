import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: Column(
                  children: [
                    SizedBox(
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
                    const SizedBox(height: 10),
                    Obx(
                      () => _SummaryStrip(
                        ownedCount: controller.ownedCount,
                        sharedCount: controller.sharedCount,
                        onlineCount: controller.onlineCount,
                      ),
                    ),
                  ],
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
                    child: _DeviceGroupedList(
                      controller: controller,
                      devices: list,
                      onTap: controller.open,
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

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({
    required this.ownedCount,
    required this.sharedCount,
    required this.onlineCount,
  });

  final int ownedCount;
  final int sharedCount;
  final int onlineCount;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            _SummaryItem(
              icon: Icons.person_outline,
              label: 'owned'.tr,
              value: ownedCount,
              color: AppColors.primary,
            ),
            _SummaryDivider(),
            _SummaryItem(
              icon: Icons.people_outline,
              label: 'shared'.tr,
              value: sharedCount,
              color: const Color(0xFF2E90D1),
            ),
            _SummaryDivider(),
            _SummaryItem(
              icon: Icons.circle,
              label: 'online'.tr,
              value: onlineCount,
              color: AppColors.onlineBadgeText,
            ),
          ],
        ),
      );
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                ),
              ),
            ),
          ],
        ),
      );
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 22,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: AppColors.cardBorder,
      );
}

class _DeviceGroupedList extends StatelessWidget {
  const _DeviceGroupedList({
    required this.controller,
    required this.devices,
    required this.onTap,
  });

  final DeviceController controller;
  final List<DeviceModel> devices;
  final void Function(DeviceModel) onTap;

  @override
  Widget build(BuildContext context) {
    final groups = controller.groupByPlacement(devices);
    final unassignedDevices = groups.remove('');
    final keys = groups.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 28),
      children: [
        if (unassignedDevices != null) ...[
          _GroupHeader(label: controller.placementLabel('')),
          ...unassignedDevices.map(
            (device) => DeviceCard(device: device, onTap: () => onTap(device)),
          ),
        ],
        for (final key in keys) ...[
          _GroupHeader(label: controller.placementLabel(key)),
          ...groups[key]!.map(
            (device) => DeviceCard(device: device, onTap: () => onTap(device)),
          ),
        ],
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
        child: Row(
          children: [
            Icon(Icons.place_outlined,
                size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
}
