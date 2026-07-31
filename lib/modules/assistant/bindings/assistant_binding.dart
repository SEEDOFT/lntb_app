import 'package:get/get.dart';
import 'package:lntb_app/modules/assistant/controllers/assistant_controller.dart';

class AssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssistantController>(() => AssistantController());
  }
}
