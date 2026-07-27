import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/history/controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('history'.tr)),
        body: Obx(() {
          if (controller.isLoading.value && controller.records.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.records.isEmpty) {
            return Center(child: Text('no_history'.tr));
          }
          return RefreshIndicator(
            onRefresh: controller.load,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.records.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                final item = controller.records[index];
                final color = item.status == 'completed'
                    ? AppColors.success
                    : item.status == 'pending'
                        ? Colors.orange
                        : AppColors.error;
                return ListTile(
                  leading: Icon(
                    item.status == 'completed'
                        ? Icons.check_circle
                        : item.status == 'pending'
                            ? Icons.schedule
                            : Icons.error,
                    color: color,
                  ),
                  title: Text(item.controlType.tr),
                  subtitle: Text(
                    '${item.deviceName ?? 'device'.tr}\n${item.requestedAt.toLocal().toString().substring(0, 16)}',
                  ),
                  isThreeLine: true,
                  trailing:
                      Text(item.status.tr, style: TextStyle(color: color)),
                );
              },
            ),
          );
        }),
      );
}
