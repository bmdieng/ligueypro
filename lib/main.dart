import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/network/firebase_bootstrap.dart';
import 'core/services/request_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseReady = await FirebaseBootstrap.initialize();
  debugPrint('Firebase ready: $firebaseReady');
  await RequestNotificationService.initialize();
  runApp(const ProviderScope(child: LigueyProApp()));
}
