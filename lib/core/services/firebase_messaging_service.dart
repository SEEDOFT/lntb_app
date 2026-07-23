import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:lntb_app/firebase_options.dart';
import 'package:lntb_app/modules/notifications/controllers/notification_controller.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('Handling a background message: ${message.messageId}');
}

class FirebaseMessagingService {
  static const _channel = AndroidNotificationChannel(
    'lntb_notifications',
    'LNTB Notifications',
    description: 'Account and smart farming notifications.',
    importance: Importance.high,
    playSound: true,
  );

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Stream<String> get onTokenRefresh => _firebaseMessaging.onTokenRefresh;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
        ),
      ),
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint('Got a message whilst in the foreground!');
      _syncUnreadCount(message.data);

      if (Platform.isAndroid && message.notification != null) {
        await _showAndroidNotification(message);
      }
    });
  }

  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
      return null;
    }
  }

  Future<void> _showAndroidNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final unreadCount =
        int.tryParse(message.data['unread_count']?.toString() ?? '') ?? 1;
    final notificationId =
        int.tryParse(message.data['notification_id']?.toString() ?? '') ??
            message.messageId.hashCode;

    await _localNotifications.show(
      id: notificationId,
      title: notification.title ?? 'LNTB',
      body: notification.body ?? '',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          number: unreadCount,
        ),
      ),
      payload: message.data['notification_id']?.toString(),
    );
  }

  void _syncUnreadCount(Map<String, dynamic> data) {
    final unreadCount = int.tryParse(data['unread_count']?.toString() ?? '');
    if (unreadCount == null) return;

    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().unreadCount.value = unreadCount;
    }
  }
}
