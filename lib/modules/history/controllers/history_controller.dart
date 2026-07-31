import 'dart:async';

import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';

class HistoryController extends GetxController {
  final repository = Get.find<DeviceRepository>();
  final records = <ControlRecord>[].obs;
  final selectedType = 'all'.obs;
  final selectedDay = 'all'.obs;
  final isLoading = false.obs;

  List<String> get typeFilters => [
        'all',
        ...records
            .map((record) => record.deviceTypeCode)
            .whereType<String>()
            .toSet()
            .toList()
          ..sort(),
      ];

  List<String> get dayFilters => ['all', 'today', 'last_7_days'];

  List<ControlRecord> get filteredRecords {
    final byType = selectedType.value == 'all'
        ? records
        : records
            .where((record) => record.deviceTypeCode == selectedType.value);

    final byDay = switch (selectedDay.value) {
      'today' => byType.where(
          (record) => record.requestedAt.toLocal().isSameDay(DateTime.now())),
      'last_7_days' => byType.where(
          (record) => record.requestedAt.toLocal().isAfter(
                DateTime.now().subtract(const Duration(days: 7)),
              ),
        ),
      _ => byType,
    };

    return byDay.toList();
  }

  void selectType(String type) => selectedType.value = type;

  void selectDay(String day) => selectedDay.value = day;

  @override
  void onInit() {
    super.onInit();
    unawaited(load());
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      records.assignAll(await repository.getControlHistory());
      if (!typeFilters.contains(selectedType.value)) {
        selectedType.value = 'all';
      }
    } finally {
      isLoading.value = false;
    }
  }
}

extension _LocalDate on DateTime {
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
