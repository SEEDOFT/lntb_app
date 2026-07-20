import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/routes/app_routes.dart';

class SplashController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  void _initializeApp() async {
    try {
      // Artificial delay for splash screen visibility
      await Future.delayed(const Duration(seconds: 2));

      final token = await apiClient.storage.read(key: 'auth_token');
      final hasSeenOnboarding = await apiClient.storage.read(
        key: 'has_seen_onboarding',
      );

      if (token != null && token.isNotEmpty) {
        try {
          // Actively validate the token with the backend
          await apiClient.get(ApiEndpoints.me);
          Get.offAllNamed(Routes.MAIN);
        } catch (e) {
          // If the error was a 401, the ApiClient interceptor has already deleted the token
          // and routed the user to LOGIN. We only want to handle other errors (e.g. no internet)
          // here by letting them fall through or explicitly going to login just in case.
          final currentToken = await apiClient.storage.read(key: 'auth_token');
          if (currentToken != null) {
            // Token is still there, maybe it's just a network error, let's go to MAIN or show error
            // For now, let's just force them to login if validation fails for any reason
            Get.offAllNamed(Routes.LOGIN);
          }
        }
      } else if (hasSeenOnboarding == 'true') {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.offAllNamed(Routes.ONBOARDING);
      }
    } catch (e) {
      debugPrint('Splash screen error: $e');
      // Fallback if secure storage fails (common on some emulators or Windows)
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }
}
