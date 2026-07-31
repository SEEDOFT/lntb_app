import 'dart:async';

import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';

class HistoryController extends GetxController {
  final repository = Get.find<DeviceRepository>();
  final records = <ControlRecord>[].obs;
  final selectedType = 'all'.obs;
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

  List<ControlRecord> get filteredRecords => selectedType.value == 'all'
      ? records
      : records
          .where((record) => record.deviceTypeCode == selectedType.value)
          .toList();

  void selectType(String type) => selectedType.value = type;

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
