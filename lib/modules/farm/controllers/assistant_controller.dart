import 'package:get/get.dart';
import 'package:lntb_app/core/controllers/farm_context_controller.dart';
import 'package:lntb_app/core/repositories/farm_repository.dart';

class AssistantController extends GetxController {
  final repository = Get.find<FarmRepository>();
  final answer = Rx<String?>(null);
  final isLoading = false.obs;

  int? get _farmId => Get.find<FarmContextController>().selectedFarm.value?.id;

  Future<void> ask(String question) async {
    final farmId = _farmId;
    if (farmId == null || question.trim().isEmpty) return;
    isLoading.value = true;
    try {
      final state = await repository.askAssistant(farmId, question.trim());
      answer.value = state.data ?? state.message ?? 'assistant_unavailable'.tr;
    } finally {
      isLoading.value = false;
    }
  }
}
