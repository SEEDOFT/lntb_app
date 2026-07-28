import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/theme/app_typography.dart';
import 'package:lntb_app/modules/farm/controllers/usage_controller.dart';

class UsageView extends GetView<UsageController> {
  const UsageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('usage_cost'.tr)),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.items.isEmpty) {
          return Center(child: Text('no_usage_data'.tr));
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: controller.items
                .map(
                  (item) => Card(
                    elevation: 0,
                    child: ListTile(
                      leading: const Icon(
                        Icons.paid_outlined,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        '\$${item.totalCostUsd.toStringAsFixed(2)}',
                        style: AppTypography.sensorValue.copyWith(fontSize: 28),
                      ),
                      subtitle: Text(
                        '${item.waterCubicMeters.toStringAsFixed(2)} m³ • '
                        '${item.electricityKwh.toStringAsFixed(2)} kWh',
                        style: AppTypography.sensorValue.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      }),
    );
  }
}
