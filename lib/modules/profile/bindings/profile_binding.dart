import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/repositories/account_repository.dart';
import 'package:lntb_app/core/services/fcm_token_sync_service.dart';
import 'package:lntb_app/core/services/notification_display_service.dart';
import 'package:lntb_app/modules/profile/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        apiClient: Get.find<ApiClient>(),
        fcmTokens: Get.isRegistered<FcmTokenSyncService>()
            ? Get.find<FcmTokenSyncService>()
            : null,
        repository: Get.find<AccountRepository>(),
        notificationDisplay: Get.find<NotificationDisplayService>(),
      ),
    );
  }
}
