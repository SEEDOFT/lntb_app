import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/translations/control_type_labels.dart';
import 'package:lntb_app/core/utils/app_date_formatter.dart';
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: controller.typeFilters
                                      .map(
                                        (type) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
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
                              const SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: controller.dayFilters
                                      .map(
                                        (day) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: ChoiceChip(
                                            label: Text(day.tr),
                                            selected:
                                                controller.selectedDay.value ==
                                                    day,
                                            onSelected: (_) =>
                                                controller.selectDay(day),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
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
                        onTap: () => _showRecordDetail(context, record),
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

void _showRecordDetail(BuildContext context, ControlRecord record) {
  unawaited(
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecordDetailSheet(record: record),
    ),
  );
}

class _RecordDetailSheet extends StatelessWidget {
  const _RecordDetailSheet({required this.record});

  final ControlRecord record;

  @override
  Widget build(BuildContext context) {
    final statusColor = record.isCompleted
        ? AppColors.success
        : record.isPending
            ? Colors.orange
            : AppColors.error;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    record.isCompleted
                        ? Icons.check_circle
                        : record.isPending
                            ? Icons.schedule
                            : Icons.error,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.controlType.controlTypeLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'action_detail'.tr,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _DetailRow(
              icon: Icons.router_outlined,
              label: 'device'.tr,
              value: record.deviceName ?? '-',
            ),
            if (record.deviceTypeName != null)
              _DetailRow(
                icon: Icons.category_outlined,
                label: 'device_type'.tr,
                value: record.deviceTypeName!,
              ),
            _DetailRow(
              icon: Icons.flag_outlined,
              label: 'status'.tr,
              value: record.status.tr,
              valueColor: statusColor,
            ),
            _DetailRow(
              icon: Icons.access_time,
              label: 'requested_at'.tr,
              value: record.requestedAt.toAppFormattedString(),
            ),
            if (record.failureMessage != null)
              _DetailRow(
                icon: Icons.warning_amber_rounded,
                label: 'failure_reason'.tr,
                value: record.failureMessage!,
                valueColor: AppColors.error,
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text('close'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
}
