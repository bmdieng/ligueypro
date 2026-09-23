import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../network/firebase_bootstrap.dart';

class RequestNotificationService {
  RequestNotificationService._();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'ligueypro_requests',
    'Demandes LigueyPro',
    description: 'Notifications pour chaque nouvelle demande reçu.',
    importance: Importance.max,
    playSound: true,
  );

  static Future<void> initialize() async {
    if (!FirebaseBootstrap.isReady) {
      debugPrint('Firebase not ready, skip FCM notification initialization.');
      return;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_channel);

    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (kDebugMode) {
        debugPrint('FCM permission status: ${settings.authorizationStatus}');
      }
    } catch (error) {
      debugPrint('FCM permission request failed: $error');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'Nouvelle demande';
      final body = message.notification?.body ?? 'Une demande a été soumise.';
      _showLocalNotification(title: title, body: body);
    });
  }

  static Future<void> sendRequestNotification({
    required String service,
    required String urgency,
    required String location,
    required String phone,
  }) async {
    final title = 'Nouvelle demande';
    final body = '$service • $urgency • $location';

    await _showLocalNotification(title: title, body: body);

    if (FirebaseBootstrap.isReady) {
      final notificationRef = FirebaseDatabase.instance.ref('notifications').push();
      await notificationRef.set({
        'title': title,
        'body': body,
        'service': service,
        'urgency': urgency,
        'location': location,
        'phone': phone,
        'createdAt': ServerValue.timestamp,
      });
    }
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'LigueyPro',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }
}
