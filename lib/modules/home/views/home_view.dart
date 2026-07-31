import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/farm_dashboard_models.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/services/notification_display_service.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/home/controllers/home_controller.dart';
import 'package:lntb_app/modules/home/widgets/home_view_farm_health_card.dart';
import 'package:lntb_app/modules/home/widgets/home_view_metric_card.dart';
import 'package:lntb_app/modules/home/widgets/home_view_section_header.dart';
import 'package:lntb_app/modules/home/widgets/home_view_warning_card.dart';
import 'package:lntb_app/routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          toolbarHeight: 76,
          centerTitle: false,
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 20,
          title: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.dashboard.value?.farm.name ?? 'home'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.dashboard.value?.farm.cropName ??
                      'today_farm_status'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          actions: [
            Obx(
              () => (!Get.isRegistered<NotificationDisplayService>() ||
                      Get.find<NotificationDisplayService>().isEnabled.value)
                  ? Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: IconButton.filledTonal(
                        onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
                        icon: const Icon(Icons.notifications_none_rounded),
                        tooltip: 'notifications'.tr,
                        style: IconButton.styleFrom(
                          foregroundColor: AppColors.primaryDark,
                          backgroundColor: AppColors.primaryLight,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        body: Obx(() {
          final dashboard = controller.dashboard.value;
          if (controller.isLoading.value && dashboard == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.error.value != null && dashboard == null) {
            return _HomeMessageState(
              icon: Icons.cloud_off_rounded,
              message: 'dashboard_load_failed'.tr,
              actionLabel: 'try_again'.tr,
              onAction: controller.load,
            );
          }
          if (dashboard == null) {
            return _HomeMessageState(
              icon: Icons.add_home_work_outlined,
              message: 'no_configured_farms'.tr,
              actionLabel: 'activate_device'.tr,
              onAction: () => Get.toNamed(Routes.CLAIM),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.load,
            child: _DashboardContent(dashboard: dashboard),
          );
        }),
      );
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.dashboard});

  final FarmDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final soil = dashboard.metric('soil_moisture');
    final temperature = dashboard.metric('temperature');
    final humidity = dashboard.metric('humidity');
    final connected = dashboard.onlineDeviceCount > 0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: [
            HomeViewFarmHealthCard(
              connected: connected,
              needsAttention: dashboard.warnings.isNotEmpty,
              soilValue: soil?.value,
              temperatureValue: temperature?.value,
              humidityValue: humidity?.value,
            ),
            ...dashboard.warnings.map(
              (warning) => Padding(
                padding: const EdgeInsets.only(top: 12),
                child: HomeViewWarningCard(message: warning.message),
              ),
            ),
            const SizedBox(height: 24),
            _ProjectDetailPanel(dashboard: dashboard),
            const SizedBox(height: 24),
            HomeSectionHeader(title: 'statistics'.tr),
            const SizedBox(height: 12),
            _UsageSummary(usage: dashboard.usage),
            const SizedBox(height: 24),
            HomeSectionHeader(title: 'environment'.tr),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth - 12) / 2;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: dashboard.metrics
                      .map(
                        (metric) => HomeViewMetricCard(
                          width: width,
                          label: _metricLabel(metric.code),
                          value: metric.value,
                          unit: metric.unit,
                          icon: _metricIcon(metric.code),
                          color: _metricColor(metric.code),
                          decimals: metric.code == 'temperature' ? 1 : 0,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            _RecentActionCard(activity: dashboard.activity),
            const SizedBox(height: 24),
            _RecentReportCard(assistant: dashboard.assistant),
          ],
        ),
      ),
    );
  }

  String _metricLabel(String code) => switch (code) {
        'soil_moisture' => 'soil_moisture'.tr,
        'temperature' => 'temperature'.tr,
        'humidity' => 'humidity'.tr,
        'light' => 'light'.tr,
        _ => code.tr,
      };

  IconData _metricIcon(String code) => switch (code) {
        'soil_moisture' => Icons.water_drop_rounded,
        'temperature' => Icons.thermostat_rounded,
        'humidity' => Icons.air_rounded,
        'light' => Icons.wb_sunny_rounded,
        _ => Icons.sensors_rounded,
      };

  Color _metricColor(String code) => switch (code) {
        'soil_moisture' => const Color(0xFF2E90D1),
        'temperature' => const Color(0xFFE8793E),
        'humidity' => const Color(0xFF7A65C7),
        'light' => const Color(0xFFE0A21A),
        _ => AppColors.primary,
      };
}

class _ProjectDetailPanel extends StatelessWidget {
  const _ProjectDetailPanel({required this.dashboard});

  final FarmDashboard dashboard;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            _DetailRow(
              icon: Icons.place_outlined,
              title: 'environment_detail'.tr,
              value:
                  '${dashboard.farm.location ?? 'location'.tr} • ${dashboard.farm.status.tr} • ${dashboard.farm.cropName ?? 'crop_cycle'.tr}',
            ),
          ],
        ),
      );
}

class _UsageSummary extends StatelessWidget {
  const _UsageSummary({required this.usage});

  final DashboardUsage? usage;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final width = (constraints.maxWidth - 12) / 2;

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              HomeViewMetricCard(
                width: width,
                label: 'water_used'.tr,
                value: usage?.waterCubicMeters ?? 0,
                unit: 'm3',
                icon: Icons.water_drop_rounded,
                color: const Color(0xFF2E90D1),
                decimals: 2,
              ),
              HomeViewMetricCard(
                width: width,
                label: 'electricity_used'.tr,
                value: usage?.electricityKwh ?? 0,
                unit: 'kWh',
                icon: Icons.bolt_rounded,
                color: const Color(0xFFE0A21A),
                decimals: 2,
              ),
            ],
          );
        },
      );
}

class _RecentActionCard extends StatelessWidget {
  const _RecentActionCard({required this.activity});

  final List<ControlRecord> activity;

  @override
  Widget build(BuildContext context) {
    final latest = activity
        .where((record) => !record.controlType.startsWith('irrigation.'))
        .firstOrNull;

    return _DashboardInfoCard(
      icon: Icons.task_alt_outlined,
      title: 'recent_action'.tr,
      value: latest == null
          ? 'no_recent_action'.tr
          : '${latest.deviceName ?? 'device'.tr} • ${latest.controlType.tr} • ${latest.status.tr}',
    );
  }
}

class _RecentReportCard extends StatelessWidget {
  const _RecentReportCard({required this.assistant});

  final AssistantSummary? assistant;

  @override
  Widget build(BuildContext context) => _DashboardInfoCard(
        icon: Icons.description_outlined,
        title: 'recent_report'.tr,
        value: assistant?.answer ?? 'no_recent_report'.tr,
      );
}

class _DashboardInfoCard extends StatelessWidget {
  const _DashboardInfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: _DetailRow(icon: icon, title: title, value: value),
      );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _HomeMessageState extends StatelessWidget {
  const _HomeMessageState({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 54, color: AppColors.textSecondary),
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel)),
            ],
          ),
        ),
      );
}
