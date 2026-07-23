import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/control/controllers/control_controller.dart';

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
                  ),
                ]
              : null,
        ),
        body: RefreshIndicator(
          onRefresh: controller.refreshHistory,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _DeviceHeader(device: controller.device),
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
                    _Toggle(
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
                    _Toggle(
                      title: 'fan'.tr,
                      icon: Icons.air,
                      value: controller.latestState('fan.start', 'fan.stop'),
                      onChanged: (on) =>
                          controller.sendCommand(on ? 'fan.start' : 'fan.stop'),
                    ),
                    _Toggle(
                      title: 'roof'.tr,
                      icon: Icons.roofing_outlined,
                      value: controller.latestState('roof.open', 'roof.close'),
                      onChanged: (on) => controller
                          .sendCommand(on ? 'roof.open' : 'roof.close'),
                    ),
                    _Toggle(
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
                        child:
                            Text('no_history'.tr, textAlign: TextAlign.center),
                      )
                    : Column(
                        children: controller.history
                            .take(10)
                            .map((item) => _HistoryTile(record: item))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      );
}

class _DeviceHeader extends StatelessWidget {
  const _DeviceHeader({required this.device});
  final DeviceModel device;
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFEAF3FF),
                child: Icon(
                  Icons.energy_savings_leaf,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      device.macAddress,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    Text(
                      '${device.firmwareVersion ?? '-'} • ${device.accessRole.tr}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                device.status.tr,
                style: TextStyle(
                  color: device.isOnline
                      ? AppColors.success
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.button = false,
  });
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool button;
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title),
          trailing: button
              ? IconButton(
                  onPressed: () => onChanged(true),
                  icon: const Icon(Icons.play_circle, color: AppColors.primary),
                )
              : Switch(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: AppColors.success,
                ),
        ),
      );
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.record});
  final ControlRecord record;
  @override
  Widget build(BuildContext context) {
    final color = record.isPending
        ? Colors.orange
        : record.isCompleted
            ? AppColors.success
            : AppColors.error;
    return ListTile(
      leading: Icon(
        record.isCompleted
            ? Icons.check_circle
            : record.isPending
                ? Icons.schedule
                : Icons.error,
        color: color,
      ),
      title: Text(record.controlType.tr),
      subtitle: Text(record.requestedAt.toLocal().toString().substring(0, 16)),
      trailing: Text(
        record.status.tr,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
