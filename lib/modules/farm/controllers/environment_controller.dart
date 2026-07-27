import 'package:get/get.dart';
import 'package:lntb_app/core/controllers/farm_context_controller.dart';
import 'package:lntb_app/core/models/farm/farm_models.dart';
import 'package:lntb_app/core/repositories/farm_repository.dart';

class EnvironmentController extends GetxController {
  final repository = Get.find<FarmRepository>();
  final metrics = <SensorMetric>[].obs;
  final isLoading = false.obs;

  int? get _farmId => Get.find<FarmContextController>().selectedFarm.value?.id;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    final farmId = _farmId;
    if (farmId == null) return;
    isLoading.value = true;
    try {
      final state = await repository.getTelemetry(farmId);
      metrics.assignAll(state.data ?? []);
    } finally {
      isLoading.value = false;
    }
  }
}
