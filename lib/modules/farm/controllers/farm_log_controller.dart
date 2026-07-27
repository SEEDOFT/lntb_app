import 'package:get/get.dart';
import 'package:lntb_app/core/controllers/farm_context_controller.dart';
import 'package:lntb_app/core/models/farm/farm_log.dart';
import 'package:lntb_app/core/repositories/farm_repository.dart';

class FarmLogController extends GetxController {
  final repository = Get.find<FarmRepository>();
  final logs = <FarmLog>[].obs;
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
      final state = await repository.getLogs(farmId);
      logs.assignAll(state.data ?? []);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createLog(String title, String? notes) async {
    final farmId = _farmId;
    if (farmId == null || title.isEmpty) return;
    await repository.createLog(farmId, type: 'note', title: title, notes: notes);
    await load();
  }
}
