import 'package:get/get.dart';
import 'package:lntb_app/core/controllers/farm_context_controller.dart';
import 'package:lntb_app/core/models/farm/harvest_record.dart';
import 'package:lntb_app/core/repositories/farm_repository.dart';

class HarvestController extends GetxController {
  final repository = Get.find<FarmRepository>();
  final records = <HarvestRecord>[].obs;
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
      final state = await repository.getHarvests(farmId);
      records.assignAll(state.data ?? []);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addHarvest(double quantity, String unit) async {
    final farmId = _farmId;
    if (farmId == null) return;
    await repository.createHarvest(farmId, quantity: quantity, unit: unit);
    await load();
  }
}
