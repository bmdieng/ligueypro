import 'package:permission_handler/permission_handler.dart';

class AppPermissionService {
  AppPermissionService._();

  static Future<bool> isNotificationEnabled() async {
    final status = await Permission.notification.status;
    return status.isGranted || status.isLimited || status.isProvisional;
  }

  static Future<bool> isLocationEnabled() async {
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted || status.isLimited;
  }

  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted || status.isLimited || status.isProvisional;
  }

  static Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted || status.isLimited;
  }

  static Future<bool> openSystemSettings() {
    return openAppSettings();
  }
}
