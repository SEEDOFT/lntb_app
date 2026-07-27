import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/farm/controllers/environment_controller.dart';

class EnvironmentView extends GetView<EnvironmentController> {
  const EnvironmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('environment'.tr)),
      body: Obx(() {
        if (controller.isLoading.value && controller.metrics.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.metrics.isEmpty) {
          return Center(child: Text('no_sensor_data'.tr));
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.05,
            ),
            itemCount: controller.metrics.length,
            itemBuilder: (_, index) {
              final metric = controller.metrics[index];
              final warning = metric.status == 'warning' ||
                  metric.status == 'critical';
              return Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _metricIcon(metric.code),
                        color: warning ? AppColors.error : AppColors.success,
                        size: 34,
                      ),
                      const SizedBox(height: 8),
                      Text(metric.code.tr),
                      Text(
                        '${metric.value.toStringAsFixed(1)} ${metric.unit}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        metric.status.tr,
                        style: TextStyle(
                          color: warning ? AppColors.error : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  IconData _metricIcon(String code) => switch (code) {
        'soil_moisture' => Icons.water_drop_outlined,
        'temperature' => Icons.thermostat,
        'humidity' => Icons.water,
        'light' => Icons.light_mode_outlined,
        _ => Icons.sensors,
      };
}
