import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/config/app_data_source.dart';
import 'package:lntb_app/core/models/prototype/prototype_models.dart';
import 'package:lntb_app/core/repositories/demo_prototype_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/theme/app_typography.dart';
import 'package:lntb_app/core/widgets/demo_data_banner.dart';
import 'package:lntb_app/modules/main/controllers/main_controller.dart';
import 'package:lntb_app/routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppDataSourceConfig.isDemo) {
      return Scaffold(
        appBar: AppBar(title: Text('home'.tr)),
        body: Center(child: Text('dashboard_api_pending'.tr)),
      );
    }
    final demo = Get.find<DemoPrototypeRepository>();
    final main = Get.find<MainController>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(demo.farmName),
            Text('today_farm_status'.tr,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'notifications'.tr,
          ),
        ],
      ),
      body: Obx(() {
        demo.scenario.value;
        demo.actuatorStates.length;
        final readings = demo.readings;
        final warning = demo.blockingReason;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 28),
              children: [
                const DemoDataBanner(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FarmStatus(
                        connected: demo.connected,
                        needsAttention: warning.isNotEmpty && demo.connected,
                      ),
                      if (warning.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _OneWarning(message: warning.tr),
                      ],
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _LargeReading(
                              label: 'soil_1'.tr,
                              value: readings[0].value,
                              unit: '%',
                              icon: Icons.water_drop_outlined,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _LargeReading(
                              label: 'soil_2'.tr,
                              value: readings[1].value,
                              unit: '%',
                              icon: Icons.water_drop_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: _SmallReading(
                                  label: 'temperature'.tr,
                                  value: readings[2].value,
                                  unit: '°C',
                                ),
                              ),
                              Expanded(
                                child: _SmallReading(
                                  label: 'humidity'.tr,
                                  value: readings[3].value,
                                  unit: '%',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _OperatingEquipment(demo: demo),
                      const SizedBox(height: 20),
                      Text(
                        'quick_access'.tr,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (context, constraints) => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Shortcut(
                              width: (constraints.maxWidth - 8) / 2,
                              icon: Icons.eco_outlined,
                              label: 'farm'.tr,
                              onTap: () => main.changePage(1),
                            ),
                            _Shortcut(
                              width: (constraints.maxWidth - 8) / 2,
                              icon: Icons.router_outlined,
                              label: 'devices'.tr,
                              onTap: () => main.changePage(2),
                            ),
                            _Shortcut(
                              width: (constraints.maxWidth - 8) / 2,
                              icon: Icons.history,
                              label: 'history'.tr,
                              onTap: () => main.changePage(3),
                            ),
                            _Shortcut(
                              width: (constraints.maxWidth - 8) / 2,
                              icon: Icons.notifications_outlined,
                              label: 'notifications'.tr,
                              onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _FarmStatus extends StatelessWidget {
  const _FarmStatus({
    required this.connected,
    required this.needsAttention,
  });
  final bool connected;
  final bool needsAttention;

  @override
  Widget build(BuildContext context) {
    final label = !connected
        ? 'farm_offline'.tr
        : needsAttention
            ? 'needs_attention'.tr
            : 'farm_connected'.tr;
    final color = !connected
        ? AppColors.error
        : needsAttention
            ? AppColors.warning
            : AppColors.success;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .11),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            !connected
                ? Icons.cloud_off_outlined
                : needsAttention
                    ? Icons.warning_amber_rounded
                    : Icons.cloud_done_outlined,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _OneWarning extends StatelessWidget {
  const _OneWarning({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Card(
        color: const Color(0xFFFFF4E5),
        child: ListTile(
          leading: const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
          ),
          title: Text(message),
        ),
      );
}

class _LargeReading extends StatelessWidget {
  const _LargeReading({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });
  final String label;
  final double? value;
  final String unit;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(label),
              Text(
                value == null ? '—' : '${value!.toStringAsFixed(0)}$unit',
                style: AppTypography.sensorValue.copyWith(fontSize: 29),
              ),
            ],
          ),
        ),
      );
}

class _SmallReading extends StatelessWidget {
  const _SmallReading({
    required this.label,
    required this.value,
    required this.unit,
  });
  final String label;
  final double? value;
  final String unit;
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(label, textAlign: TextAlign.center),
          Text(
            value == null ? '—' : '${value!.toStringAsFixed(1)}$unit',
            style: AppTypography.sensorValue.copyWith(fontSize: 21),
          ),
        ],
      );
}

class _OperatingEquipment extends StatelessWidget {
  const _OperatingEquipment({required this.demo});
  final DemoPrototypeRepository demo;
  @override
  Widget build(BuildContext context) {
    final active = <String>[
      if (demo.actuators[ActuatorKind.pump] == ActuatorState.running)
        'water'.tr,
      if (demo.actuators[ActuatorKind.fan] == ActuatorState.running) 'fan'.tr,
      if (demo.actuators[ActuatorKind.roof] == ActuatorState.open) 'roof'.tr,
    ];
    return Card(
      child: ListTile(
        leading: const Icon(Icons.power_settings_new, color: AppColors.primary),
        title: Text('equipment_running'.tr),
        subtitle: Text(
          active.isEmpty ? 'nothing_running'.tr : active.join(' • '),
        ),
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.width,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final double width;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: Icon(icon),
          label: Text(label),
        ),
      );
}
