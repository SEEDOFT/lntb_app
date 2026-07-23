import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/controllers/farm_context_controller.dart';
import 'package:lntb_app/core/models/farm/farm_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/farm/widgets/repository_state_view.dart';
import 'package:lntb_app/routes/app_routes.dart';

class FarmView extends GetView<FarmContextController> {
  const FarmView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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
                    padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.eco_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<Farm>(
                            key: ValueKey(controller.selectedFarm.value?.id),
                            initialValue: controller.selectedFarm.value,
                            decoration: InputDecoration(
                              labelText: 'selected_farm'.tr,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                            ),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Obx(
                    () => RepositoryStateView<FarmDashboard>(
                      state: controller.dashboard.value,
                      onRetry: controller.loadDashboard,
                      dataBuilder: (dashboard) =>
                          _FarmSummary(dashboard: dashboard),
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
                      _Tool('today_tasks', Icons.task_alt, Routes.FARM_TASKS),
                      _Tool('environment', Icons.eco, Routes.ENVIRONMENT),
                      _Tool('irrigation', Icons.water_drop, Routes.IRRIGATION),
                      _Tool('usage_cost', Icons.paid_outlined, Routes.USAGE),
                      _Tool('ripeness', Icons.camera_alt, Routes.RIPENESS),
                      _Tool('farm_log', Icons.menu_book, Routes.FARM_LOG),
                      _Tool('harvest', Icons.agriculture, Routes.HARVEST),
                      _Tool(
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
      );
}

class _FarmSummary extends StatelessWidget {
  const _FarmSummary({required this.dashboard});
  final FarmDashboard dashboard;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDark, AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .2),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dashboard.farm.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: Color(0xFF9AF2B5),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dashboard.farm.status.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              dashboard.farm.currentCrop ?? 'no_active_crop'.tr,
              style: const TextStyle(color: Color(0xFFD8FFE5)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _Counter(
                  value: '${dashboard.openTaskCount}',
                  label: 'open_tasks'.tr,
                ),
                _Counter(
                  value: '${dashboard.onlineDeviceCount}',
                  label: 'online_devices'.tr,
                ),
                _Counter(
                  value: '${dashboard.metrics.length}',
                  label: 'sensor_readings'.tr,
                ),
              ],
            ),
          ],
        ),
      );
}

class _Counter extends StatelessWidget {
  const _Counter({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFD8FFE5), fontSize: 11),
            ),
          ],
        ),
      );
}

class _Tool extends StatelessWidget {
  const _Tool(this.labelKey, this.icon, this.route);
  final String labelKey;
  final IconData icon;
  final String route;
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.toNamed(route),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 26),
                ),
                const SizedBox(height: 8),
                Text(
                  labelKey.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      );
}
