import 'package:get/get.dart';
import 'package:lntb_app/core/controllers/farm_context_controller.dart';
import 'package:lntb_app/core/models/farm/farm_task.dart';
import 'package:lntb_app/core/repositories/farm_repository.dart';

class FarmTasksController extends GetxController {
  final repository = Get.find<FarmRepository>();
  final tasks = <FarmTask>[].obs;
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
      final state = await repository.getTasks(farmId);
      tasks.assignAll(state.data ?? []);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTask(String title) async {
    final farmId = _farmId;
    if (farmId == null || title.isEmpty) return;
    await repository.createTask(farmId, title: title);
    await load();
  }

  Future<void> updateTask(int taskId, String action) async {
    final farmId = _farmId;
    if (farmId == null) return;
    await repository.updateTask(farmId, taskId, action);
    await load();
  }
}
