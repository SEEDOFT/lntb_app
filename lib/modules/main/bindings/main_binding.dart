import 'package:get/get.dart';
import 'package:lntb_app/modules/main/controllers/main_controller.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/modules/notifications/controllers/notification_controller.dart';
import 'package:lntb_app/modules/profile/controllers/profile_controller.dart';
import 'package:lntb_app/modules/history/controllers/history_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
      fenix: true,
    );
    Get.lazyPut<DeviceController>(() => DeviceController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<HistoryController>(() => HistoryController(), fenix: true);
  }
}
