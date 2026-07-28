import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/controllers/farm_context_controller.dart';
import 'package:lntb_app/core/models/farm/farm_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/farm/widgets/repository_state_view.dart';
import 'package:lntb_app/routes/app_routes.dart';
import 'package:lntb_app/modules/farm/widgets/farm_view_farm_summary.dart';
import 'package:lntb_app/modules/farm/widgets/farm_view_tool.dart';

class FarmView extends GetView<FarmContextController> {
  const FarmView({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'farm'.tr,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  'farm_overview_subtitle'.tr,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          body: Obx(
            () => RepositoryStateView<List<Farm>>(
              state: controller.farms.value,
              onRetry: controller.loadFarms,
              emptyMessageKey: 'no_configured_farms',
              dataBuilder: (farms) => RefreshIndicator(
                onRefresh: controller.loadFarms,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Farm>(
                                isExpanded: true,
                                value: controller.selectedFarm.value,
                                hint: Text('select_farm'.tr),
                                items: farms
                                    .map(
                                      (farm) => DropdownMenuItem(
                                        value: farm,
                                        child: Text(
                                          farm.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (farm) {
                                  if (farm != null) controller.selectFarm(farm);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Obx(
                      () => RepositoryStateView<FarmDashboard>(
                        state: controller.dashboard.value,
                        onRetry: controller.loadDashboard,
                        dataBuilder: (dashboard) =>
                            FarmSummary(dashboard: dashboard),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'farm_tools'.tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.22,
                      children: [
                        FarmTool(
                          'today_tasks',
                          Icons.task_alt,
                          Routes.FARM_TASKS,
                        ),
                        FarmTool('environment', Icons.eco, Routes.ENVIRONMENT),
                        FarmTool(
                          'irrigation',
                          Icons.water_drop,
                          Routes.IRRIGATION,
                        ),
                        FarmTool(
                          'usage_cost',
                          Icons.paid_outlined,
                          Routes.USAGE,
                        ),
                        FarmTool('ripeness', Icons.camera_alt, Routes.RIPENESS),
                        FarmTool('farm_log', Icons.menu_book, Routes.FARM_LOG),
                        FarmTool('harvest', Icons.agriculture, Routes.HARVEST),
                        FarmTool(
                          'ai_assistant',
                          Icons.smart_toy_outlined,
                          Routes.ASSISTANT,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
