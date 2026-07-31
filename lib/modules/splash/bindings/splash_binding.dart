import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/services/fcm_token_sync_service.dart';
import 'package:lntb_app/modules/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(
      SplashController(
        apiClient: Get.find<ApiClient>(),
        fcmTokens: Get.isRegistered<FcmTokenSyncService>()
            ? Get.find<FcmTokenSyncService>()
            : null,
      ),
    );
  }
}
