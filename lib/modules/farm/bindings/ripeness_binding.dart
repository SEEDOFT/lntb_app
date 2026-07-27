import 'package:get/get.dart';
import '../controllers/ripeness_controller.dart';

class RipenessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RipenessController>(() => RipenessController());
  }
}
