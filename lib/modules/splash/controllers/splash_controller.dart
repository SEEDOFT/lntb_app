import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/services/fcm_token_sync_service.dart';
import 'package:lntb_app/routes/app_routes.dart';

class SplashController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final FcmTokenSyncService? fcmTokens = Get.isRegistered<FcmTokenSyncService>()
      ? Get.find<FcmTokenSyncService>()
      : null;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  void _initializeApp() async {
    try {
      final token = await apiClient.storage.read(key: 'auth_token');
      final hasSeenOnboarding = await apiClient.storage.read(
        key: 'has_seen_onboarding',
      );

      if (token != null && token.isNotEmpty) {
        try {
          await Future.wait([
            apiClient.get(ApiEndpoints.me),
            Future<void>.delayed(const Duration(milliseconds: 2200)),
          ]);
          await fcmTokens?.syncAuthenticatedDevice();
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
        await Future<void>.delayed(const Duration(milliseconds: 2200));
        Get.offAllNamed(Routes.LOGIN);
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 2200));
        Get.offAllNamed(Routes.ONBOARDING);
      }
    } catch (e) {
      debugPrint('Splash screen error: $e');
      // Fallback if secure storage fails (common on some emulators or Windows)
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }
}
