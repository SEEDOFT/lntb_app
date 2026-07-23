import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';

class HistoryController extends GetxController {
  final repository = Get.find<DeviceRepository>();
  final records = <ControlRecord>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      records.assignAll(await repository.getControlHistory());
    } finally {
      isLoading.value = false;
    }
  }
}
