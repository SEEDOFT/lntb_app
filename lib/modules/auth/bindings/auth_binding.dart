import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/services/fcm_token_sync_service.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(
        apiClient: Get.find<ApiClient>(),
        fcmTokens: Get.isRegistered<FcmTokenSyncService>()
            ? Get.find<FcmTokenSyncService>()
            : null,
      ),
    );
  }
}
