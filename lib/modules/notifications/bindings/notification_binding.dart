import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';
import '../controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotificationController>()) {
      Get.lazyPut<NotificationController>(
        () => NotificationController(apiClient: Get.find<ApiClient>()),
      );
    }
  }
}
