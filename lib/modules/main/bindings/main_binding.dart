import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/repositories/account_repository.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import 'package:lntb_app/core/repositories/farm_dashboard_repository.dart';
import 'package:lntb_app/core/services/fcm_token_sync_service.dart';
import 'package:lntb_app/core/services/notification_display_service.dart';
import 'package:lntb_app/modules/main/controllers/main_controller.dart';
import 'package:lntb_app/modules/devices/controllers/device_controller.dart';
import 'package:lntb_app/modules/notifications/controllers/notification_controller.dart';
import 'package:lntb_app/modules/profile/controllers/profile_controller.dart';
import 'package:lntb_app/modules/history/controllers/history_controller.dart';
import 'package:lntb_app/modules/home/controllers/home_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(
      () => HomeController(
        repository: Get.find<FarmDashboardRepository>(),
        notificationDisplay: Get.find<NotificationDisplayService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<NotificationController>(
      () => NotificationController(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<DeviceController>(
      () => DeviceController(repository: Get.find<DeviceRepository>()),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        apiClient: Get.find<ApiClient>(),
        fcmTokens: Get.isRegistered<FcmTokenSyncService>()
            ? Get.find<FcmTokenSyncService>()
            : null,
        repository: Get.find<AccountRepository>(),
        notificationDisplay: Get.find<NotificationDisplayService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<HistoryController>(
      () => HistoryController(repository: Get.find<DeviceRepository>()),
      fenix: true,
    );
  }
}
