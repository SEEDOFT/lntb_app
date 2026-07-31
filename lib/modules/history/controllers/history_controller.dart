import 'dart:async';

import 'package:get/get.dart';
import 'package:lntb_app/core/constants/device_power_constants.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';

class HistoryController extends GetxController {
  HistoryController({required this.repository});

  final DeviceRepository repository;
  final records = <ControlRecord>[].obs;
  final selectedType = 'all'.obs;
  final selectedDay = 'all'.obs;
  final selectedDate = Rxn<DateTime>();
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

    final byDate = switch (selectedDay.value) {
      'today' => byType.where(
          (record) => record.requestedAt.toLocal().isSameDay(DateTime.now())),
      'last_7_days' => byType.where(
          (record) => record.requestedAt.toLocal().isAfter(
                DateTime.now().subtract(const Duration(days: 7)),
              ),
        ),
      'date' => byType.where((record) {
          final day = selectedDate.value;
          return day != null &&
              record.requestedAt.toLocal().isSameDay(day);
        }),
      _ => byType,
    };

    return byDate.toList();
  }

  /// Records enriched with paired runtime and estimated energy use.
  List<HistoryTimelineEntry> get timelineEntries {
    final runtimes = _pairRuntimes(filteredRecords);
    return filteredRecords.map((record) {
      final runtime = runtimes[record.id];
      final watts = wattsForType(
        record.deviceTypeCode,
        record.controlType,
      );
      final energyKwh = runtime == null || runtime.inSeconds <= 0
          ? null
          : watts * (runtime.inSeconds / 3600) / 1000;
      return HistoryTimelineEntry(
        record: record,
        runtime: runtime,
        energyKwh: energyKwh,
      );
    }).toList();
  }

  /// Pairs start→stop commands per device and returns the active runtime for
  /// each record that participates in a pair.
  Map<int, Duration> _pairRuntimes(List<ControlRecord> source) {
    final byDevice = <int, List<ControlRecord>>{};
    for (final record in source) {
      byDevice.putIfAbsent(record.deviceId, () => []).add(record);
    }

    final runtimes = <int, Duration>{};
    for (final deviceRecords in byDevice.values) {
      final sorted = [...deviceRecords]..sort(
          (a, b) => a.requestedAt.compareTo(b.requestedAt),
        );
      final pending = <String, ControlRecord>{};
      for (final record in sorted) {
        final base = record.controlType.split('.').first;
        if (isStart(record.controlType)) {
          pending[base] = record;
        } else if (isStop(record.controlType)) {
          final start = pending.remove(base);
          if (start != null) {
            final runtime = record.requestedAt.difference(start.requestedAt);
            runtimes[start.id] = runtime;
            runtimes[record.id] = runtime;
          }
        }
      }
    }
    return runtimes;
  }

  bool isStart(String controlType) =>
      controlType.endsWith('.start') || controlType.endsWith('.open');

  bool isStop(String controlType) =>
      controlType.endsWith('.stop') || controlType.endsWith('.close');

  void selectType(String type) => selectedType.value = type;

  void selectDay(String day) => selectedDay.value = day;

  void selectDate(DateTime? date) {
    selectedDate.value = date;
    selectedDay.value = date == null ? 'all' : 'date';
  }

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
