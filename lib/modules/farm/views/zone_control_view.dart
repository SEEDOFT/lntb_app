import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/prototype/prototype_models.dart';
import 'package:lntb_app/core/repositories/demo_prototype_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/theme/app_typography.dart';

class ZoneControlView extends StatelessWidget {
  const ZoneControlView({
    required this.zone,
    required this.demo,
    super.key,
  });

  final FarmZone zone;
  final DemoPrototypeRepository demo;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(zone.name)),
        body: Obx(() {
          demo.scenario.value;
          demo.actuatorStates.length;
          demo.latestCommands.length;
          demo.remainingIrrigationMinutes.value;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SimpleConditions(demo: demo),
                  const SizedBox(height: 14),
                  if (demo.blockingReason.isNotEmpty)
                    _SafetyMessage(reason: demo.blockingReason),
                  if (demo.blockingReason.isNotEmpty)
                    const SizedBox(height: 14),
                  _ControlCard(
                    icon: Icons.water_drop_outlined,
                    title: 'water'.tr,
                    state: demo.actuators[ActuatorKind.pump]!,
                    command: demo.latestCommands[ActuatorKind.pump],
                    activeLabel: 'watering_now'.tr,
                    inactiveLabel: 'currently_stopped'.tr,
                    primaryLabel: 'start_watering'.tr,
                    stopLabel: 'stop_now'.tr,
                    remainingMinutes: demo.remainingIrrigationMinutes.value,
                    blocked: demo.controlsBlocked,
                    onPrimary: () => _chooseWateringDuration(context),
                    onStop: () => _stop(context, ActuatorKind.pump),
                  ),
                  _ControlCard(
                    icon: Icons.air,
                    title: 'fan'.tr,
                    state: demo.actuators[ActuatorKind.fan]!,
                    command: demo.latestCommands[ActuatorKind.fan],
                    activeLabel: 'fan_running'.tr,
                    inactiveLabel: 'fan_stopped'.tr,
                    primaryLabel: 'start_fan'.tr,
                    stopLabel: 'stop_fan'.tr,
                    blocked: demo.controlsBlocked,
                    onPrimary: () => _confirmSimple(
                      context,
                      ActuatorKind.fan,
                      'start_fan'.tr,
                    ),
                    onStop: () => _stop(context, ActuatorKind.fan),
                  ),
                  _ControlCard(
                    icon: Icons.roofing_outlined,
                    title: 'roof'.tr,
                    state: demo.actuators[ActuatorKind.roof]!,
                    command: demo.latestCommands[ActuatorKind.roof],
                    activeLabel: 'roof_open'.tr,
                    inactiveLabel: 'roof_closed'.tr,
                    primaryLabel: 'open_roof'.tr,
                    stopLabel: 'close_roof'.tr,
                    blocked: demo.controlsBlocked,
                    onPrimary: () => _confirmSimple(
                      context,
                      ActuatorKind.roof,
                      'open_roof'.tr,
                    ),
                    onStop: () => _stop(context, ActuatorKind.roof),
                  ),
                  _CameraCard(zone: zone, demo: demo),
                  const SizedBox(height: 8),
                  ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 4),
                    title: Text('device_details'.tr),
                    leading: const Icon(Icons.info_outline),
                    children: [
                      ListTile(
                        title: Text(zone.controllerName),
                        subtitle: Text(
                          '${'last_sync'.tr}: 08:00 UTC\n'
                          '${'calibrated'.tr} • ${'prototype_firmware'.tr}',
                        ),
                        isThreeLine: true,
                      ),
                      ListTile(
                        title: Text(zone.cameraName),
                        subtitle: Text(
                          demo.connected ? 'online'.tr : 'offline'.tr,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      );

  Future<void> _chooseWateringDuration(BuildContext context) async {
    final duration = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'how_long_water'.tr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                '${'current_soil'.tr}: '
                '${demo.readings[0].value?.toStringAsFixed(0) ?? '—'}%',
              ),
              const SizedBox(height: 16),
              Row(
                children: [5, 10, 15]
                    .map(
                      (minutes) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, minutes),
                            child: Text('$minutes ${'minutes'.tr}'),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
    if (duration == null || !context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('start_watering'.tr),
        content: Text(
          'confirm_watering'.trParams({
            'zone': zone.name,
            'minutes': duration.toString(),
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('start'.tr),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await demo.runZoneCommand(
        zone,
        ActuatorKind.pump,
        true,
        durationMinutes: duration,
      );
    }
  }

  Future<void> _confirmSimple(
    BuildContext context,
    ActuatorKind kind,
    String action,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action),
        content: Text(
          'confirm_simple_action'.trParams({
            'action': action,
            'zone': zone.name,
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('confirm'.tr),
          ),
        ],
      ),
    );
    if (confirmed == true) await demo.runZoneCommand(zone, kind, true);
  }

  Future<void> _stop(BuildContext context, ActuatorKind kind) async {
    final result = await demo.runZoneCommand(zone, kind, false);
    if (result == ActuatorState.queued && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('offline_stop_saved'.tr)),
      );
    }
  }
}

class _SimpleConditions extends StatelessWidget {
  const _SimpleConditions({required this.demo});
  final DemoPrototypeRepository demo;

  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.primaryLight,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _ConditionValue(
                  label: 'soil_1'.tr,
                  value:
                      '${demo.readings[0].value?.toStringAsFixed(0) ?? '—'}%',
                ),
              ),
              Expanded(
                child: _ConditionValue(
                  label: 'soil_2'.tr,
                  value:
                      '${demo.readings[1].value?.toStringAsFixed(0) ?? '—'}%',
                ),
              ),
              Expanded(
                child: _ConditionValue(
                  label: 'temperature'.tr,
                  value:
                      '${demo.readings[2].value?.toStringAsFixed(1) ?? '—'}°',
                ),
              ),
            ],
          ),
        ),
      );
}

class _ConditionValue extends StatelessWidget {
  const _ConditionValue({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: AppTypography.sensorValue.copyWith(fontSize: 20),
          ),
        ],
      );
}

class _SafetyMessage extends StatelessWidget {
  const _SafetyMessage({required this.reason});
  final String reason;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4E5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            const SizedBox(width: 9),
            Expanded(child: Text(reason.tr)),
          ],
        ),
      );
}

class _ControlCard extends StatelessWidget {
  const _ControlCard({
    required this.icon,
    required this.title,
    required this.state,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.primaryLabel,
    required this.stopLabel,
    required this.blocked,
    required this.onPrimary,
    required this.onStop,
    this.command,
    this.remainingMinutes = 0,
  });

  final IconData icon;
  final String title;
  final ActuatorState state;
  final ZoneCommand? command;
  final String activeLabel;
  final String inactiveLabel;
  final String primaryLabel;
  final String stopLabel;
  final bool blocked;
  final VoidCallback onPrimary;
  final VoidCallback onStop;
  final int remainingMinutes;

  bool get active =>
      state == ActuatorState.running || state == ActuatorState.open;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          command?.progress == FarmerControlState.waiting
                              ? 'waiting_for_device'.tr
                              : active
                                  ? activeLabel
                                  : inactiveLabel,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (active && remainingMinutes > 0) ...[
                const SizedBox(height: 10),
                Text(
                  'minutes_remaining'.trParams({
                    'minutes': remainingMinutes.toString(),
                  }),
                  style: AppTypography.sensorValue.copyWith(fontSize: 20),
                ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: active
                    ? FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        onPressed: onStop,
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: Text(stopLabel),
                      )
                    : FilledButton(
                        onPressed: blocked ? null : onPrimary,
                        child: Text(primaryLabel),
                      ),
              ),
            ],
          ),
        ),
      );
}

class _CameraCard extends StatelessWidget {
  const _CameraCard({required this.zone, required this.demo});
  final FarmZone zone;
  final DemoPrototypeRepository demo;

  @override
  Widget build(BuildContext context) {
    final command = demo.latestCommands[ActuatorKind.camera];
    final waiting = command?.progress == FarmerControlState.waiting;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'camera'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: demo.controlsBlocked || waiting
                    ? null
                    : () => demo.runZoneCommand(
                          zone,
                          ActuatorKind.camera,
                          true,
                        ),
                icon: waiting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.camera),
                label: Text(
                  waiting ? 'taking_photo'.tr : 'take_photo'.tr,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
