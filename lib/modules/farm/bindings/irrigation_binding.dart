import 'package:get/get.dart';
import '../controllers/irrigation_controller.dart';

class IrrigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IrrigationController>(() => IrrigationController());
  }
}
