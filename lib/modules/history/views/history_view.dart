import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/history/controllers/history_controller.dart';
import 'package:lntb_app/modules/history/widgets/control_timeline_view_timeline_item.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            toolbarHeight: 76,
            centerTitle: false,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 20,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'history'.tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'history_subtitle'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Obx(() {
                if (controller.isLoading.value && controller.records.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.records.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.history_outlined,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'no_history'.tr,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                    itemCount: controller.filteredRecords.isEmpty
                        ? 2
                        : controller.filteredRecords.length + 1,
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: controller.typeFilters
                                  .map(
                                    (type) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ChoiceChip(
                                        label: Text(type.tr),
                                        selected:
                                            controller.selectedType.value ==
                                                type,
                                        onSelected: (_) =>
                                            controller.selectType(type),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      }
                      final records = controller.filteredRecords;
                      if (records.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'no_history'.tr,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      final record = records[index - 1];
                      return TimelineItem(
                        record: record,
                        isLast: index == records.length,
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      );
}
