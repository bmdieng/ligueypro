import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool get isReady => Firebase.apps.isNotEmpty;


  static Future<bool> initialize() async {
    if (isReady) return true;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('Firebase OK: ${Firebase.apps.length} apps initialized');
      return true;
    } catch (e, stack) {
      debugPrint('Firebase init failed: $e');
      debugPrintStack(stackTrace: stack);
      return false;
    }
  }
}
