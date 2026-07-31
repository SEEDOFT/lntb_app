import 'package:get/get.dart';
import 'package:lntb_app/core/controllers/language_controller.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/repositories/account_repository.dart';
import 'package:lntb_app/core/repositories/device_repository.dart';
import 'package:lntb_app/core/repositories/assistant_repository.dart';
import 'package:lntb_app/core/repositories/farm_dashboard_repository.dart';
import 'package:lntb_app/core/services/fcm_token_sync_service.dart';
import 'package:lntb_app/core/services/firebase_messaging_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final apiClient = Get.isRegistered<ApiClient>()
        ? Get.find<ApiClient>()
        : Get.put<ApiClient>(ApiClient(), permanent: true);

    if (!Get.isRegistered<LanguageController>()) {
      Get.put<LanguageController>(
        LanguageController(apiClient: apiClient),
        permanent: true,
      );
    }

    if (!Get.isRegistered<AccountRepository>()) {
      Get.put<AccountRepository>(
        AccountRepository(apiClient),
        permanent: true,
      );
    }

    if (!Get.isRegistered<DeviceRepository>()) {
      Get.put<DeviceRepository>(
        DeviceRepository(apiClient),
        permanent: true,
      );
    }

    if (!Get.isRegistered<FarmDashboardRepository>()) {
      Get.put<FarmDashboardRepository>(
        FarmDashboardRepository(apiClient),
        permanent: true,
      );
    }

    if (!Get.isRegistered<AssistantRepository>()) {
      Get.put<AssistantRepository>(
        AssistantRepository(apiClient),
        permanent: true,
      );
    }

    if (Get.isRegistered<FirebaseMessagingService>() &&
        !Get.isRegistered<FcmTokenSyncService>()) {
      final tokenSync = Get.put<FcmTokenSyncService>(
        FcmTokenSyncService(
          apiClient: apiClient,
          messaging: Get.find<FirebaseMessagingService>(),
        ),
        permanent: true,
      );
      tokenSync.start();
    }
  }
}
