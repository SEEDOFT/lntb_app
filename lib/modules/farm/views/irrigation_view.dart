import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/prototype/prototype_models.dart';
import 'package:lntb_app/core/config/app_data_source.dart';
import 'package:lntb_app/core/repositories/demo_prototype_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/widgets/demo_data_banner.dart';

class IrrigationView extends StatelessWidget {
  const IrrigationView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppDataSourceConfig.isDemo) {
      return Scaffold(
        appBar: AppBar(title: Text('irrigation_control'.tr)),
        body: Center(child: Text('farm_api_pending'.tr)),
      );
    }
    final demo = Get.find<DemoPrototypeRepository>();
    return Scaffold(
      appBar: AppBar(title: Text('irrigation_control'.tr)),
      body: Obx(() {
        demo.scenario.value;
        demo.actuatorStates.length;
        return ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            const DemoDataBanner(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: const Color(0xFFFFF4E5),
                    child: ListTile(
                      leading: const Icon(Icons.shield_outlined,
                          color: AppColors.warning),
                      title: Text('automatic_irrigation'.tr),
                      subtitle: Text('automation_safety_gate'.tr),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SafetySummary(demo: demo),
                  const SizedBox(height: 18),
                  Text('manual_controls'.tr,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  _ActuatorCard(
                    icon: Icons.water_drop,
                    title: 'pump'.tr,
                    kind: ActuatorKind.pump,
                    positive: 'start'.tr,
                    negative: 'stop'.tr,
                    demo: demo,
                  ),
                  _ActuatorCard(
                    icon: Icons.air,
                    title: 'fan'.tr,
                    kind: ActuatorKind.fan,
                    positive: 'start'.tr,
                    negative: 'stop'.tr,
                    demo: demo,
                  ),
                  _ActuatorCard(
                    icon: Icons.roofing,
                    title: 'roof'.tr,
                    kind: ActuatorKind.roof,
                    positive: 'open'.tr,
                    negative: 'close'.tr,
                    demo: demo,
                  ),
                  _ActuatorCard(
                    icon: Icons.camera_alt_outlined,
                    title: 'camera'.tr,
                    kind: ActuatorKind.camera,
                    positive: 'capture'.tr,
                    negative: 'reset'.tr,
                    demo: demo,
                  ),
                  const SizedBox(height: 10),
                  Text('latest_irrigation_event'.tr,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.history, color: AppColors.primary),
                      title: const Text('Controller A1 • Greenhouse A'),
                      subtitle: Text(
                        '12 ${'minutes'.tr} • 0.18 m³ • 0.42 kWh\n'
                        '${'requested_by'.tr}: Sokha (Owner)',
                      ),
                      isThreeLine: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SafetySummary extends StatelessWidget {
  const _SafetySummary({required this.demo});
  final DemoPrototypeRepository demo;
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _row(
                  'connection'.tr, demo.connected ? 'online'.tr : 'offline'.tr),
              _row('maximum_runtime'.tr, '20 ${'minutes'.tr}'),
              _row('command_state'.tr,
                  demo.actuators[ActuatorKind.pump]!.name.tr),
              _row('start_permission'.tr,
                  demo.controlsBlocked ? 'blocked'.tr : 'available'.tr),
            ],
          ),
        ),
      );
  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [Expanded(child: Text(label)), Text(value)],
        ),
      );
}

class _ActuatorCard extends StatelessWidget {
  const _ActuatorCard({
    required this.icon,
    required this.title,
    required this.kind,
    required this.positive,
    required this.negative,
    required this.demo,
  });
  final IconData icon;
  final String title;
  final ActuatorKind kind;
  final String positive;
  final String negative;
  final DemoPrototypeRepository demo;

  @override
  Widget build(BuildContext context) {
    final state = demo.actuators[kind]!;
    final active =
        state == ActuatorState.running || state == ActuatorState.open;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(title,
                        style: Theme.of(context).textTheme.titleMedium)),
                Chip(label: Text(state.name.tr)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: active || demo.controlsBlocked
                        ? null
                        : () => _activate(context),
                    child: Text(positive),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => demo.run(kind, false),
                    child: Text(negative),
                  ),
                ),
              ],
            ),
            if (demo.controlsBlocked)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.block, size: 17, color: AppColors.error),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'unsafe_start_blocked'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _activate(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('confirm_command'.tr),
        content: Text('confirm_start_action'
            .trParams({'action': positive, 'device': title})),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('cancel'.tr)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('confirm'.tr)),
        ],
      ),
    );
    if (confirmed == true) await demo.run(kind, true);
  }
}
