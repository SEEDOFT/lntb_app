import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/history/widgets/control_timeline_view_timeline_item.dart';

class ControlTimelineView extends StatefulWidget {
  const ControlTimelineView({super.key});

  @override
  State<ControlTimelineView> createState() => _ControlTimelineViewState();
}

class _ControlTimelineViewState extends State<ControlTimelineView> {
  final repository = Get.find<DeviceRepository>();
  final records = <ControlRecord>[].obs;
  final isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    unawaited(load());
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      records.assignAll(await repository.getControlHistory());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('control_log'.tr),
        surfaceTintColor: AppColors.background,
      ),
      body: Obx(() {
        if (isLoading.value && records.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (records.isEmpty) {
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
          onRefresh: load,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: records.length,
            itemBuilder: (_, index) {
              final record = records[index];
              final isLast = index == records.length - 1;
              return TimelineItem(record: record, isLast: isLast);
            },
          ),
        );
      }),
    );
  }
}
