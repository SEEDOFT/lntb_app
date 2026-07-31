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
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
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
                                            label: Text(
                                              type == 'all'
                                                  ? type.tr
                                                  : 'device_type_$type'.tr,
                                            ),
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
                                  children: [
                                    ...controller.dayFilters
                                        .map(
                                          (day) => Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: ChoiceChip(
                                              label: Text(day.tr),
                                              selected:
                                                  controller.selectedDay.value ==
                                                      day,
                                              onSelected: (_) =>
                                                  controller.selectDay(day),
                                            ),
                                          ),
                                        ),
                                    Obx(
                                      () => controller.selectedDate.value !=
                                              null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: InputChip(
                                                label: Text(
                                                  controller.selectedDate.value!
                                                      .toDayHeaderString(),
                                                ),
                                                onDeleted: () =>
                                                    controller.selectDate(null),
                                                deleteIcon: const Icon(
                                                  Icons.close_rounded,
                                                  size: 16,
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8),
                                      child: ActionChip(
                                        avatar: const Icon(
                                          Icons.calendar_today_rounded,
                                          size: 16,
                                        ),
                                        label: Text('pick_date'.tr),
                                        onPressed: () async {
                                          final now = DateTime.now();
                                          final picked = await showDatePicker(
                                            context: context,
                                            initialDate:
                                                controller.selectedDate.value ??
                                                    now,
                                            firstDate: DateTime(2020),
                                            lastDate: now,
                                            helpText: 'pick_date'.tr,
                                          );
                                          if (picked != null) {
                                            controller.selectDate(picked);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ..._buildDayGroups(context, controller.timelineEntries),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      );

  List<Widget> _buildDayGroups(
    BuildContext context,
    List<HistoryTimelineEntry> entries,
  ) {
    if (entries.isEmpty) {
      return [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              '',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ];
    }

    final groups = <DateTime, List<HistoryTimelineEntry>>{};
    for (final entry in entries) {
      final day = DateTime(
        entry.record.requestedAt.toLocal().year,
        entry.record.requestedAt.toLocal().month,
        entry.record.requestedAt.toLocal().day,
      );
      groups.putIfAbsent(day, () => []).add(entry);
    }

    final days = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final day in days)
        SliverToBoxAdapter(child: _DayHeader(day: day, entries: groups[day]!)),
      for (final day in days)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                final entry = groups[day]![index];
                final isLast = index == groups[day]!.length - 1;
                return TimelineItem(
                  entry: entry,
                  isLast: isLast,
                  onTap: () => _showRecordDetail(context, entry),
                );
              },
              childCount: groups[day]!.length,
            ),
          ),
        ),
    ];
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.day, required this.entries});

  final DateTime day;
  final List<HistoryTimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    final label = _dayLabel();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '${entries.length} ${'actions'.tr}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            day.toDayHeaderSubtitle(),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _dayLabel() {
    final now = DateTime.now();
    if (_isSameDay(day, now)) return 'today'.tr;
    if (_isSameDay(day, now.subtract(const Duration(days: 1)))) {
      return 'yesterday'.tr;
    }
    return day.toDayHeaderString();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

void _showRecordDetail(BuildContext context, HistoryTimelineEntry entry) {
  unawaited(
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecordDetailSheet(entry: entry),
    ),
  );
}

class _RecordDetailSheet extends StatelessWidget {
  const _RecordDetailSheet({required this.entry});

  final HistoryTimelineEntry entry;
  ControlRecord get record => entry.record;

  @override
  Widget build(BuildContext context) {
    final statusColor = record.isCompleted
        ? AppColors.success
        : record.isPending
            ? Colors.orange
            : AppColors.error;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
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
              value: entry.deviceDisplayName,
            ),
            if (record.deviceTypeName != null)
              _DetailRow(
                icon: Icons.category_outlined,
                label: 'device_type'.tr,
                value: 'device_type_${record.deviceTypeCode}'.tr,
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
            if (entry.runtime != null)
              _DetailRow(
                icon: Icons.timelapse_rounded,
                label: 'runtime'.tr,
                value: formatRuntime(entry.runtime),
              ),
            if (entry.energyKwh != null)
              _DetailRow(
                icon: Icons.bolt_rounded,
                label: 'energy_used'.tr,
                value: formatEnergyKwh(entry.energyKwh),
                valueColor: AppColors.primary,
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
