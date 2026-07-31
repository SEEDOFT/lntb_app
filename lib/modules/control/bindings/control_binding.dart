import 'package:get/get.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import '../controllers/control_controller.dart';

class ControlBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControlController>(
      () => ControlController(repository: Get.find<DeviceRepository>()),
    );
  }
}
