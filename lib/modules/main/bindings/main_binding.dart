import 'package:get/get.dart';
import 'package:lntb_app/modules/main/controllers/main_controller.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/modules/profile/controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<DeviceController>(() => DeviceController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
