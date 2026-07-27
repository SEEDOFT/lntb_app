import 'package:get/get.dart';
import 'package:lntb_app/core/controllers/farm_context_controller.dart';
import 'package:lntb_app/core/models/farm/ripeness_result.dart';
import 'package:lntb_app/core/repositories/farm_repository.dart';

class RipenessController extends GetxController {
  final repository = Get.find<FarmRepository>();
  final items = <RipenessResult>[].obs;
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
      final state = await repository.getRipeness(farmId);
      items.assignAll(state.data ?? []);
    } finally {
      isLoading.value = false;
    }
  }
}
