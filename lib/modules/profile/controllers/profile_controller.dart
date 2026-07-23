import 'package:get/get.dart';
import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/services/fcm_token_sync_service.dart';
import 'package:lntb_app/routes/app_routes.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/repositories/account_repository.dart';

class ProfileController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final FcmTokenSyncService? fcmTokens = Get.isRegistered<FcmTokenSyncService>()
      ? Get.find<FcmTokenSyncService>()
      : null;
  final RxBool isLoading = false.obs;
  final user = Rxn<AppUser>();
  final AccountRepository repository = Get.find<AccountRepository>();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      user.value = await repository.getCurrentUser();
    } catch (_) {}
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      // Hit the logout API (ignore errors if it fails, we still want to log out locally)
      try {
        await apiClient.post(
          ApiEndpoints.logout,
          data: await fcmTokens?.logoutPayload(),
        );
      } catch (_) {}
    } finally {
      isLoading.value = false;
      // Clear token and navigate to login
      await apiClient.storage.delete(key: 'auth_token');
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
