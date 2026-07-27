import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/services/fcm_token_sync_service.dart';
import 'package:lntb_app/core/services/firebase_messaging_service.dart';
import 'package:lntb_app/core/services/language_service.dart';
import 'package:lntb_app/core/utils/app_logger.dart';
import 'package:lntb_app/firebase_options.dart';

class AppBootstrap {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Setup Custom Uncaught Error Logging Hooks
    _setupErrorLogging();

    AppLogger.info('AppBootstrap: Initializing application services...');

    // 2. Load Environment Variables
    try {
      await dotenv.load(fileName: '.env');
      AppLogger.info(
        'AppBootstrap: Environment variables loaded successfully.',
      );
    } catch (e, stackTrace) {
      AppLogger.error('AppBootstrap: Failed to load .env file', e, stackTrace);
    }

    // 3. Initialize Firebase Services
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      AppLogger.info('AppBootstrap: Firebase initialized.');

      final messaging = FirebaseMessagingService();
      await messaging.initialize();
      Get.put<FirebaseMessagingService>(messaging, permanent: true);
      AppLogger.info('AppBootstrap: Firebase Messaging initialized.');
    } catch (e, stackTrace) {
      AppLogger.error(
        'AppBootstrap: Firebase initialization failed (check config)',
        e,
        stackTrace,
      );
    }

    // 4. Initialize Core Dependencies (GetX)
    await _registerDependencies();

    AppLogger.info('AppBootstrap: Bootstrap sequence complete.');
  }

  static void _setupErrorLogging() {
    // Capture Flutter framework errors (e.g. build/layout phase)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      AppLogger.error(
        'Uncaught Flutter Framework Error: ${details.exceptionAsString()}',
        details.exception,
        details.stack,
      );
    };

    // Capture asynchronous platform errors outside Flutter framework
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      AppLogger.error('Uncaught Async/Platform Error', error, stack);
      return true;
    };
  }

  static Future<void> _registerDependencies() async {
    await Get.putAsync<LanguageService>(
      () => LanguageService().init(),
      permanent: true,
    );
    final apiClient = Get.put<ApiClient>(ApiClient(), permanent: true);

    if (Get.isRegistered<FirebaseMessagingService>()) {
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
