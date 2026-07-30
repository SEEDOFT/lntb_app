import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/prototype/prototype_models.dart';
import 'package:lntb_app/core/config/app_data_source.dart';
import 'package:lntb_app/core/repositories/demo_prototype_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/theme/app_typography.dart';
import 'package:lntb_app/core/widgets/demo_data_banner.dart';

class RipenessView extends StatelessWidget {
  const RipenessView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppDataSourceConfig.isDemo) {
      return Scaffold(
        appBar: AppBar(title: Text('ripeness'.tr)),
        body: Center(child: Text('farm_api_pending'.tr)),
      );
    }
    final demo = Get.find<DemoPrototypeRepository>();
    return Scaffold(
      appBar: AppBar(title: Text('ripeness'.tr)),
      body: Obx(() {
        demo.scenario.value;
        demo.results.length;
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
                    color: AppColors.primaryLight,
                    child: ListTile(
                      leading: const Icon(Icons.dataset_outlined,
                          color: AppColors.primary),
                      title: Text('field_images_required'.tr),
                      subtitle: Text('ripeness_training_empty_help'.tr),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('capture_gallery'.tr,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  ...demo.ripeness
                      .map((item) => _RipenessCard(item: item, demo: demo)),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _RipenessCard extends StatelessWidget {
  const _RipenessCard({required this.item, required this.demo});
  final PrototypeRipeness item;
  final DemoPrototypeRepository demo;

  @override
  Widget build(BuildContext context) {
    final lowConfidence = item.confidence < .7;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 190,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE2F2D9), Color(0xFFFFE0BE)],
              ),
            ),
            child: const Icon(Icons.image_outlined,
                size: 64, color: AppColors.primary),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        (item.farmerCorrection ?? item.stage).tr,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      '${(item.confidence * 100).round()}%',
                      style: AppTypography.sensorValue.copyWith(fontSize: 22),
                    ),
                  ],
                ),
                Text('${item.cameraName} • ${item.modelVersion}'),
                Text(_time(item.capturedAt),
                    style: Theme.of(context).textTheme.bodySmall),
                if (lowConfidence) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4E5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.help_outline,
                            color: AppColors.warning),
                        const SizedBox(width: 8),
                        Expanded(child: Text('low_confidence_review'.tr)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _correct(context),
                  icon: const Icon(Icons.fact_check_outlined),
                  label: Text(item.farmerCorrection == null
                      ? 'confirm_or_correct'.tr
                      : 'farmer_confirmed'.tr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _correct(BuildContext context) async {
    final value = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text('choose_ripeness'.tr)),
            for (final stage in const [
              'unripe',
              'semi_ripe',
              'ready_to_harvest',
              'uncertain',
            ])
              ListTile(
                title: Text(stage.tr),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pop(context, stage),
              ),
          ],
        ),
      ),
    );
    if (value != null) demo.correctRipeness(item.id, value);
  }

  String _time(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')} '
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')} UTC';
}
