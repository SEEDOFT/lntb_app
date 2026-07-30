import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/prototype/prototype_models.dart';
import 'package:lntb_app/core/config/app_data_source.dart';
import 'package:lntb_app/core/repositories/demo_prototype_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/theme/app_typography.dart';
import 'package:lntb_app/core/widgets/demo_data_banner.dart';

class EnvironmentView extends StatelessWidget {
  const EnvironmentView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppDataSourceConfig.isDemo) {
      return Scaffold(
        appBar: AppBar(title: Text('environment'.tr)),
        body: Center(child: Text('farm_api_pending'.tr)),
      );
    }
    final demo = Get.find<DemoPrototypeRepository>();
    return Scaffold(
      appBar: AppBar(title: Text('environment'.tr)),
      body: Obx(() {
        demo.scenario.value;
        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const DemoDataBanner(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'latest_environment_readings'.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${'latest_reading'.tr}: ${_timestamp(demo.lastSync)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  ...demo.readings.map((reading) => _MetricCard(reading)),
                  const SizedBox(height: 8),
                  Card(
                    color: const Color(0xFFFFF8E8),
                    child: ListTile(
                      leading: const Icon(Icons.info_outline,
                          color: AppColors.warning),
                      title: Text('prototype_threshold_title'.tr),
                      subtitle: Text('prototype_threshold'.tr),
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

  static String _timestamp(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')} '
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')} UTC';
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(this.reading);
  final PrototypeReading reading;

  @override
  Widget build(BuildContext context) {
    final good = reading.quality == DataQuality.measured && reading.calibrated;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: good ? AppColors.primaryLight : const Color(0xFFFFF1E1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_icon(reading.code),
                  color: good ? AppColors.primary : AppColors.warning),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reading.code.tr),
                  Text(
                    reading.value == null
                        ? 'unavailable'.tr
                        : '${reading.value!.toStringAsFixed(reading.value! > 100 ? 0 : 1)} ${reading.unit}',
                    style: AppTypography.sensorValue.copyWith(fontSize: 25),
                  ),
                  Text(
                    '${reading.quality.name.tr} • '
                    '${reading.calibrated ? 'calibrated'.tr : 'calibration_required'.tr}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(width: 76, height: 42, child: _MiniTrend(reading.trend)),
          ],
        ),
      ),
    );
  }

  IconData _icon(String code) => switch (code) {
        'soil_moisture_1' || 'soil_moisture_2' => Icons.water_drop_outlined,
        'temperature' => Icons.thermostat,
        'humidity' => Icons.water,
        'light' => Icons.light_mode_outlined,
        _ => Icons.sensors,
      };
}

class _MiniTrend extends StatelessWidget {
  const _MiniTrend(this.values);
  final List<double> values;
  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();
    final max = values.reduce((a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: values
          .map(
            (value) => Expanded(
              child: Container(
                height: 8 + 30 * (max == 0 ? 0 : value / max),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .55),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
