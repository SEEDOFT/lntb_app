import 'package:get/get.dart';
import '../controllers/farm_tasks_controller.dart';

class FarmTasksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmTasksController>(() => FarmTasksController());
  }
}
