import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/services/fcm_token_sync_service.dart';
import 'package:lntb_app/core/services/startup_route_resolver.dart';
import 'package:lntb_app/core/services/internet_status_service.dart';
import 'package:lntb_app/routes/app_routes.dart';

class SplashController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final FcmTokenSyncService? fcmTokens = Get.isRegistered<FcmTokenSyncService>()
      ? Get.find<FcmTokenSyncService>()
      : null;

  @override
  void onInit() {
    super.onInit();
    unawaited(_initializeApp());
  }

  Future<void> _initializeApp() async {
    try {
      final token = await apiClient.storage.read(key: 'auth_token');
      if (Get.isRegistered<InternetStatusService>() &&
          !await Get.find<InternetStatusService>().check()) {
        return;
      }
      final hasSeenOnboarding = await _readOnboardingFlag();
      final startupRoute = StartupRouteResolver.resolve(
        hasCompletedOnboarding: hasSeenOnboarding,
        authenticationToken: token,
      );

      if (startupRoute == Routes.ONBOARDING) {
        // Secure storage may survive an iOS reinstall while preferences do not.
        // A fresh onboarding state must also start without a stale session.
        await apiClient.storage.delete(key: 'auth_token');
        await Future<void>.delayed(const Duration(milliseconds: 2200));
        unawaited(Get.offAllNamed(Routes.ONBOARDING));
      } else if (startupRoute == Routes.MAIN) {
        try {
          await Future.wait([
            apiClient.get(ApiEndpoints.me),
            Future<void>.delayed(const Duration(milliseconds: 2200)),
          ]);
          await fcmTokens?.syncAuthenticatedDevice();
          unawaited(Get.offAllNamed(Routes.MAIN));
        } catch (e) {
          // If the error was a 401, the ApiClient interceptor has already deleted the token
          // and routed the user to LOGIN. We only want to handle other errors (e.g. no internet)
          // here by letting them fall through or explicitly going to login just in case.
          final currentToken = await apiClient.storage.read(key: 'auth_token');
          if (currentToken != null) {
            // Token is still there, maybe it's just a network error, let's go to MAIN or show error
            // For now, let's just force them to login if validation fails for any reason
            unawaited(Get.offAllNamed(Routes.LOGIN));
          }
        }
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 2200));
        unawaited(Get.offAllNamed(Routes.LOGIN));
      }
    } catch (e) {
      debugPrint('Splash screen error: $e');
      // Fallback if secure storage fails (common on some emulators or Windows)
      unawaited(Get.offAllNamed(Routes.ONBOARDING));
    }
  }

  Future<bool> _readOnboardingFlag() async {
    final prefs = await SharedPreferences.getInstance();
    final fromPrefs = prefs.getBool('has_seen_onboarding');
    if (fromPrefs != null) return fromPrefs;

    // Migrate from secure storage (legacy)
    final fromSecure = await apiClient.storage.read(key: 'has_seen_onboarding');
    if (fromSecure == 'true') {
      await prefs.setBool('has_seen_onboarding', true);
      await apiClient.storage.delete(key: 'has_seen_onboarding');
      return true;
    }

    return false;
  }
}
