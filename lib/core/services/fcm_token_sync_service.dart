import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/services/firebase_messaging_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FcmTokenSyncService {
  FcmTokenSyncService({
    required ApiClient apiClient,
    required FirebaseMessagingService messaging,
  })  : _apiClient = apiClient,
        _messaging = messaging;

  static const _deviceKeyStorageKey = 'fcm_device_key';

  final ApiClient _apiClient;
  final FirebaseMessagingService _messaging;
  StreamSubscription<String>? _refreshSubscription;
  PackageInfo? _packageInfo;

  void start() {
    _refreshSubscription ??= _messaging.onTokenRefresh.listen(
      (_) => syncAuthenticatedDevice(),
      onError: (Object error) {
        debugPrint('FCM token refresh failed: ${error.runtimeType}');
      },
    );
  }

  Future<Map<String, dynamic>> authenticationPayload() async {
    final metadata = await _deviceMetadata();
    final token = await _messaging.getToken();

    return {
      ...metadata,
      if (token != null && token.isNotEmpty) 'fcm_token': token,
    };
  }

  Future<void> syncAuthenticatedDevice() async {
    try {
      final authToken = await _apiClient.storage.read(key: 'auth_token');
      if (authToken == null || authToken.isEmpty) return;

      final payload = await authenticationPayload();
      if (!payload.containsKey('fcm_token')) return;

      await _apiClient.post(ApiEndpoints.fcmToken, data: payload);
    } catch (error) {
      debugPrint('FCM token synchronization failed: ${error.runtimeType}');
    }
  }

  Future<String> deviceKey() async {
    final existing = await _apiClient.storage.read(
      key: _deviceKeyStorageKey,
    );
    if (existing != null && existing.isNotEmpty) return existing;

    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    final generated = base64UrlEncode(bytes).replaceAll('=', '');
    await _apiClient.storage.write(
      key: _deviceKeyStorageKey,
      value: generated,
    );

    return generated;
  }

  Future<Map<String, dynamic>> logoutPayload() async {
    return {'fcm_device_key': await deviceKey()};
  }

  Future<Map<String, dynamic>> _deviceMetadata() async {
    try {
      _packageInfo ??= await PackageInfo.fromPlatform();
    } catch (error) {
      debugPrint('Package metadata unavailable: ${error.runtimeType}');
    }

    return {
      'fcm_device_key': await deviceKey(),
      'platform': defaultTargetPlatform.name,
      'device_name': '${defaultTargetPlatform.name} app',
      if (_packageInfo != null)
        'app_version': '${_packageInfo!.version}+${_packageInfo!.buildNumber}',
    };
  }
}
