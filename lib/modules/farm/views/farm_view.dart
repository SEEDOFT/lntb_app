import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/config/app_data_source.dart';
import 'package:lntb_app/core/models/prototype/prototype_models.dart';
import 'package:lntb_app/core/repositories/demo_prototype_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/theme/app_typography.dart';
import 'package:lntb_app/core/widgets/demo_data_banner.dart';
import 'package:lntb_app/modules/farm/views/multi_zone_control_view.dart';
import 'package:lntb_app/modules/farm/views/zone_control_view.dart';

class FarmView extends StatelessWidget {
  const FarmView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppDataSourceConfig.isDemo) {
      return Scaffold(
        appBar: AppBar(title: Text('farm'.tr)),
        body: Center(child: Text('farm_api_pending'.tr)),
      );
    }
    final demo = Get.find<DemoPrototypeRepository>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('farm'.tr),
            Text(demo.farmName, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      body: Obx(() {
        demo.scenario.value;
        demo.actuatorStates.length;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 28),
              children: [
                const DemoDataBanner(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    'choose_farm_area'.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ...demo.zones.map(
                  (zone) => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                    child: _ZoneCard(zone: zone, demo: demo),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  child: OutlinedButton.icon(
                    onPressed: () => Get.to(
                      () => MultiZoneControlView(demo: demo),
                    ),
                    icon: const Icon(Icons.library_add_check_outlined),
                    label: Text('control_several_zones'.tr),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ZoneCard extends StatelessWidget {
  const _ZoneCard({required this.zone, required this.demo});

  final FarmZone zone;
  final DemoPrototypeRepository demo;

  @override
  Widget build(BuildContext context) {
    final moisture1 = demo.readings[0];
    final moisture2 = demo.readings[1];
    final pump = demo.actuators[ActuatorKind.pump]!;
    final warning = demo.blockingReason;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    zone.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _PlainStatus(
                  icon: demo.connected ? Icons.wifi : Icons.wifi_off,
                  label: demo.connected ? 'online'.tr : 'offline'.tr,
                  color: demo.connected ? AppColors.success : AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _MoistureValue(
                    label: 'soil_1'.tr,
                    reading: moisture1,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MoistureValue(
                    label: 'soil_2'.tr,
                    reading: moisture2,
                  ),
                ),
              ],
            ),
            const Divider(height: 26),
            Row(
              children: [
                const Icon(
                  Icons.water_drop_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text('water'.tr)),
                Text(_pumpLabel(pump)),
              ],
            ),
            if (warning.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(warning.tr)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Get.to(
                  () => ZoneControlView(zone: zone, demo: demo),
                ),
                icon: const Icon(Icons.tune),
                label: Text('open_controls'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _pumpLabel(ActuatorState state) => switch (state) {
        ActuatorState.running => 'watering_now'.tr,
        ActuatorState.pending => 'waiting'.tr,
        ActuatorState.queued => 'waiting'.tr,
        _ => 'currently_stopped'.tr,
      };
}

class _MoistureValue extends StatelessWidget {
  const _MoistureValue({required this.label, required this.reading});

  final String label;
  final PrototypeReading reading;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(
              reading.value == null
                  ? '—'
                  : '${reading.value!.toStringAsFixed(0)}%',
              style: AppTypography.sensorValue.copyWith(fontSize: 26),
            ),
          ],
        ),
      );
}

class _PlainStatus extends StatelessWidget {
  const _PlainStatus({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: color)),
        ],
      );
}
