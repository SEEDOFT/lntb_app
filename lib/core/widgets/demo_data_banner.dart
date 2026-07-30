import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/config/app_data_source.dart';
import 'package:lntb_app/core/models/prototype/prototype_models.dart';
import 'package:lntb_app/core/repositories/demo_prototype_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class DemoDataBanner extends StatelessWidget {
  const DemoDataBanner({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode || !AppDataSourceConfig.isDemo) {
      return const SizedBox.shrink();
    }
    final demo = Get.find<DemoPrototypeRepository>();
    return Obx(
      () => Material(
        color: const Color(0xFFFFF4D8),
        child: InkWell(
          onTap: () => _chooseScenario(context, demo),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: compact ? 6 : 9,
            ),
            child: Row(
              mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
              children: [
                const Icon(
                  Icons.science_outlined,
                  size: 18,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    '${'demo_data'.tr} • ${demo.scenario.value.name.tr}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.expand_more, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _chooseScenario(
    BuildContext context,
    DemoPrototypeRepository demo,
  ) async {
    final selected = await showModalBottomSheet<DemoScenario>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                'demo_scenarios'.tr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...DemoScenario.values.map(
              (scenario) => RadioListTile<DemoScenario>(
                value: scenario,
                groupValue: demo.scenario.value,
                title: Text(scenario.name.tr),
                onChanged: (value) => Navigator.pop(context, value),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) demo.selectScenario(selected);
  }
}
