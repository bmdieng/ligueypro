import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../network/firebase_bootstrap.dart';
import 'app_preferences_service.dart';

class RequestNotificationService {
  RequestNotificationService._();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;
  static String? _lastHandledNotificationKey;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'ligueypro_requests',
    'Demandes LigueyPro',
    description: 'Notifications pour chaque nouvelle demande reçu.',
    importance: Importance.max,
    playSound: true,
  );

  static Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    if (!FirebaseBootstrap.isReady) {
      debugPrint('Firebase not ready, skip FCM notification initialization.');
      return;
    }

    _isInitialized = true;

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
      await FirebaseMessaging.instance.subscribeToTopic('all_devices');
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

    _lastHandledNotificationKey =
        await AppPreferencesService.getLastHandledNotificationKey();

    if (_lastHandledNotificationKey == null) {
      final latestSnapshot = await FirebaseDatabase.instance
          .ref('notifications')
          .orderByKey()
          .limitToLast(1)
          .get();
      final latestKey = latestSnapshot.children.isEmpty
          ? null
          : latestSnapshot.children.first.key;
      if (latestKey != null) {
        _lastHandledNotificationKey = latestKey;
        await AppPreferencesService.setLastHandledNotificationKey(latestKey);
      }
    }

    FirebaseDatabase.instance.ref('notifications').onChildAdded.listen((event) {
      final notificationKey = event.snapshot.key;
      if (notificationKey == null) {
        return;
      }

      final lastHandledNotificationKey = _lastHandledNotificationKey;
      if (lastHandledNotificationKey != null &&
          notificationKey.compareTo(lastHandledNotificationKey) <= 0) {
        return;
      }

      final payload = event.snapshot.value;
      if (payload is! Map) {
        return;
      }

      final broadcastToAll = payload['broadcastToAll'] == true;
      if (!broadcastToAll) {
        return;
      }

      final title = payload['title']?.toString() ?? 'Nouvelle demande';
      final body = payload['body']?.toString() ?? 'Une demande a été soumise.';
      _lastHandledNotificationKey = notificationKey;
      AppPreferencesService.setLastHandledNotificationKey(notificationKey);
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
      final notificationKey = notificationRef.key;
      if (notificationKey != null) {
        _lastHandledNotificationKey = notificationKey;
        await AppPreferencesService.setLastHandledNotificationKey(notificationKey);
      }
      await notificationRef.set({
        'title': title,
        'body': body,
        'service': service,
        'urgency': urgency,
        'location': location,
        'phone': phone,
        'targetTopic': 'all_devices',
        'broadcastToAll': true,
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
