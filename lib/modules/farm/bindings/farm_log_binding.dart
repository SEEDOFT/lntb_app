import 'package:get/get.dart';
import '../controllers/farm_log_controller.dart';

class FarmLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FarmLogController>(() => FarmLogController());
  }
}
