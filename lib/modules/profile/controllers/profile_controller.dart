import 'package:get/get.dart';
import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final RxBool isLoading = false.obs;

  Future<void> logout() async {
    try {
      isLoading.value = true;
      // Hit the logout API (ignore errors if it fails, we still want to log out locally)
      try {
        await apiClient.post(ApiEndpoints.logout);
      } catch (_) {}
    } finally {
      isLoading.value = false;
      // Clear token and navigate to login
      await apiClient.storage.delete(key: 'auth_token');
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
