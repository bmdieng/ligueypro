import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/firebase_bootstrap.dart';

class CurrentProfessionalSummary {
  const CurrentProfessionalSummary({
    required this.professionalId,
    required this.name,
    required this.phone,
    required this.service,
    required this.planLabel,
  });

  final String professionalId;
  final String name;
  final String phone;
  final String service;
  final String planLabel;

  Map<String, dynamic> toJson() => {
        'professionalId': professionalId,
        'name': name,
        'phone': phone,
        'service': service,
        'planLabel': planLabel,
      };

  factory CurrentProfessionalSummary.fromJson(Map<String, dynamic> json) {
    return CurrentProfessionalSummary(
      professionalId: json['professionalId']?.toString() ?? 'professional',
      name: json['name']?.toString() ?? 'Professionnel',
      phone: json['phone']?.toString() ?? '+221 77 000 00 00',
      service: json['service']?.toString() ?? 'Service',
      planLabel: json['planLabel']?.toString() ?? 'pro',
    );
  }
}

class RecentRequestSummary {
  const RecentRequestSummary({
    this.requestId,
    required this.service,
    required this.urgency,
    required this.location,
    required this.status,
    required this.createdAt,
    this.offersStatus,
    this.offersCount,
    this.acceptedProfessionalId,
    this.acceptedProfessionalName,
    this.acceptedOfferPrice,
    this.acceptedOfferEta,
  });

  final String? requestId;
  final String service;
  final String urgency;
  final String location;
  final String status;
  final DateTime createdAt;
  final String? offersStatus;
  final int? offersCount;
  final String? acceptedProfessionalId;
  final String? acceptedProfessionalName;
  final String? acceptedOfferPrice;
  final String? acceptedOfferEta;

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'service': service,
        'urgency': urgency,
        'location': location,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'offersStatus': offersStatus,
        'offersCount': offersCount,
        'acceptedProfessionalId': acceptedProfessionalId,
        'acceptedProfessionalName': acceptedProfessionalName,
        'acceptedOfferPrice': acceptedOfferPrice,
        'acceptedOfferEta': acceptedOfferEta,
      };

  factory RecentRequestSummary.fromJson(Map<String, dynamic> json) {
    return RecentRequestSummary(
      requestId: json['requestId']?.toString(),
      service: json['service']?.toString() ?? 'Service',
      urgency: json['urgency']?.toString() ?? 'Standard',
      location: json['location']?.toString() ?? 'Dakar',
      status: json['status']?.toString() ?? 'pending',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      offersStatus: json['offersStatus']?.toString(),
      offersCount: json['offersCount'] is int
          ? json['offersCount'] as int
          : int.tryParse(json['offersCount']?.toString() ?? ''),
      acceptedProfessionalId: json['acceptedProfessionalId']?.toString(),
      acceptedProfessionalName: json['acceptedProfessionalName']?.toString(),
      acceptedOfferPrice: json['acceptedOfferPrice']?.toString(),
      acceptedOfferEta: json['acceptedOfferEta']?.toString(),
    );
  }
}

class AppPreferencesService {
  AppPreferencesService._();

  static const String _appLanguageCodeKey = 'settings.app_language_code';
  static const String _autoPlayPresentationKey =
      'settings.auto_play_presentation';
  static const String _recentRequestKey = 'home.recent_request';
  static const String _currentProfessionalKey = 'pro.current_professional';
  static const String _lastHandledNotificationKey =
      'notifications.last_handled_key';
  static const String _backOfficeUnlockedUntilKey =
      'bo.security.unlocked_until';
  static const String _backOfficeAccessCodePath =
      'security/backoffice/access_code';

  static const Duration _backOfficeSessionDuration = Duration(minutes: 30);

  static String _digitsOnly(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static String? _normalizeBackOfficeAccessCode(Object? value) {
    final digits = _digitsOnly(value?.toString() ?? '');
    if (digits.length == 6) {
      return digits;
    }
    return null;
  }

  static Future<String?> _readBackOfficeAccessCodeFromFirebase() async {
    if (!FirebaseBootstrap.isReady) {
      return null;
    }

    try {
      final snapshot =
          await FirebaseDatabase.instance.ref(_backOfficeAccessCodePath).get();
      return _normalizeBackOfficeAccessCode(snapshot.value);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> getAutoPlayPresentation() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_autoPlayPresentationKey) ?? true;
  }

  static Future<String?> getAppLanguageCode() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(_appLanguageCodeKey);
    if (languageCode == null || languageCode.isEmpty) {
      return null;
    }
    return languageCode;
  }

  static Future<void> setAppLanguageCode(String languageCode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_appLanguageCodeKey, languageCode);
  }

  static Future<void> setAutoPlayPresentation(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_autoPlayPresentationKey, value);
  }

  static Future<RecentRequestSummary?> getRecentRequest() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_recentRequestKey);
    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return RecentRequestSummary.fromJson(decoded);
  }

  static Future<void> setRecentRequest(RecentRequestSummary summary) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
        _recentRequestKey, jsonEncode(summary.toJson()));
  }

  static Future<void> clearRecentRequest() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_recentRequestKey);
  }

  static Future<CurrentProfessionalSummary?> getCurrentProfessional() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_currentProfessionalKey);
    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return CurrentProfessionalSummary.fromJson(decoded);
  }

  static Future<void> setCurrentProfessional(
    CurrentProfessionalSummary summary,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _currentProfessionalKey,
      jsonEncode(summary.toJson()),
    );
  }

  static Future<void> clearCurrentProfessional() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_currentProfessionalKey);
  }

  static Future<String?> getLastHandledNotificationKey() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(_lastHandledNotificationKey);
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  static Future<void> setLastHandledNotificationKey(String key) async {
    if (key.isEmpty) {
      return;
    }

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_lastHandledNotificationKey, key);
  }

  static Future<String> getBackOfficeAccessCode() async {
    final firebaseCode = await _readBackOfficeAccessCodeFromFirebase();
    if (firebaseCode != null) {
      return firebaseCode;
    }

    return '';
  }

  static Future<String> getBackOfficeAccessHint() async {
    final code = await getBackOfficeAccessCode();
    if (code.isEmpty) {
      return 'Code BO indisponible. Vérifiez la clé Firebase security/backoffice/access_code.';
    }

    return 'Code BO actif dans Firebase : ${code.substring(0, 3)}- *** (6 chiffres)';
  }

  static Future<bool> verifyBackOfficeAccessCode(String code) async {
    final normalized = _digitsOnly(code);
    final expected = await getBackOfficeAccessCode();
    return normalized == expected;
  }

  static Future<String?> getCustomBackOfficeAccessCode() async {
    final code = await getBackOfficeAccessCode();
    return code.isEmpty ? null : code;
  }

  static Future<void> setCustomBackOfficeAccessCode(String code) async {
    final normalized = _digitsOnly(code);
    if (normalized.length != 6) {
      throw ArgumentError('Le code doit contenir exactement 6 chiffres.');
    }

    if (!FirebaseBootstrap.isReady) {
      throw StateError(
          'Firebase indisponible. Impossible de modifier le code BO.');
    }

    await FirebaseDatabase.instance
        .ref(_backOfficeAccessCodePath)
        .set(normalized);
    await lockBackOffice();
  }

  static Future<void> clearCustomBackOfficeAccessCode() async {
    if (!FirebaseBootstrap.isReady) {
      throw StateError(
          'Firebase indisponible. Impossible de supprimer le code BO.');
    }

    await FirebaseDatabase.instance.ref(_backOfficeAccessCodePath).remove();
    await lockBackOffice();
  }

  static Future<void> unlockBackOffice() async {
    final preferences = await SharedPreferences.getInstance();
    final unlockedUntil = DateTime.now().add(_backOfficeSessionDuration);
    await preferences.setInt(
      _backOfficeUnlockedUntilKey,
      unlockedUntil.millisecondsSinceEpoch,
    );
  }

  static Future<bool> isBackOfficeUnlocked() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getInt(_backOfficeUnlockedUntilKey);
    if (value == null) {
      return false;
    }

    return DateTime.now().isBefore(
      DateTime.fromMillisecondsSinceEpoch(value),
    );
  }

  static Future<void> lockBackOffice() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_backOfficeUnlockedUntilKey);
  }

  static Future<void> updateRecentRequestStatus({
    required String requestId,
    String? status,
    String? offersStatus,
    int? offersCount,
    String? acceptedProfessionalId,
    String? acceptedProfessionalName,
    String? acceptedOfferPrice,
    String? acceptedOfferEta,
  }) async {
    final current = await getRecentRequest();
    if (current == null || current.requestId != requestId) {
      return;
    }

    await setRecentRequest(
      RecentRequestSummary(
        requestId: current.requestId,
        service: current.service,
        urgency: current.urgency,
        location: current.location,
        status: status ?? current.status,
        createdAt: current.createdAt,
        offersStatus: offersStatus ?? current.offersStatus,
        offersCount: offersCount ?? current.offersCount,
        acceptedProfessionalId:
            acceptedProfessionalId ?? current.acceptedProfessionalId,
        acceptedProfessionalName:
            acceptedProfessionalName ?? current.acceptedProfessionalName,
        acceptedOfferPrice: acceptedOfferPrice ?? current.acceptedOfferPrice,
        acceptedOfferEta: acceptedOfferEta ?? current.acceptedOfferEta,
      ),
    );
  }
}
