import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/prototype/prototype_models.dart';
import 'package:lntb_app/core/config/app_data_source.dart';
import 'package:lntb_app/core/repositories/demo_prototype_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/theme/app_typography.dart';
import 'package:lntb_app/core/widgets/demo_data_banner.dart';

class UsageView extends StatefulWidget {
  const UsageView({super.key});
  @override
  State<UsageView> createState() => _UsageViewState();
}

class _UsageViewState extends State<UsageView> {
  String period = 'day';

  @override
  Widget build(BuildContext context) {
    if (!AppDataSourceConfig.isDemo) {
      return Scaffold(
        appBar: AppBar(title: Text('usage_cost'.tr)),
        body: Center(child: Text('farm_api_pending'.tr)),
      );
    }
    final demo = Get.find<DemoPrototypeRepository>();
    return Scaffold(
      appBar: AppBar(title: Text('usage_cost'.tr)),
      body: Obx(() {
        demo.scenario.value;
        final usage = demo.usageFor(period);
        return ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            const DemoDataBanner(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'day', label: Text('daily'.tr)),
                      ButtonSegment(value: 'week', label: Text('weekly'.tr)),
                      ButtonSegment(value: 'month', label: Text('monthly'.tr)),
                    ],
                    selected: {period},
                    onSelectionChanged: (value) =>
                        setState(() => period = value.first),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _UsageCard(
                          icon: Icons.water_drop_outlined,
                          label: 'water_volume'.tr,
                          value: usage.waterM3 == null
                              ? '—'
                              : '${usage.waterM3!.toStringAsFixed(2)} m³',
                          quality: usage.quality,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _UsageCard(
                          icon: Icons.bolt_outlined,
                          label: 'electricity'.tr,
                          value: usage.energyKwh == null
                              ? '—'
                              : '${usage.energyKwh!.toStringAsFixed(2)} kWh',
                          quality: usage.quality,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _UsageCard(
                    icon: Icons.payments_outlined,
                    label: 'estimated_operating_cost'.tr,
                    value: usage.estimatedCost == null
                        ? 'unavailable'.tr
                        : '\$${usage.estimatedCost!.toStringAsFixed(2)}',
                    quality: usage.estimatedCost == null
                        ? DataQuality.unavailable
                        : DataQuality.estimated,
                  ),
                  const SizedBox(height: 14),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _row('water_tariff'.tr, '\$${usage.waterTariff}/m³'),
                          _row('electricity_tariff'.tr,
                              '\$${usage.energyTariff}/kWh'),
                          _row('irrigation_count'.tr,
                              '${usage.irrigationCount}'),
                          _row('total_duration'.tr,
                              '${usage.irrigationMinutes} ${'minutes'.tr}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'usage_measurement_note'.tr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [Expanded(child: Text(label)), Text(value)]),
      );
}

class _UsageCard extends StatelessWidget {
  const _UsageCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.quality,
  });
  final IconData icon;
  final String label;
  final String value;
  final DataQuality quality;
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 10),
              Text(label),
              Text(value,
                  style: AppTypography.sensorValue.copyWith(fontSize: 24)),
              Text(quality.name.tr,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      );
}
