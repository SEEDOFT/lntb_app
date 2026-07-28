import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/modules/devices/widgets/device_placement_view_farm_layout_header.dart';
import 'package:lntb_app/modules/devices/widgets/device_placement_view_zone_section.dart';

class DevicePlacementView extends GetView<DeviceController> {
  const DevicePlacementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('farm_devices'.tr),
        surfaceTintColor: AppColors.background,
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.selectionMode.value
                  ? controller.cancelSelection
                  : () => controller.beginSelection(),
              child: Text(
                controller.selectionMode.value
                    ? 'cancel'.tr
                    : 'select_devices'.tr,
              ),
            ),
          ),
          IconButton(
            onPressed: controller.goToAddDevice,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => controller.selectionMode.value
            ? SafeArea(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(color: AppColors.cardBorder),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: controller.clearSelection,
                        tooltip: 'clear'.tr,
                        icon: const Icon(Icons.clear_all_rounded),
                      ),
                      Expanded(
                        child: Text(
                          'selected_count'.trParams({
                            'count':
                                controller.selectedDeviceIds.length.toString(),
                          }),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: controller.selectedDeviceIds.isEmpty
                            ? null
                            : () => _showControlReview(context),
                        child: Text('control_selected'.tr),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
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
                  const Icon(
                    Icons.router_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
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
              FarmLayoutHeader(
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
              ...controller.zones.expand(
                (zone) => [
                  ZoneSection(
                    label:
                        zone.key == '_unassigned' ? 'unassigned'.tr : zone.name,
                    color: AppColors.primary,
                    devices: zone.devices,
                    zone: zone,
                    selectionMode: controller.selectionMode.value,
                    selectedDeviceIds: controller.selectedDeviceIds,
                    pendingDeviceIds: controller.pendingCommandDeviceIds,
                    onDeviceTap: (device) {
                      if (controller.selectionMode.value) {
                        controller.toggleSelection(device);
                      } else {
                        controller.open(device);
                      }
                    },
                    onSelectAll: () => controller.selectZone(zone),
                    onEdit: (device) => _editDevice(context, device),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _showControlReview(BuildContext context) async {
    const commands = <String>[
      'irrigation.start',
      'irrigation.stop',
      'fan.start',
      'fan.stop',
      'roof.open',
      'roof.close',
      'camera.capture',
    ];
    var selectedCommand = commands.first;

    final shouldSend = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              20 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'review_command'.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'selected_count'.trParams({
                      'count': controller.selectedDevices.length.toString(),
                    }),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  ...controller.zones
                      .where(
                        (zone) => zone.devices.any(
                          (device) =>
                              controller.selectedDeviceIds.contains(device.id),
                        ),
                      )
                      .map(
                        (zone) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${zone.key == '_unassigned' ? 'unassigned'.tr : zone.name}: '
                            '${zone.devices.where((device) => controller.selectedDeviceIds.contains(device.id)).map((device) => device.name).join(', ')}',
                          ),
                        ),
                      ),
                  const Divider(height: 28),
                  Text(
                    'choose_command'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: commands
                        .map(
                          (command) => ChoiceChip(
                            label: Text(_commandLabel(command)),
                            selected: selectedCommand == command,
                            onSelected: (_) =>
                                setState(() => selectedCommand = command),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(sheetContext, true),
                      child: Text('review_and_send'.tr),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (shouldSend != true || !context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('confirm_command'.tr),
        content: Text(
          'confirm_batch_command'.trParams({
            'command': _commandLabel(selectedCommand),
            'count': controller.selectedDeviceIds.length.toString(),
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('send'.tr),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final result = await controller.sendBatchControl(selectedCommand);
    if (result == null || !context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('command_results'.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'batch_result_summary'.trParams({
                  'accepted': result.acceptedCount.toString(),
                  'failed': result.failedCount.toString(),
                }),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView(
                  shrinkWrap: true,
                  children: result.results.map((item) {
                    final device = controller.devices.firstWhereOrNull(
                      (device) => device.id == item.deviceId,
                    );
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        item.accepted
                            ? Icons.check_circle_rounded
                            : Icons.error_outline_rounded,
                        color:
                            item.accepted ? AppColors.primary : AppColors.error,
                      ),
                      title: Text(device?.name ?? '#${item.deviceId}'),
                      subtitle: item.accepted
                          ? Text('command_pending'.tr)
                          : Text(item.errorCode ?? 'command_failed'.tr),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('done'.tr),
          ),
        ],
      ),
    );
  }

  String _commandLabel(String command) => command.replaceAll('.', '_').tr;

  Future<void> _editDevice(
    BuildContext context,
    DeviceModel device,
  ) async {
    final name = TextEditingController(text: device.name);
    final placement = TextEditingController(text: device.placement ?? '');
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('edit_device'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(labelText: 'device_name'.tr),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: placement,
              decoration: InputDecoration(labelText: 'placement'.tr),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: name.text.trim().isEmpty
                ? null
                : () => Navigator.pop(dialogContext, true),
            child: Text('save'.tr),
          ),
        ],
      ),
    );
    if (shouldSave == true) {
      await controller.updateDevice(
        device,
        name: name.text,
        placement: placement.text,
      );
    }
    name.dispose();
    placement.dispose();
  }
}
