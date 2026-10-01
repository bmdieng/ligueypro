import 'package:firebase_database/firebase_database.dart';

import 'professional_admin_service.dart';

class ProfessionalOffer {
  const ProfessionalOffer({
    required this.id,
    required this.name,
    required this.priceFcfa,
    required this.leadsPerMonth,
    required this.billingLabel,
    required this.paymentMethod,
    required this.features,
  });

  final String id;
  final String name;
  final int priceFcfa;
  final int leadsPerMonth;
  final String billingLabel;
  final String paymentMethod;
  final List<String> features;

  factory ProfessionalOffer.fromMap(String id, Map<dynamic, dynamic> map) {
    return ProfessionalOffer(
      id: id,
      name: map['name']?.toString() ?? id,
      priceFcfa: int.tryParse('${map['priceFcfa']}') ?? 0,
      leadsPerMonth: int.tryParse('${map['leadsPerMonth']}') ?? 0,
      billingLabel: map['billingLabel']?.toString() ?? '/mois',
      paymentMethod: map['paymentMethod']?.toString() ?? 'Orange Money',
      features: (map['features'] as List<dynamic>? ?? [])
          .map((entry) => entry.toString())
          .toList(),
    );
  }
}

class ProfessionalCreditService {
  ProfessionalCreditService._();

  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static int calculateUpdatedBalance({
    required int currentBalance,
    required int offerLeads,
  }) {
    return currentBalance + offerLeads;
  }

  static bool isBoostActive({
    required int boostUntil,
    DateTime? now,
  }) {
    final currentTime = (now ?? DateTime.now()).millisecondsSinceEpoch;
    return boostUntil > currentTime;
  }

  static String formatBoostStatus({
    required int boostUntil,
    DateTime? now,
  }) {
    final currentTime = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final remainingMs = boostUntil - currentTime;

    if (remainingMs <= 0) {
      return 'Boost inactif';
    }

    final duration = Duration(milliseconds: remainingMs);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    final tokens = <String>[];
    if (days > 0) {
      tokens.add('${days}j');
    }
    if (hours > 0) {
      tokens.add('${hours}h');
    }
    if (minutes > 0 && days == 0) {
      tokens.add('${minutes}m');
    }

    final label = tokens.isEmpty ? 'moins d’1m' : tokens.join(' ');
    return 'Boost actif • $label restant';
  }

  static Future<Map<String, dynamic>> getProfessionalAccount({
    required String professionalId,
    required String professionalService,
  }) async {
    final professionalRef = _database.ref(
      'professionals/$professionalService/$professionalId',
    );

    final snapshot = await professionalRef.get();
    final data = snapshot.value;
    final currentMap = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};

    return {
      'professionalId': professionalId,
      'professionalService': professionalService,
      'creditBalance': int.tryParse('${currentMap['creditBalance'] ?? 0}') ?? 0,
      'boostUntil': int.tryParse('${currentMap['boostUntil'] ?? 0}') ?? 0,
      'subscribed': currentMap['subscribed'] == true,
      'planLabel': currentMap['subscriptionPlan']?.toString() ?? 'starter',
      'updatedAt': currentMap['updatedAt'],
    };
  }

  static Future<List<ProfessionalOffer>> getOffers() async {
    final snapshot = await _database.ref('offers').get();
    final data = snapshot.value;

    if (data is! Map) {
      return const <ProfessionalOffer>[];
    }

    final offers = <ProfessionalOffer>[];
    for (final entry in data.entries) {
      final value = entry.value;
      if (value is Map) {
        offers.add(
          ProfessionalOffer.fromMap(
            entry.key.toString(),
            Map<String, dynamic>.from(value),
          ),
        );
      }
    }

    return offers;
  }

  static Future<ProfessionalOffer?> getOfferById(String offerId) async {
    final offers = await getOffers();
    for (final offer in offers) {
      if (offer.id == offerId) {
        return offer;
      }
    }
    return null;
  }

  static Future<void> createPaymentRequest({
    required String professionalId,
    required String professionalName,
    required String professionalService,
    required String offerId,
    required int amountFcfa,
    required String paymentMethod,
  }) async {
    final paymentRef = _database.ref('payments').push();
    await paymentRef.set({
      'id': paymentRef.key,
      'professionalId': professionalId,
      'professionalName': professionalName,
      'professionalService': professionalService,
      'offerId': offerId,
      'amountFcfa': amountFcfa,
      'paymentMethod': paymentMethod,
      'status': 'pending',
      'createdAt': ServerValue.timestamp,
    });
  }

  static Future<List<Map<String, dynamic>>> getPendingPayments() async {
    final snapshot = await _database.ref('payments').get();
    final data = snapshot.value;

    if (data is! Map) {
      return const <Map<String, dynamic>>[];
    }

    final results = <Map<String, dynamic>>[];
    for (final entry in data.entries) {
      final value = entry.value;
      if (value is Map) {
        final map = Map<String, dynamic>.from(value);
        if (map['status'] == 'pending') {
          map['paymentId'] = entry.key.toString();
          results.add(map);
        }
      }
    }

    return results;
  }

  static Future<void> approvePaymentAndCredit({
    required String paymentId,
    required String professionalId,
    required String professionalService,
    required String offerId,
  }) async {
    final offer = await getOfferById(offerId);
    if (offer == null) {
      return;
    }

    final professionalRef = _database.ref(
      'professionals/$professionalService/$professionalId',
    );

    final professionalSnapshot = await professionalRef.get();
    final professionalData = professionalSnapshot.value;
    final currentMap = professionalData is Map
        ? Map<String, dynamic>.from(professionalData)
        : <String, dynamic>{};

    final currentBalance =
        int.tryParse('${currentMap['creditBalance'] ?? 0}') ?? 0;
    final nextBalance = calculateUpdatedBalance(
      currentBalance: currentBalance,
      offerLeads: offer.leadsPerMonth,
    );

    final subscriptionState = ProfessionalAdminService.buildSubscriptionState(
      subscribed: true,
      subscriptionPlan: offerId,
      creditBalance: nextBalance,
    );

    await professionalRef.update({
      ...subscriptionState,
      'updatedAt': ServerValue.timestamp,
    });

    await _database.ref('payments/$paymentId').update({
      'status': 'approved',
      'approvedAt': ServerValue.timestamp,
    });
  }

  static Future<void> consumeCredit({
    required String professionalId,
    required String professionalService,
  }) async {
    final professionalRef = _database.ref(
      'professionals/$professionalService/$professionalId',
    );

    final snapshot = await professionalRef.get();
    final data = snapshot.value;
    final currentMap = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};

    final existing = int.tryParse('${currentMap['creditBalance'] ?? 0}') ?? 0;
    if (existing <= 0) {
      return;
    }

    await professionalRef.update({
      'creditBalance': existing - 1,
      'updatedAt': ServerValue.timestamp,
    });
  }

  static Future<void> activateBoost({
    required String professionalId,
    required String professionalService,
    required int days,
  }) async {
    final professionalRef = _database.ref(
      'professionals/$professionalService/$professionalId',
    );
    final boostUntil = DateTime.now()
        .add(Duration(days: days))
        .millisecondsSinceEpoch;

    await professionalRef.update({
      'boostUntil': boostUntil,
      'updatedAt': ServerValue.timestamp,
    });
  }
}
